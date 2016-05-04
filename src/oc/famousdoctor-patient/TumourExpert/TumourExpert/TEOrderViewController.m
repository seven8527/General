//
//  TEOrderViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-30.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEOrderViewController.h"
#import "TEOrderModel.h"
#import "TEResultModel.h"
#import "TEOrderCell.h"
#import "TEUITools.h"
#import "UIColor+Hex.h"
#import "TEOrder.h"
#import "TEAppDelegate.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SVPullToRefresh.h"
#import "UIImageView+NetLoading.h"

#import "PartnerConfig.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"

#import "TEHttpTools.h"

// 订单支付状态
typedef NS_ENUM(NSInteger, TEOrderPayState)
{
    TEOrderPayStateNoPay,    // 未支付
    TEOrderPayStateFinished  // 支付完成
};

// 订单类型
typedef NS_ENUM(NSInteger, TEOrderType) {
    TEOrderTypeImage    = 0,  // 网络咨询
    TEOrderTypePhone    = 1,  // 电话咨询
};

@interface TEOrderViewController ()
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, assign) NSInteger currentPage; // 当前是第几页
@property (nonatomic, assign) NSInteger totalPage; // 总页数
@property (nonatomic, assign) NSInteger number; // 每页显示几条记录
@end

@implementation TEOrderViewController

#pragma mark - DataSource

- (void)loadDataSource {
    [self fetchOrder];
}

#pragma mark - UIViewController lifecycle

- (id)init
{
    if (self = [super init]) {
        _number = 20;
        _currentPage = 0;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.dataSource removeAllObjects];
            _currentPage = 0;
            [self loadDataSource];
        });
    };
    
    reach.unreachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Failmark.png"]];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.labelText = @"似乎已断开与互联网的连接";
            [HUD hide:YES afterDelay:2];
        });
    };
    
    [reach startNotifier];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configUI];
    
    _result = @selector(paymentResult:);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

// UI设置
- (void)configUI
{
    self.title = @"我的订单";
    
    //修复下拉刷新位置错误 代码开始
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.tableView.contentInset;
        insets.top = self.navigationController.navigationBar.bounds.size.height +
        [UIApplication sharedApplication].statusBarFrame.size.height;
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }
    //修复下拉刷新位置错误  代码结束
    
    __weak TEOrderViewController *weakSelf = self;
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        if (weakSelf.currentPage < weakSelf.totalPage) {
            [weakSelf addMoreRow];
        } else {
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
        }
    }];
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    TEOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[TEOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    TEOrderModel *order = [self.dataSource objectAtIndex:indexPath.row];
    cell.orderIDLabel.text = order.orderId;
     [cell.iconImageView accordingToNetLoadImagewithUrlstr:order.expertIcon and:@"logo.png"];
    cell.doctorLabel.text = order.expertName;
    cell.titleLabel.text = order.expertTitle;
    cell.hospitalLabel.text = order.hospitalName;
    
    if (order.orderType == TEOrderTypeImage) {
        cell.askTypeLabel.text = @"网络咨询";
    } else if (order.orderType == TEOrderTypePhone) {
        cell.askTypeLabel.text = @"电话咨询";
    }
    cell.priceLabel.text =  [NSString stringWithFormat:@"￥%@", order.orderPrice];
    cell.timeLabel.text = order.orderTime;
    switch (order.orderState) {
        case TEOrderPayStateNoPay:
            cell.stateLabel.text = @"未支付";
            cell.cancelOrderButton.hidden = NO;
            [cell.cancelOrderButton setTitle:@"取消订单" forState:UIControlStateNormal];
            objc_setAssociatedObject(cell.cancelOrderButton, "orderId", order.orderId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            objc_setAssociatedObject(cell.cancelOrderButton, "row", [NSString stringWithFormat:@"%d", indexPath.row], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [cell.cancelOrderButton addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
            cell.payButton.hidden = NO;
            [cell.payButton setTitle:@"点击支付" forState:UIControlStateNormal];
            objc_setAssociatedObject(cell.payButton, "orderModel", order, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [cell.payButton addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
            break;
        case TEOrderPayStateFinished:
            cell.stateLabel.text = @"已支付";
            cell.cancelOrderButton.hidden = YES;
            cell.payButton.hidden = YES;
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TEOrderCell rowHeightWitObject:[self.dataSource objectAtIndex:indexPath.row]];
}

#pragma mark - API methods

// 获取订单
- (void)fetchOrder
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"order"];
    NSDictionary *parameters = @{@"userid": ApplicationDelegate.userId, @"start": [NSString stringWithFormat:@"%d", _currentPage * _number], @"end": [NSString stringWithFormat:@"%d", _number]};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        TEOrder *order = [[TEOrder alloc] initWithDictionary:responseObject error:nil];
        _totalPage = (order.total % _number == 0) ? order.total / _number : order.total / _number + 1;
        [self.dataSource addObjectsFromArray:order.orders];
        
        if ([self.dataSource count] == 0) {
            self.titleForEmpty = @"当前没有订单";
        }
        
        [self.tableView reloadData];
        _currentPage++;
        
        [hud hide:YES];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
        [hud hide:YES];
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        TEOrder *order = [[TEOrder alloc] initWithDictionary:responseObject error:nil];
//        _totalPage = (order.total % _number == 0) ? order.total / _number : order.total / _number + 1;
//        [self.dataSource addObjectsFromArray:order.orders];
//        
//        if ([self.dataSource count] == 0) {
//            self.titleForEmpty = @"当前没有订单";
//        }
//        
//        [self.tableView reloadData];
//        _currentPage++;
//        
//        [hud hide:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        [hud hide:YES];
//    }];
}

- (void)cancelOrder:(id)sender
{
    id orderId = objc_getAssociatedObject(sender, "orderId");
    NSString *row = objc_getAssociatedObject(sender, "row");
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"cancelbillno"];
    NSDictionary *parameters = @{@"billno": orderId};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        TEResultModel *result = [[TEResultModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = result.state;
        if ([state isEqualToString:@"201"]) {
            [self.dataSource removeObjectAtIndex:[row integerValue]];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消订单成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消订单失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        TEResultModel *result = [[TEResultModel alloc] initWithDictionary:responseObject error:nil];
//        NSString *state = result.state;
//        if ([state isEqualToString:@"201"]) {
//            [self.dataSource removeObjectAtIndex:[row integerValue]];
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消订单成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//        } else {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消订单失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//        }
//        
//        [self.tableView reloadData];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
}

- (void)finishedPay
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"paysuccess"];
    NSDictionary *parameters = @{@"billno": self.orderId, @"cookie": ApplicationDelegate.cookie};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        
//        [self.tableView reloadData];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
}

// 加载更多
- (void)addMoreRow
{
    __weak TEOrderViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self fetchOrder];
        
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });
}

