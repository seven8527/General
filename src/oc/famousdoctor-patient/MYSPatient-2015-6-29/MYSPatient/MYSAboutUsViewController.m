//
//  MYSAboutUsViewController.m
//  MYSPatient
//
//  Created by 吴玉龙 on 15-1-7.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSAboutUsViewController.h"
#import "UIColor+Hex.h"
#import "HttpTool.h"

@interface MYSAboutUsViewController ()
@property (nonatomic, weak) UITextView *aboutTextView;
@end

@implementation MYSAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
//    UITextView *aboutTextView = [[UITextView alloc] initWithFrame:self.view.bounds];
//    aboutTextView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
//    aboutTextView.editable = NO;
//    aboutTextView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
//
//    self.aboutTextView = aboutTextView;
//    [self.view addSubview:aboutTextView];
//    
//    [self fetchAboutUs];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"useragreement/about_us"];
    NSURL *url = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - API

// 调用后台关于我们接口
- (void)fetchAboutUs
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"useragreement/about_us"];
    [HttpTool post:URLString params:nil success:^(id responseObject) {
        LOG(@"%@", responseObject);
        NSString *content = [responseObject valueForKey:@"content"];
        self.aboutTextView.text = content;
        if (self.aboutTextView.text == nil) {
            self.aboutTextView.text = @"";
        }
        
//        // 段落设置
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.maximumLineHeight = 25.f;
//        paragraphStyle.minimumLineHeight = 15.f;
//        paragraphStyle.firstLineHeadIndent = 25.f;
//        paragraphStyle.headIndent = 6.f;
//        paragraphStyle.lineSpacing = 5.f;
//        paragraphStyle.alignment = NSTextAlignmentNatural;
//        
//        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor colorFromHexRGB:K333333Color]};
//        self.aboutTextView.attributedText = [[NSAttributedString alloc] initWithString:self.aboutTextView.text attributes:attributes];
        [hud hide:YES];
    } failure:^(NSError *error) {
        LOG(@"Error: %@", error);
        [hud hide:YES];
    }];
}

@end
