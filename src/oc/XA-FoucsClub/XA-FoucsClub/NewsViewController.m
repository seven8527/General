//
//  NewsViewController.m
//  XA-FoucsClub
//
//  Created by Owen on 15/6/12.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import "NewsViewController.h"
#import "OJHttpUtil.h"
#import  "HealthItem.h"
#import "OJAlertUtil.h"
#import "OJProgressBar.h"
#import "DetailViewController.h"
#import "InfoListViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = FALSE;
    self.parentViewController.tabBarController.tabBar.hidden = FALSE;
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //_arrayList = [[NSArray alloc]initWithObjects:@"西安", @"宝鸡",@"咸阳",@"汉中", nil];
    
    UITableView *tabView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    tabView.dataSource = self;
    tabView.delegate = self;
    _tabView = tabView;
    self.navigationItem.title = @"健康分类";
    [self.view addSubview:tabView];
    [self getData];
    // Do any additional setup after loading the view.
}


-(void)getData{
   OJProgressBar *bar =  [OJProgressBar showHUDAddTo:self.view animated:YES message:@"正在加载"];
    
    NSString *url = [NSString stringWithFormat:@"%@askclass?",ROOT_URL];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"id", nil];
    
    [OJHttpUtil GETWITHKEY:url parameters:params success:^(id responseObject) {
      bool status=  [responseObject objectForKey:@"success"];
        if (status) {
            NSArray *data = [responseObject objectForKey:@"yi18"];
            _arrayList = [HealthItem arrayOfModelsFromDictionaries:data error:nil];
            [_tabView reloadData];
        }
        else{
            [OJAlertUtil showAlert:@"获取数据失败"];
        }
         [bar hide:YES];
        
    } failure:^(NSError *error) {
        [OJAlertUtil showAlert:@"网络请求失败"];
        [bar hide:YES];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_arrayList count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ids = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ids];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ids];
    }
    
    NSInteger  row = [indexPath row];
    cell.textLabel.text = [[_arrayList objectAtIndex:row] names];
    cell.detailTextLabel.text=@"详细描述";
    
    
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    DetailViewController *detail = [[DetailViewController alloc]init];
//    detail.ID = [[_arrayList objectAtIndex:[indexPath row]] ids];
//    [self.navigationController pushViewController:detail animated:YES];
    
    InfoListViewController *info = [[InfoListViewController alloc]init];
    info.idOfInfo = [[_arrayList objectAtIndex:[indexPath row]] ids];
    info.title = [[_arrayList objectAtIndex:[indexPath row]] names];
        [self.navigationController pushViewController:info animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
