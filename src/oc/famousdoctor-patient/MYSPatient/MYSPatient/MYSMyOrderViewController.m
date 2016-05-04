//
//  MYSMyOrderViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-29.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSMyOrderViewController.h"
#import "MYSCollectionViewCell.h"
#import "UIColor+Hex.h"
#import "AppDelegate.h"
#import "HttpTool.h"
#import "MYSOrderModel.h"
#import "MYSOrders.h"
#import "MJRefresh/MJRefresh.h"


@interface MYSMyOrderViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, assign) int totalMessage;
@property (nonatomic, weak) UIImageView *sadImageView;
@property (nonatomic, weak) UILabel *sadTextLabel;
@property (nonatomic, assign) BOOL fisrtLoad;
@end

@implementation MYSMyOrderViewController

static  NSString *orderCollection = @"orderCollectionCell";
- (id)init
{
    // 1.流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 2.每个cell的尺寸
    layout.itemSize = CGSizeMake(kScreen_Width - 20, 157);
    // 3.设置cell之间的水平间距
    layout.minimumInteritemSpacing = 0;
    // 4.设置cell之间的垂直间距
    layout.minimumLineSpacing = 5;
    // 5.设置四周的内边距
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    return [super initWithCollectionViewLayout:layout];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fisrtLoad = YES;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessPersonal:) name:@"paySuccessPersonal" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exchangeUser:) name:@"exchangeUser" object:nil];
    
    UIImageView *sadImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width - 60) / 2, (kScreen_Height - 160) / 2 -60, 60, 60)];
    sadImageView.image = [UIImage imageNamed:@"search_icon_none_"];
    self.sadImageView = sadImageView;
    self.sadImageView.hidden = YES;
    [self.view addSubview:sadImageView];
    
    
    UILabel *sadTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sadImageView.frame) + 10, kScreen_Width, 40)];
    self.sadTextLabel = sadTextLabel;
    sadTextLabel.textColor = [UIColor lightGrayColor];
    sadTextLabel.text = @"无订单";
    sadTextLabel.textAlignment = NSTextAlignmentCenter;
    sadTextLabel.hidden = YES;
    [self.view addSubview:sadTextLabel];

    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerClass:[MYSCollectionViewCell class] forCellWithReuseIdentifier:orderCollection];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    LOG(@"viewdid%@",ApplicationDelegate.userId);
    
    LOG(@"%@",self.view);
    
    
    
    if (self.fisrtLoad == YES) {
        [self fetchAllOrder];
        [self addFooter];
        [self addHeader];
        self.fisrtLoad = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 更换账号
- (void)exchangeUser:(NSNotification *)notification
{
    LOG(@"exchange%@",ApplicationDelegate.userId);
    [self.dataSource removeAllObjects];
    
    [self fetchAllOrder];
    
//    [self addHeader];
//    
//    [self addFooter];
    
}

- (void)paySuccessPersonal:(NSNotification *)notification
{
    [self.dataSource removeAllObjects];
    
    [self fetchAllOrder];
    
//    [self addHeader];
//    
//    [self addFooter];
    
}


- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    
    [vc.collectionView addFooterWithCallback:^{
        if (self.dataSource.count < self.totalMessage) {

            [vc fetchAllOrder];
            [vc.collectionView footerEndRefreshing];
        } else {
            vc.collectionView.footerRefreshingText = @"已加载全部数据";
            [vc.collectionView footerEndRefreshing];
        }
    }];
}

-(void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    
    [vc.collectionView headerBeginRefreshing];
    [vc.collectionView addHeaderWithCallback:^{
        [vc.dataSource removeAllObjects];
        [vc fetchAllOrder];
        [vc.collectionView headerEndRefreshing];
        
    } dateKey:@"table"];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MYSCollectionViewCell * orderCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:orderCollection forIndexPath:indexPath];
    if (orderCollectionCell == nil) {
        orderCollectionCell = [[MYSCollectionViewCell alloc] init];
    }
    if(self.dataSource.count !=0) {
        orderCollectionCell.orderModel = self.dataSource[indexPath.item];
    }
    return orderCollectionCell;
}


float lastContentOffset;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    LOG(@"开始拖动");
    lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (lastContentOffset > scrollView.contentOffset.y) {
        LOG(@"12向下滚动");
        if(self.collectionView.contentOffset.y > 0) {
            
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollDown" object:nil];
        }
    } else {
        LOG(@"12向上滚动");
         if(self.collectionView.contentOffset.y > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollUp" object:nil];
         }
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (lastContentOffset < scrollView.contentOffset.y) {
        LOG(@"向上滚动");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollUp" object:nil];
    }else{
        LOG(@"向下滚动");
        if(self.collectionView.contentOffset.y > 0) {
        
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollDown" object:nil];
        }
    }
}


#pragma mark - API methods

// 获取订单列表
- (void)fetchAllOrder
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"mybill"];
    NSDictionary *parameters = @{@"userid": ApplicationDelegate.userId, @"start": [NSString stringWithFormat:@"%lu",(unsigned long)self.dataSource.count], @"end" :@"10"};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
//        LOG(@"%@", responseObject);
        self.totalMessage = [[responseObject objectForKey:@"total"] intValue];
        MYSOrders *consultOrders = [[MYSOrders alloc] initWithDictionary:responseObject error:nil];
        [self.dataSource addObjectsFromArray:consultOrders.orders];
        
        if (self.dataSource.count > 0) {
            self.sadTextLabel.hidden = YES;
            self.sadImageView.hidden = YES;
        } else {
            self.sadTextLabel.hidden = NO;
            self.sadImageView.hidden = NO;
        }
        [self.collectionView reloadData];
        [hud hide:YES];
    } failure:^(NSError *error) {
        LOG(@"%@",error);
        [hud hide:YES];
    }];
    
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if ([scrollView isKindOfClass:[UITableView class]]){
//        NSLog(@"------是列表---");
//    } else{ NSLog(@"------是滚动试图----");
//    }
//}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    LOG(@"正在滚动");
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
