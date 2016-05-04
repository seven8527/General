//
//  MYSFreeConsultationsViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-3-23.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSFreeConsultationsViewController.h"
#import "MYSPersonalFreeConsultationCell.h"
#import "HttpTool.h"
#import "AppDelegate.h"
#import "MYSPersonalConsults.h"
#import "MYSPersonalFreeConsultationFrame.h"
#import "UIColor+Hex.h"
#import <MJRefresh/MJRefresh.h>

@interface MYSFreeConsultationsViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UITableView *mainTableView;
@property (nonatomic, assign) BOOL fisrtLoad;
@property (nonatomic, strong) NSMutableArray *consultArray;
@property (nonatomic, assign) int totalConsults;
@property (nonatomic, weak) UIImageView *sadImageView;
@property (nonatomic, weak) UILabel *sadTextLabel;
@end

@implementation MYSFreeConsultationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fisrtLoad = YES;
    
    
    // 更换用户
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exchangeUser:) name:@"exchangeUser" object:nil];
    
    //新添免费咨询
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewFreeConsult:) name:@"addNewFreeConsult" object:nil];
    
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, kScreen_Width - 20, kScreen_Height - 113) style:UITableViewStylePlain];
    self.mainTableView = mainTableView;
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    mainTableView.showsVerticalScrollIndicator = NO;
    self.view.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    self.mainTableView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    
    
    UIImageView *sadImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width - 60) / 2, (kScreen_Height - 160) / 2 -60, 60, 60)];
    sadImageView.image = [UIImage imageNamed:@"search_icon_none_"];
    self.sadImageView = sadImageView;
    self.sadImageView.hidden = YES;
    [self.view addSubview:sadImageView];
    
    
    UILabel *sadTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sadImageView.frame) + 10, kScreen_Width, 40)];
    self.sadTextLabel = sadTextLabel;
    sadTextLabel.textColor = [UIColor lightGrayColor];
    sadTextLabel.text = @"无免费咨询";
    sadTextLabel.textAlignment = NSTextAlignmentCenter;
    sadTextLabel.hidden = YES;
    [self.view addSubview:sadTextLabel];

    [self addHeader];
    [self addFooter];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (self.fisrtLoad == YES) {
        [self fetchAllConsult];
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
    [self.consultArray removeAllObjects];
    [self fetchAllConsult];
    [self addFooter];
    [self addHeader];
}

- (void)addNewFreeConsult:(NSNotification *)notification
{
    [self.consultArray removeAllObjects];
    [self fetchAllConsult];
    [self addFooter];
    [self addHeader];
}


- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    
    [vc.mainTableView addFooterWithCallback:^{
        if (self.consultArray.count < self.totalConsults) {
            
            [vc fetchAllConsult];
            [vc.mainTableView footerEndRefreshing];
        } else {
            vc.mainTableView.footerRefreshingText = @"已加载全部数据";
            [vc.mainTableView footerEndRefreshing];
        }
    }];
}


-(void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    
    [vc.mainTableView headerBeginRefreshing];
    [vc.mainTableView addHeaderWithCallback:^{
        [vc.consultArray removeAllObjects];
        [vc fetchAllConsult];
        [vc.mainTableView headerEndRefreshing];
        
    } dateKey:@"table"];
}

- (NSMutableArray *)consultArray
{
    if (_consultArray == nil) {
        _consultArray = [NSMutableArray array];
    }
    return _consultArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.consultArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *freeConsultation = @"freeConsultation";
    MYSPersonalFreeConsultationCell *freeConsultationCell = [tableView dequeueReusableCellWithIdentifier:freeConsultation];
    if (freeConsultationCell == nil) {
        freeConsultationCell = [[MYSPersonalFreeConsultationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:freeConsultation];
    }
    if(self.consultArray.count > 0){
        freeConsultationCell.freeConsultFrame = self.consultArray[indexPath.section];
    }
    return freeConsultationCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[[[self.consultArray[indexPath.section] freeConsultModel] briefAskModel] pfID] forKey:@"pfid"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"personalConsultatins" object:nil userInfo:userInfo];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.consultArray.count > 0) {
        return [self.consultArray[indexPath.section] CellHeight];
    }else {
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
float lastContentOffset;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    LOG(@"开始拖动");
    lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (lastContentOffset > scrollView.contentOffset.y) {
        LOG(@"12向下滚动");
        if(self.mainTableView.contentOffset.y > 0) {
            
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollDown" object:nil];
        }
    } else {
        LOG(@"12向上滚动");
        if(self.mainTableView.contentOffset.y > 0) {
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
        if(self.mainTableView.contentOffset.y > 0) {
            
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollDown" object:nil];
        }
    }
}

#pragma mark - API methods

// 获取免费咨询列表
- (void)fetchAllConsult
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"free_consulta"];
    NSDictionary *parameters = @{@"userid": ApplicationDelegate.userId, @"start": [NSString stringWithFormat:@"%lu",(unsigned long)self.consultArray.count], @"end": @"10"};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        MYSPersonalConsults *consults = [[MYSPersonalConsults alloc] initWithDictionary:responseObject error:nil];
        LOG(@"%@",responseObject);
        self.totalConsults = [consults.total intValue];
        if(self.totalConsults>0){
            self.sadImageView.hidden = YES;
            self.sadTextLabel.hidden = YES;
        } else {
            self.sadTextLabel.hidden = NO;
            self.sadImageView.hidden = NO;
        }
        for (MYSFreeConsult * freeConsult in consults.consults) {
            MYSPersonalFreeConsultationFrame *personalFreeConsultFrame = [[MYSPersonalFreeConsultationFrame alloc] init];
            personalFreeConsultFrame.freeConsultModel = freeConsult;
            [self.consultArray addObject:personalFreeConsultFrame];
        }
        [self.mainTableView reloadData];
         
        [hud hide:YES];
    } failure:^(NSError *error) {
        LOG(@"%@",error);
        [hud hide:YES];
    }];
    
}

//// 获取免费咨询列表
//- (void)fetchHeaderAllConsult
//{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = @"正在加载";
//    
//    NSString *URLString = [kURL_ROOT stringByAppendingString:@"free_consulta"];
//    NSDictionary *parameters = @{@"userid": @"1932", @"start": [NSString stringWithFormat:@"%lu",(unsigned long)self.consultArray.count], @"end": @"3"};
//    [HttpTool post:URLString params:parameters success:^(id responseObject) {
//        MYSPersonalConsults *consults = [[MYSPersonalConsults alloc] initWithDictionary:responseObject error:nil];
//        self.totalConsults = [consults.total intValue];
//        
//        for (MYSFreeConsult * freeConsult in consults.consults) {
//            MYSPersonalFreeConsultationFrame *personalFreeConsultFrame = [[MYSPersonalFreeConsultationFrame alloc] init];
//            personalFreeConsultFrame.freeConsultModel = freeConsult;
//            [self.consultArray addObject:personalFreeConsultFrame];
//        }
//        [self.mainTableView reloadData];
//        [self.mainTableView headerEndRefreshing];
//        [hud hide:YES];
//    } failure:^(NSError *error) {
//        [hud hide:YES];
//    }];
//    
//}


@end
