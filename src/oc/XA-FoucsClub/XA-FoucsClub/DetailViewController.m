//
//  DetailViewController.m
//  XA-FoucsClub
//
//  Created by Owen on 15/6/16.
//  Copyright (c) 2015年 owen. All rights reserved.
//
#import "OJAlertUtil.h"
#import "OJHttpUtil.h"
#import "OJProgressBar.h"
#import "DetailViewController.h"
#import "DetailJSONModel.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
   self.parentViewController.tabBarController.tabBar.hidden = YES;
//    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    }

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0.0f,60.0f,self.view.bounds.size.width,self.view.bounds.size.height-44)];
//    _webView.backgroundColor = [UIColor yellowColor];
    self.navigationItem.backBarButtonItem.title =@"返回";

    [self getData];
}

-(void)getData{
    OJProgressBar *bar =  [OJProgressBar showHUDAddTo:self.view animated:YES message:@"正在加载"];
    
    NSString *url = [NSString stringWithFormat:@"%@detail?",ROOT_URL];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:_ID,@"id", nil];
    
    [OJHttpUtil GETWITHKEY:url parameters:params success:^(id responseObject) {
        
        bool status=  [responseObject objectForKey:@"success"];
        if (status) {
            NSDictionary *data = [responseObject objectForKey:@"yi18"];
            DetailJSONModel *detail = [[DetailJSONModel alloc]initWithDictionary:data error:nil];
  
            Answer *answer =[[Answer alloc]initWithDictionary:[detail.answer objectAtIndex:0] error:nil];
            NSString * html  =[answer message];
            NSLog(@"%@",html);
            [_webView loadHTMLString:html  baseURL:nil];
            [self.view addSubview:_webView];
            
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
