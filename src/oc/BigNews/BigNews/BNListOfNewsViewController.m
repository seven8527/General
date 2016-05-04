//
//  BNListOfNewsViewController.m
//  BigNews
//
//  Created by owen on 15/8/14.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import "BNListOfNewsViewController.h"
#import "BNListOfNewsTableViewCell.h"
#import "ListBean.h"
#import "OJHttpUtil.h"
#import "MacroDefinition.h"
#import "MJRefresh.h"
#import "DetailViewController.h"


@interface BNListOfNewsViewController ()

@property (nonatomic, strong) NSString * next_url;

@end

@implementation BNListOfNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:_titles];
    [self setLeftBarImgBtn:nil];
    
    [self configUI];
//    [self initData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [self.tabBarController.tabBar setHidden:YES];
//}

-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
     _tableView.tableFooterView = [[UITableViewHeaderFooterView alloc]init];
    __block typeof(self) bself = self;
    
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [bself initData];
    }];
    
    [_tableView addLegendFooterWithRefreshingBlock:^{
        [bself loadMore];
    }];
   
    [self.view addSubview:_tableView];
    [_tableView.header beginRefreshing];
    
}
-(void)loadMore
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText =@"正在加载...";
    NSString *urls = [NSString stringWithFormat:@"%@get_listbyurl.php?url=%@%@",KROOT_PATH,_url,_next_url];
   
    NSLog(@"%@", urls);
    
    [OJHttpUtil GET:urls parameters:nil success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary*) responseObject;
        NSLog(@"%@",dic);
        int stat = [[dic objectForKey:@"stat"] intValue];
        _next_url = dic[@"next"];
        if (stat ==0) {
            NSArray* tmpArray =[ListBean arrayOfModelsFromDictionaries:dic[@"data"]];
            [_dataArray addObjectsFromArray:tmpArray];
           
            if([_dataArray count]==0)
            {
                ALERT(@"没有获取到数据");
            }
            else
            {
                
                [_tableView reloadData];
            }
        }
        else
        {
            ALERT(@"数据异常");
        }
         [_tableView.footer endRefreshing];
        [hud hide:YES];
        
    } failure:^(NSError *error) {
        ALERT(@"服务器出错");
        NSLog(@"%@",error);
        [hud hide:YES];
         [_tableView.footer endRefreshing];
    }];

}
-(void)initData
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText =@"正在加载...";
     NSString *urls = [NSString stringWithFormat:@"%@get_listbyurl.php?url=%@",KROOT_PATH,_url];
    NSLog(@"%@", urls);
    
    [OJHttpUtil GET:urls parameters:nil success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary*) responseObject;
        NSLog(@"%@",dic);
        int stat = [[dic objectForKey:@"stat"] intValue];
        _next_url = dic[@"next"];
        if (stat ==0) {
            
            _dataArray =[ListBean arrayOfModelsFromDictionaries:dic[@"data"]];
            if([_dataArray count]==0)
            {
                ALERT(@"没有获取到数据");
            }
            else
            {
                
                [_tableView reloadData];
            }
        }
        else
        {
            ALERT(@"数据异常");
        }
        
        [hud hide:YES];
        [_tableView.header endRefreshing];
        
    } failure:^(NSError *error) {
        ALERT(@"服务器出错");
        NSLog(@"%@",error);
        [hud hide:YES];
         [_tableView.header endRefreshing];
    }];
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"%lu",(unsigned long)[_dataArray count]);
    return  [_dataArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController<DetailViewControllerProtocol> *detailCtr = [[JSObjection defaultInjector]getObject:@protocol(DetailViewControllerProtocol)];
    ListBean *bean = [_dataArray objectAtIndex:[indexPath row]];
    
    detailCtr.navTitle =bean.title;
    detailCtr.root_url = _url;
    detailCtr.path = bean.url;
    [self.navigationController pushViewController:detailCtr animated:YES];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * boundleID = @"BNListOfNews";
    BNListOfNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:boundleID];
    if (cell==nil) {
        cell = [[BNListOfNewsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:boundleID];
    }
    
    ListBean *bean = [_dataArray objectAtIndex:[indexPath row]];
    
//    NSLog(@"%@",bean);
//    if ([bean.img isEqual:@""]) {
////        cell.img.bounds = CGSizeMake(0, 60);
//        [cell.img autoSetDimensionsToSize:CGSizeMake(0, 60)];
//        [cell.title autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:cell.img];
//        [cell.time autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:cell.img];
//    }
//    else
//    {
//        [cell.img autoSetDimensionsToSize:CGSizeMake(100, 60)];
//        [cell.img sd_setImageWithURL:[NSURL URLWithString:bean.img]];
//        [cell.title autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:cell.img withOffset:10];
//        [cell.time autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:cell.img withOffset:10];
//    }
    [cell.img sd_setImageWithURL:[NSURL URLWithString:bean.img]];
    cell.title.text = bean.title;
    cell.time.text = bean.time;
    cell.content.text = bean.content;
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}


@end
