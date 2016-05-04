//
//  BNHomeViewController.m
//  BigNews
//
//  Created by Owen on 15-8-13.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import "BNHomeViewController.h"
#import "BNHomeTableViewCell.h"
#import "OJHttpUtil.h"
#import "HomeBean.h"
#import "UIImageView+WebCache.h"
#import "BNListOfNewsViewController.h"
#import "JSObjection.h"


@interface BNHomeViewController ()

@end

@implementation BNHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    UIButton *button = [[UIButton alloc]init];
//    button.frame = CGRectMake(100, 200, 50, 50);
//    [button setTitle:@"跳转" forState:UIControlStateNormal];
//    [button setTintColor:[UIColor redColor] ];
//    [button setBackgroundColor:[UIColor blueColor]];
//    [button addTarget:self action:@selector(btnGO) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//     [self setLeftBarImgBtn:nil];
    [self setTitle:@"首页"];
    [self configUI];
    [self initData];
}
//-(void)btnGO
//{
////    testViewController *home = [[testViewController alloc]init];
////    [self.navigationController pushViewController:home animated:YES];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
}


// overwrite

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}
// overwrite

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *homeID = @"homeId";
    BNHomeTableViewCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:homeID];
    if (homeTableViewCell == nil) {
        homeTableViewCell = [[BNHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homeID];
    }
    HomeBean *bean =[_dataArray objectAtIndex:[indexPath row]];
    homeTableViewCell.title.text  = bean.title;
    [homeTableViewCell.bgImageView sd_setImageWithURL:[NSURL URLWithString:bean.img_url]];
    homeTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    expertGroupConcerneCell.concerneButton.hidden = YES;
     homeTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  homeTableViewCell;
}
// overwrite

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [_dataArray count];
}

-(void) configUI
{
//  _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UITableViewHeaderFooterView alloc]init];
    [self.view addSubview:_tableView];
}

-(void) initData
{
    NSString *path = [NSString stringWithFormat:@"%@get_all_url.php", KROOT_PATH];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"正在加载..."];
    [OJHttpUtil GET:path parameters:nil success:^(id responseObject) {
    
        NSDictionary *resultDic =responseObject;
//      NSLog(@"%@", resultDic);
        
        _dataArray = [HomeBean arrayOfModelsFromDictionaries:[resultDic objectForKey:@"data"]];
        NSLog(@"%@", _dataArray);

        [_tableView reloadData];
        
        [hud setHidden:YES];
    } failure:^(NSError *error) {
        
        NSLog(@"访问出错:%@", error);
        [hud setHidden:YES];
    }];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNListOfNewsViewController<BNListOfNewsViewControllerProtocol> *newListCtl = [[JSObjection defaultInjector] getObject:@protocol(BNListOfNewsViewControllerProtocol)];
    HomeBean *bean =[_dataArray objectAtIndex:[indexPath row]];
    newListCtl.url = bean.url;
    newListCtl.titles = bean.title  ;
    [self.navigationController pushViewController:newListCtl animated:YES];
}
@end
