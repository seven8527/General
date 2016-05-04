//
//  BNHotsViewController.m
//  BigNews
//
//  Created by Owen on 15-8-14.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import "BNHotsViewController.h"
#import "OJHttpUtil.h"
#import "HotsBean.h"
#import "DetailViewController.h"
#import "UIColor+Random.h"

@interface BNHotsViewController ()

@property (nonatomic, assign) int lastIndex;

@end

@implementation BNHotsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"热门"];
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    [self changedSegment];
}

-(void) configUI
{
    self.segment = [[UISegmentedControl alloc]initWithItems:@[@"热门",@"看点"]];
    self.segment.frame = CGRectMake(20, 70, SCREEN_WIDTH-40, 30);
    self.segment.backgroundColor = [UIColor whiteColor];
    self.segment.tintColor = UIColorFromRGB(K00C3D5Color);
    self.segment.layer.masksToBounds = YES;
    self.segment.layer.cornerRadius = 4;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,  [UIFont fontWithName:@"Helvetica" size:16.f],NSFontAttributeName ,nil];
    [self.segment setTitleTextAttributes:dic forState:UIControlStateSelected];
    [self.segment setSelectedSegmentIndex:0];
    self.lastIndex = -1;
 
    [self.segment addTarget:self action:@selector(changedSegment) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.segment];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 105, SCREEN_WIDTH, SCREEN_HEIGHT-155) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    [self.view addSubview:_tableView];
}



-(void)changedSegment
{
    //已经选中的直接返回
    if (_lastIndex ==self.segment.selectedSegmentIndex ) {
        return;
    }
    //根据选中状态 查询数据
    if (self.segment.selectedSegmentIndex ==0) {
        if (_hotsDataArray ==nil) {
            [self initData:0];
        }
        else
        {
             _dataArray = _hotsDataArray;
            [_tableView reloadData];
        }
    }
    else
    {
        if (_pointDataArray ==nil) {
            [self initData:1];
        }
        else
        {
            _dataArray = _pointDataArray;
            [_tableView reloadData];
        }
    }
    _lastIndex =(int)self.segment.selectedSegmentIndex;

}

-(void) initData:(int) index
{
    NSString *urlPath = @"get_hots.php";
    if (self.segment.selectedSegmentIndex ==1) {
        urlPath = @"get_lookpoint.php";
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"正在刷新...";
    
    [OJHttpUtil GET:[NSString stringWithFormat:@"%@%@",KROOT_PATH, urlPath] parameters:nil success:^(id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        NSLog(@"%@", dic);
        
        int status = [[dic objectForKey:@"stat"] intValue];
        if (status ==0) {
            
            if (self.segment.selectedSegmentIndex ==0) {
                _hotsDataArray = [HotsBean arrayOfModelsFromDictionaries:[dic objectForKey:@"content"]];
                _dataArray =_hotsDataArray;
            }
            else
            {
                 _pointDataArray = [HotsBean arrayOfModelsFromDictionaries:[dic objectForKey:@"content"]];
                _dataArray =_pointDataArray;
            }
            
            [_tableView reloadData];
        }
        else
        {
            ALERT(@"返回状态异常");
        }
        [hud hide:YES];
    } failure:^(NSError *error) {
         ALERT(@"网络交互出错");
         [hud hide:YES];
    }];
    
}

#pragma mark -----over write------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [_dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * boundId = @"hotandpointId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:boundId];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:boundId];
    
    }
    HotsBean * bean = [_dataArray objectAtIndex:[indexPath row]];
    
    
    cell.textLabel.text = bean.text;
    cell.textLabel.textColor = [UIColor randomColor];
    cell.textLabel.numberOfLines = 2;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController<DetailViewControllerProtocol> *detailCtr = [[JSObjection defaultInjector] getObject:@protocol(DetailViewControllerProtocol) ];
    HotsBean * bean = [_dataArray objectAtIndex:[indexPath row]];
    detailCtr.navTitle =bean.text;
//    detailCtr.path=@"";
//    detailCtr.root_url = bean.url;
//    NSString
    NSRange rang ;
    if ([bean.url  containsString:@".com/"]) {
          rang =[bean.url rangeOfString:@".com/"];
        
    }
    else if ([bean.url containsString:@".cn/"])
    {
          rang =[bean.url rangeOfString:@".cn/"];
    }
    else if ([bean.url containsString:@".net/"])
    {
        rang =[bean.url rangeOfString:@".net/"];
    }
    else if ([bean.url containsString:@".org/"])
    {
        rang =[bean.url rangeOfString:@".org/"];
    }
    else if ([bean.url containsString:@".com.cn/"])
    {
        rang =[bean.url rangeOfString:@".com.cn/"];
    }
    detailCtr.path=[bean.url substringFromIndex:rang.location+rang.length];
    detailCtr.root_url = [bean.url substringToIndex:rang.location+rang.length];
    [self.navigationController pushViewController:detailCtr animated:YES];
}
@end
