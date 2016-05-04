//
//  PersionViewController.m
//  XA-FoucsClub
//
//  Created by Owen on 15/6/12.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import "PersionViewController.h"
#import "InfoJSONModel.h"
#include "DetailViewController.h"

@interface PersionViewController ()

@end

@implementation PersionViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = FALSE;
    self.parentViewController.tabBarController.tabBar.hidden = FALSE;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width
                                                                           ,50 )];
    _searchBar.delegate = self;
    _tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width
                                                            , self.view.bounds.size.height)];
    _tabView.delegate = self;
    _tabView.dataSource= self;
     self.tabView.tableHeaderView =_searchBar;
    [_tabView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [_tabView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [self.view addSubview:_tabView];
    
    [_tabView.header beginRefreshing];
    
    
}

-(void) loadData{
    NSString *url = [NSString stringWithFormat:@"%@list", ROOT_URL];
    NSDictionary *data= [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"page", nil];
    [OJHttpUtil GETWITHKEY:url parameters:data success:^(id responseObject) {
        NSString * status = [responseObject objectForKey:@"success"];
        if (status) {
            NSArray *data = [responseObject objectForKey:@"yi18"];
            _InfoArray = [InfoJSONModel arrayOfModelsFromDictionaries:data];
            _indexOfPage +=1;
            [_tabView reloadData];
               

        }
        else
        {
            [OJAlertUtil showAlert:@"数据获取失败"];
        }
        [_tabView.header endRefreshing];
        
    } failure:^(NSError *error) {
        [OJAlertUtil showAlert:@"网络异常"];
        [_tabView.header endRefreshing];
    }];
}

-(void) loadMore
{
    NSString *url = [NSString stringWithFormat:@"%@list", ROOT_URL];
    NSDictionary *data= [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", _indexOfPage],@"page", nil];
    [OJHttpUtil GETWITHKEY:url parameters:data success:^(id responseObject) {
        NSString * status = [responseObject objectForKey:@"success"];
        if (status) {
            NSArray *data = [responseObject objectForKey:@"yi18"];
            
            if ([data count]==0) {
                [_tabView.footer noticeNoMoreData];
            }
            else{
//             _InfoArray = [InfoJSONModel arrayOfModelsFromDictionaries:data];
                [_InfoArray addObjectsFromArray:[InfoJSONModel arrayOfModelsFromDictionaries:data]];
                _indexOfPage +=1;
                [_tabView reloadData];
            }
        }
        else
        {
            [OJAlertUtil showAlert:@"数据获取失败"];
        }
        [_tabView.footer endRefreshing];
        
    } failure:^(NSError *error) {
        [OJAlertUtil showAlert:@"网络异常"];
        [_tabView.footer endRefreshing];
    }];
}


-(void) searchData
{
    NSString *url = [NSString stringWithFormat:@"%@search", ROOT_URL];

    
    NSDictionary *data= [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", _indexOfPage],@"page",[_searchBar text],@"keyword", nil];
    [OJHttpUtil GETWITHKEY:url parameters:data success:^(id responseObject) {
        NSString * status = [responseObject objectForKey:@"success"];
        if (status) {
            NSArray *data = [responseObject objectForKey:@"yi18"];
            
            if ([data count]==0) {
                [_tabView.footer noticeNoMoreData];
            }
            else{
                 _InfoArray = [InfoJSONModel arrayOfModelsFromDictionaries:data];
//                [_InfoArray addObjectsFromArray:[InfoJSONModel arrayOfModelsFromDictionaries:data]];
                _indexOfPage +=1;
                [_tabView reloadData];
            }
        }
        else
        {
            [OJAlertUtil showAlert:@"数据获取失败"];
        }
        
    } failure:^(NSError *error) {
        [OJAlertUtil showAlert:@"网络异常"];
    }];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return   [_InfoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell== nil) {
        cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    if ([_searchBar.text isEqualToString:@""]) {
        cell.textLabel.text =[[_InfoArray objectAtIndex:[indexPath row]] title];

    }
    else
    {
        NSString *content =[[_InfoArray objectAtIndex:[indexPath row]] content];
        content = [content stringByReplacingOccurrencesOfString:@"<font color=\"red\">" withString:@""];
              content = [content stringByReplacingOccurrencesOfString:@"</font>" withString:@""];
      
        cell.textLabel.text =content;

    }
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detail = [[DetailViewController alloc]init];
    detail.ID = [[_InfoArray objectAtIndex:[indexPath row]] id];
    NSString *content =[[_InfoArray objectAtIndex:[indexPath row]] title];
    content = [content stringByReplacingOccurrencesOfString:@"<font color=\"red\">" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"</font>" withString:@""];
    detail.title = content;
    [self.navigationController pushViewController:detail animated:YES];
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchData];
    [self.view endEditing:YES];
  
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    _indexOfPage =1;
    [_InfoArray removeAllObjects];
    [_tabView reloadData];
    [_searchBar setShowsCancelButton:YES];
   
    return true;

}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar setShowsCancelButton:FALSE];
     _searchBar.text = @"";
    [_searchBar resignFirstResponder];
    [self loadData];
}
@end
