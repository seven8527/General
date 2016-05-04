//
//  TEOrderSubmitViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-18.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEOrderSubmitViewController.h"
#import "TEUITools.h"
#import "UIColor+Hex.h"
#import "TEAskModel.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "TEAppDelegate.h"
#import "TEExpertCell.h"
#import "TEOrderSubmitInstructionCell.h"
#import "TEOrderModel.h"
#import "TEResultOrderModel.h"
#import "UIImageView+NetLoading.h"
#import "TEHttpTools.h"

@interface TEOrderSubmitViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger payModeId; // 支付方式Id
@property (nonatomic, strong) NSString *payModeName; // 支付方式
@property (nonatomic, strong) NSString *orderId;

@end

@implementation TEOrderSubmitViewController

#pragma mark - UIViewController lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configUI];
    
    [self layoutUI];
    
    self.payModeId = -1;
    self.payModeName = @"请选择支付方式";
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fetchOrder];
        });
    };
    
    [reach startNotifier];
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"提交订单";
}

// UI布局
- (void)layoutUI
{
    // Create a UITableView
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [TEUITools hiddenTableExtraCellLine:self.tableView];
    [self.view addSubview:self.tableView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 91)];
    // 画线
    UIImageView *separatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 1)];
    UIImage *image = [UIImage imageNamed:@"line_d1d1d1.png"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    separatorLine.image = image;
    [view addSubview:separatorLine];
    // 按钮
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(21, 20, 277, 51);
    [submitButton setTitle:@"提交订单" forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitOrder:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:submitButton];
    self.tableView.tableFooterView = view;
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell;
    TEExpertCell *expertCell;
    TEOrderSubmitInstructionCell *instructionCell;
    
    if (indexPath.row == 0) {
        if (!expertCell) {
            expertCell = [[TEExpertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            expertCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        expertCell.doctorLabel.text = _askModel.expertName;
        expertCell.titleLabel.text = _askModel.expertTitle;
        expertCell.hospitalLabel.text = _askModel.hospitalName;
        expertCell.departmentLabel.text = _askModel.department;
         [expertCell.iconImageView accordingToNetLoadImagewithUrlstr:_askModel.expertIcon and:@"logo.png"];
        return expertCell;
    } else if (indexPath.row == 4) {
        if (!instructionCell) {
            instructionCell = [[TEOrderSubmitInstructionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            instructionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (self.payModeId == 1) {
            instructionCell.payType = 1;
        } else if (self.payModeId == 2) {
            instructionCell.payType = 2;
        }
        
        return instructionCell;
    } else {
        cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        
        if (indexPath.row == 1) {
            NSString *type;
            UIColor *typeColor;
            if ([self.consultType isEqualToString:@"0"]) {
                type = @"网络咨询";
                typeColor = [UIColor colorWithHex:0x00947d];
            } else if ([self.consultType isEqualToString:@"1"]) {
                type = @"电话咨询";
                typeColor = [UIColor colorWithHex:0xe47929];
            }
            
            // 文字描述
            NSArray *words = @[@{@"类型：": [UIColor colorWithHex:0x383838]},
                               @{type: typeColor}];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
            for (NSDictionary *wordToColorMapping in words) {
                for (NSString *word in wordToColorMapping) {
                    UIColor *color = [wordToColorMapping objectForKey:word];
                    NSDictionary *attributes = @{NSForegroundColorAttributeName : color, NSFontAttributeName : [UIFont boldSystemFontOfSize:14]};
                    NSAttributedString *subString = [[NSAttributedString alloc] initWithString:word attributes:attributes];
                    [string appendAttributedString:subString];
                }
            }
            cell.textLabel.attributedText = string;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        } else if (indexPath.row == 2) {
            // 文字描述
            NSArray *words = @[@{@"价格：": [UIColor colorWithHex:0x383838]},
                               @{[@"￥" stringByAppendingString: _askModel.price]: [UIColor colorWithHex:0xe47929]}];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
            for (NSDictionary *wordToColorMapping in words) {
                for (NSString *word in wordToColorMapping) {
                    UIColor *color = [wordToColorMapping objectForKey:word];
                    NSDictionary *attributes = @{NSForegroundColorAttributeName : color, NSFontAttributeName : [UIFont boldSystemFontOfSize:14]};
                    NSAttributedString *subString = [[NSAttributedString alloc] initWithString:word attributes:attributes];
                    [string appendAttributedString:subString];
                }
            }
            cell.textLabel.attributedText = string;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        } else if (indexPath.row == 3) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
            cell.textLabel.text = @"选择支付方式";
            cell.detailTextLabel.text = self.payModeName;
        }
        return cell;
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        UIViewController <TEChoosePayModeViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEChoosePayModeViewControllerProtocol)];
        viewController.delegate = self;
        [self.navigationController pushViewController:viewController animated:NO];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    } else if (indexPath.row == 4) {
        return [TEOrderSubmitInstructionCell rowHeight:self.payModeId];
    }
    
    return 44;
}

#pragma mark - TEChoosePayModeViewControllerDelegate

- (void)didSelectedPayModeId:(NSInteger)payModeId payModeName:(NSString *)payModeName
{
    self.payModeId = payModeId;
    self.payModeName = payModeName;
    
    [self.tableView reloadData];
}

#pragma mark - Bussiness methods

// 提交订单
- (void)submitOrder:(id)sender
{
    if ([self validatePayModeId:self.payModeId]) {
        self.hidesBottomBarWhenPushed = YES;
        
        UIViewController <TEOrderSuccessViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEOrderSuccessViewControllerProtocol)];
        TEOrderModel *orderModel  = [[TEOrderModel alloc] init];
        orderModel.orderId = _orderId;
        orderModel.expertName  = _askModel.expertName;
        orderModel.expertTitle = _askModel.expertTitle;
        orderModel.orderPrice = _askModel.price;
        viewController.orderModel = orderModel;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

// 获取订单信息
- (void)fetchOrder
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"conorder"];
    NSDictionary *parameters = @{@"uid": ApplicationDelegate.userId, @"doctorid": _askModel.expertId, @"price": _askModel.price, @"proid": _askModel.productId, @"type": self.consultType, @"patientid": self.patientId, @"ziliaoid": self.patientDataId, @"cookie": ApplicationDelegate.cookie};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        
        TEResultOrderModel *resultModel = [[TEResultOrderModel alloc] initWithDictionary:responseObject error:nil];
        if ([resultModel.state isEqualToString:@"203"]) {
            self.orderId = resultModel.billno;
        }

    } failure:^(NSError *error) {
        
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        
//        TEResultOrderModel *resultModel = [[TEResultOrderModel alloc] initWithDictionary:responseObject error:nil];
//        if ([resultModel.state isEqualToString:@"203"]) {
//            self.orderId = resultModel.billno;
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
}

#pragma mark - Validate

// 验证患者和患者资料
- (BOOL)validatePayModeId:(NSInteger)payModeId
{
    if (payModeId == -1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择支付方式" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}

@end