#pragma mark - Pay method

// 点击支付
- (void)pay:(id)sender
{
    /*
	 *生成订单信息及签名
	 *由于demo的局限性，采用了将私钥放在本地签名的方法，商户可以根据自身情况选择签名方法(为安全起见，在条件允许的前提下，我们推荐从商户服务器获取完整的订单信息)
	 */
    
    id orderModel = objc_getAssociatedObject(sender, "orderModel");
    
    NSString *appScheme = @"SINOTumourExpert";
    NSString *orderInfo = [self getOrderInfo:orderModel];
    NSString *signedStr = [self doRsa:orderInfo];
    
    NSLog(@"signedStr:%@",signedStr);
    
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderInfo, signedStr, @"RSA"];
	
    [AlixLibService payOrder:orderString AndScheme:appScheme seletor:_result target:self];
    ApplicationDelegate.orderId = self.orderId;
}

-(NSString*)getOrderInfo:(TEOrderModel *)orderModel
{
    /*
	 *点击获取prodcut实例并初始化订单信息
	 */
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
    order.tradeNO = orderModel.orderId; //订单ID
	order.productName = orderModel.expertName; //商品标题
	order.productDescription = orderModel.expertTitle; //商品描述
	order.amount = orderModel.orderPrice; //商品价格
	order.notifyURL = [kURL stringByAppendingString:@"apliay/notify.php"]; //回调URL
    
    self.orderId = orderModel.orderId;
	
	return [order description];
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

-(void)paymentResultDelegate:(NSString *)result
{
    NSLog(@"%@",result);
}

//wap回调函数
-(void)paymentResult:(NSString *)resultd
{
    //结果处理
#if ! __has_feature(objc_arc)
    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
#else
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
#endif
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
			id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                
                NSLog(@"验证签名成功");
                
                //验证签名成功，交易结果无篡改
                //[self finishedPay];
                self.hidesBottomBarWhenPushed = YES;
                UIViewController <TEPaySuccessViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPaySuccessViewControllerProtocol)];
                [self.navigationController pushViewController:viewController animated:YES];
                
			}
        }
        else
        {
            //交易失败
            self.hidesBottomBarWhenPushed = YES;
            UIViewController <TEPayFailureViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPayFailureViewControllerProtocol)];
            [self.navigationController pushViewController:viewController animated:YES];
            NSLog(@"交易失败");
        }
    }
    else
    {
        //失败
        self.hidesBottomBarWhenPushed = YES;
        UIViewController <TEPayFailureViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPayFailureViewControllerProtocol)];
        [self.navigationController pushViewController:viewController animated:YES];
        
        NSLog(@"失败");
    }
    
}

@end
