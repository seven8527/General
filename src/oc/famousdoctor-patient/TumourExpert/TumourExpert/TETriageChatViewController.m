//
//  TETriageChatViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-4.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TETriageChatViewController.h"

@interface TETriageChatViewController ()

@end

@implementation TETriageChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configUI];
    
    [self layoutUI];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

// UI设置
- (void)configUI
{
    self.view.backgroundColor = [UIColor whiteColor];
}

// UI布局
- (void)layoutUI
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    NSString *urlString = @"http://vipwebchat6303.tq.cn/sendmain.jsp?admiuin=9607482&action=acd&tag=&ltype=1&rand=55973693216612459&iscallback=1&agentid=0&type_code=123&comtimes=1322&preuin=9607500&RQF=6&RQC=-1&page_templete_id=40264&is_message_sms=0&is_send_mail=3&logoLink=http://10.9.4.31/mj/services/logofile/logo/9607482&isAgent=0&sort=0&style=2&page=&localurl=http://www.mingyisheng.com/&spage=&nocache=0.08579050357052314";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

@end
