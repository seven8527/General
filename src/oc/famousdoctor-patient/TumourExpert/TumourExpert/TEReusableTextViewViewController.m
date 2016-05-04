//
//  TEReusableTextViewViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-19.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEReusableTextViewViewController.h"
#import "UIColor+Hex.h"
#import "TEUITools.h"
#import "LPlaceholderTextView.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface TEReusableTextViewViewController ()
@property (nonatomic, strong) LPlaceholderTextView *contentTextView;
@end

@implementation TEReusableTextViewViewController

#pragma mark - UIViewController lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self layoutUI];
}


#pragma mark - UI

// UI布局
- (void)layoutUI
{
    // Create a rightBarButtonItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveContent)];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    scrollView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    [self.view addSubview:scrollView];
    
    // 输入内容
    _contentTextView = [[LPlaceholderTextView alloc] initWithFrame:CGRectMake(20, 20, 280, kScreen_Height - 380)];
    _contentTextView.placeholderText = self.placeholder;
    _contentTextView.placeholderColor = [UIColor colorWithHex:0x9e9e9e];
    _contentTextView.text = self.content;
    _contentTextView.font = [UIFont systemFontOfSize:14];
    _contentTextView.textColor = [UIColor colorWithHex:0x383838];
    _contentTextView.layer.borderWidth = 1.0f;
    _contentTextView.layer.borderColor = [UIColor colorWithHex:0xd1d1d1].CGColor;
    [scrollView addSubview:_contentTextView];
    
    if (self.exampleContent && [self.exampleContent length] > 0) {
        // 示例的标签
        UILabel *exampleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_contentTextView.frame) + 10, 280, 21)];
        exampleLabel.text = @"示例：";
        exampleLabel.font = [UIFont boldSystemFontOfSize:17];
        exampleLabel.textColor = [UIColor colorWithHex:0x383838];
        [scrollView addSubview:exampleLabel];
        
        // 输入内容
        UITextView *exampleTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(exampleLabel.frame) + 10, 280, 180)];
        exampleTextView.text = self.exampleContent;
        exampleTextView.font = [UIFont systemFontOfSize:14];
        exampleTextView.textColor = [UIColor colorWithHex:0x6b6b6b];
        exampleTextView.userInteractionEnabled = NO;
        [scrollView addSubview:exampleTextView];
    }

    
    // 添加手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [scrollView addGestureRecognizer:tapGestureRecognizer];
}


#pragma mark - Bussiness methods

// 密码修改
- (void)saveContent
{
    [self hideKeyboard];
    
    // 去除空格
    NSString *content = [_contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([self validateContent:content]) {
        [self.delegate didFinishedTextViewContent:content byFlag:self.flag];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - Keyboard

// 隐藏键盘
- (void)hideKeyboard
{
    [self.contentTextView resignFirstResponder];
}

#pragma mark - Validate

// 验证内容
- (BOOL)validateContent:(NSString *)content
{
    if ([content length] < 20 || [content length] > 1000) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"内容限制20-1000个字符" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}
@end
