//
//  InfoListViewController.m
//  XA-FoucsClub
//
//  Created by Owen on 15/6/17.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import "InfoListViewController.h"
#import "InfoJSONModel.h"
#import "DetailViewController.h"
@interface InfoListViewController ()

@end

@implementation InfoListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.parentViewController.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    __block  NSString *ids = [NSString stringWithFormat:@"%@", _idOfInfo];
    __block NSString *url = [NSString stringWithFormat:@"%@list", ROOT_URL];

    _tabView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];

   [_tabView addLegendHeaderWithRefreshingBlock:^{
       
       
       NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"page", ids,@"id",@"20",@"limit",@"id",@"tpye", nil];
       
       [OJHttpUtil GETWITHKEY:url parameters:params success:^(id responseObject) {
           bool status = [responseObject objectForKey:@"success"];
           if (status) {
               NSLog(@"%@",responseObject);
               NSArray *data= [responseObject objectForKey:@"yi18"];
               _InfoArray = [InfoJSONModel arrayOfModelsFromDictionaries:data error:nil];
               
               _indexOfPage +=1;
               [_tabView.header endRefreshing];
               [_tabView reloadData];
           }
           
       } failure:^(NSError *error) {
           [OJAlertUtil showAlert:@"刷新失败,网络异常"];
            [_tabView.header endRefreshing];
       }];
      
   }];
    [_tabView addLegendFooterWithRefreshingBlock:^{
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", _indexOfPage],@"page", ids,@"id",@"20",@"limit",@"id",@"tpye", nil];
        
        [OJHttpUtil GETWITHKEY:url parameters:params success:^(id responseObject) {
            bool status = [responseObject objectForKey:@"success"];
            if (status) {
                  NSArray *data= [responseObject objectForKey:@"yi18"];
                 if([data count] == 0)
                 {
                     [_tabView.footer noticeNoMoreData];
                 }
                 else{
                     
                        [_InfoArray addObjectsFromArray:[InfoJSONModel arrayOfModelsFromDictionaries:data error:nil]];
                   
                
                 _indexOfPage +=_indexOfPage ;
                [_tabView.footer endRefreshing];
                [_tabView reloadData];
                      }
            }
            
        } failure:^(NSError *error) {
            [OJAlertUtil showAlert:@"刷新失败,网络异常"];
            [_tabView.footer endRefreshing];
        }];
        
    }];
    self.tabView.dataSource = self;
    self.tabView.delegate =self;
    [self.view addSubview:_tabView];
    [self.tabView.header beginRefreshing];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_InfoArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *ids = @"cell";
    UITableViewCell *tabViewCell = [tableView dequeueReusableCellWithIdentifier:ids];
    
    if(tabViewCell == nil)
    {
        tabViewCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ids];
    }
   
    tabViewCell.textLabel.text = [[_InfoArray objectAtIndex:[indexPath row]] title];
    return tabViewCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detail = [[DetailViewController alloc]init];
    detail.ID = [[_InfoArray objectAtIndex:[indexPath row]] id];
    detail.title =[[_InfoArray objectAtIndex:[indexPath row]] title];
    [self.navigationController pushViewController:detail animated:YES];
    
}
@end
