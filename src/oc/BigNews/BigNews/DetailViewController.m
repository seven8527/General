//
//  DetailViewController.m
//  BigNews
//
//  Created by owen on 15/8/17.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailTableViewCell.h"
#import "OJHttpUtil.h"
#import "DetailBean.h"


@interface DetailViewController ()

@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSString * next_page;
@property (nonatomic, assign) BOOL status;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self setTitle:_navTitle];
    [self setLeftBarImgBtn:nil];
    [self configUI];
    [self initData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)configUI
{
    _tableView = [UITableView newAutoLayoutView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
     _tableView.tableFooterView = [[UITableViewHeaderFooterView alloc]init];
    _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    
    __block typeof(self) bself = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [bself initData];
    }];
    [_tableView addLegendFooterWithRefreshingBlock:^{
        [bself loadMore];
    }];
    [_tableView.header beginRefreshing];
    
    [self updateConstraints];
    _status =false;
}

-(void)updateConstraints
{
    [_tableView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_tableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [_tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
}


-(void)initData
{
    if (!_status)
    {
        
        NSString *url = [NSString stringWithFormat:@"%@get_detail.php?url=%@%@",KROOT_PATH,_root_url, _path ];
        NSLog(@"%@",url);
        [OJHttpUtil GET:url parameters:nil success:^(id responseObject) {
            NSDictionary *dic =(NSDictionary*)responseObject;
            int status = [[dic objectForKey:@"stat"] intValue];
            
            _next_page =[dic objectForKey:@"netxpage"];
            if (status ==0) {
                
                _dataArray = [DetailBean arrayOfModelsFromDictionaries:[dic objectForKey:@"content"]];
                if ([_dataArray count] ==0) {
                    [_tableView.footer noticeNoMoreData];
                }
                else
                {
                    [_tableView reloadData];
                }
            }
            else{
                ALERT(@"数据异常");
            }
            [_tableView.header endRefreshing];
            _status=!_status;
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
            NSString * info =[NSString stringWithFormat:@"服务器错误CODE:%li",(long)error.code];
            ALERT(info);
            [_tableView.header endRefreshing];
            _status=!_status;
        }];
    }
    else
    {
        [_tableView.header endRefreshing];
    }
}

-(void)loadMore
{
    if (!_status)
    {
        if (![_next_page isEqualToString:@""]) {
            
            NSString *url     = [NSString stringWithFormat:@"%@get_detail.php?url=%@%@",KROOT_PATH,_root_url, _next_page ];
            NSLog(@"%@",url);
            [OJHttpUtil GET:url parameters:nil success:^(id responseObject) {
                NSDictionary *dic =(NSDictionary*)responseObject;
                int status        = [[dic objectForKey:@"stat"] intValue];
                _next_page =[dic objectForKey:@"netxpage"];
                
                if (status ==0) {
                    
                    NSArray *tmpArray = [DetailBean arrayOfModelsFromDictionaries:[dic objectForKey:@"content"]];
                    [_dataArray addObjectsFromArray:tmpArray];
                    
                    if ([tmpArray count] ==0) {
                        [_tableView.footer noticeNoMoreData];
                    }
                    else
                    {
                        [_tableView reloadData];
                    }
                }
                else{
                    ALERT(@"数据异常");
                }
                [_tableView.footer endRefreshing];
                _status=!_status;
            } failure:^(NSError *error) {
                NSLog(@"%@", error);
                NSString * info =[NSString stringWithFormat:@"服务器错误CODE:%li",(long)error.code];
                ALERT(info);
                [_tableView.footer endRefreshing];
                _status=!_status;
            }];
        }
        else{
            [_tableView.footer noticeNoMoreData];
            _status=!_status;
            //        [_tableView.footer endRefreshing];
        }
    }
    else
    {
        [_tableView.footer endRefreshing];
    }
}

#pragma  mark -------over load------


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * boundlId = @"detailBoundlId";
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:boundlId];
    if (cell == nil) {
        cell = [[DetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:boundlId];
    }
    
    DetailBean *bean = [_dataArray objectAtIndex:[indexPath row]];

    //设置一个行高上限
    CGSize size = CGSizeMake(SCREEN_WIDTH-20,2000);
    //计算实际frame大小，并将label的frame变成实际大小
     CGRect labelsize = [bean.text  boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:cell.detailLable.font,NSFontAttributeName, nil] context:nil];
//    cell.detailLable.frame = CGRectMake(10, 5, SCREEN_WIDTH-20, labelsize.size.height);
//    cell.detailLable.text =bean.text;
    
    if([bean.image isEqualToString:@""])
    {
        [cell.myImageview setHidden:YES];
        [cell.myImageview setFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 0)];
        cell.detailLable.frame = CGRectMake(10, 5, SCREEN_WIDTH-20, labelsize.size.height);
        
    }
    else
    {
        [cell.myImageview setHidden:NO];
        [cell.myImageview sd_setImageWithURL:[NSURL URLWithString:bean.image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            cell.myImageview.frame = CGRectMake(10, 0, SCREEN_WIDTH-20, image.size.height*(SCREEN_WIDTH-20)/image.size.width);
            cell.detailLable.frame = CGRectMake(10, cell.myImageview.frame.size.height*(SCREEN_WIDTH-20)/cell.myImageview.frame.size.width+10, SCREEN_WIDTH-20, labelsize.size.height);
            
        }];
        
        
    }
    
    cell.detailLable.text =[NSString stringWithFormat:@"    %@",bean.text];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [_dataArray count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    DetailTableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    DetailTableViewCell *cell =(DetailTableViewCell*)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
//    return cell.myImageview.frame.size.height+cell.detailLable.frame.size.height;
    DetailBean *bean = [_dataArray objectAtIndex:[indexPath row]];
    
    
    //设置一个行高上限
    CGSize size = CGSizeMake(SCREEN_WIDTH-20,2000);
    //计算实际frame大小，并将label的frame变成实际大小
    CGRect labelsize = [bean.text  boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:cell.detailLable.font,NSFontAttributeName, nil] context:nil];
//    NSLog(@"%f",labelsize.size.height);
    
 
    if ([bean.image isEqualToString:@""]) {
        return labelsize.size.height+20;
    }
    else
    {
        return labelsize.size.height+ cell.myImageview.frame.size.height*(SCREEN_WIDTH-20)/cell.myImageview.frame.size.width+20;

    }
    
    
  }
@end
