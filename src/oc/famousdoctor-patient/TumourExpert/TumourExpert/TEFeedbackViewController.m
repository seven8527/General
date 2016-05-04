//
//  TEFeedbackViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-27.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEFeedbackViewController.h"
#import "UIColor+Hex.h"
#import "LPlaceholderTextView.h"
#import "NSString+CalculateTextSize.h"
#import "TEResultModel.h"
#import "TEHttpTools.h"

@interface TEFeedbackViewController ()
@property (nonatomic, strong) LPlaceholderTextView *contentTextView;
@property (nonatomic, strong) UITextField *contactTextField; // 联系方式
@end

@implementation TEFeedbackViewController

#pragma mark - UIViewController lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configUI];
    
    [self layoutUI];
}


#pragma mark - UI

// UI设置
- (void)configUI
{
    self.title = @"意见反馈";
}

// UI布局
- (void)layoutUI
{
    // Create a rightBarButtonItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleBordered target:self action:@selector(commitFeedback:)];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    scrollView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    [self.view addSubview:scrollView];
    
    // 反馈的标签
    CGSize boundingSize = CGSizeMake(300, CGFLOAT_MAX);
    UILabel *feedbackLabel = [[UILabel alloc] init];
    feedbackLabel.text = @"反馈内容：";
    feedbackLabel.font = [UIFont boldSystemFontOfSize:17];
    feedbackLabel.textColor = [UIColor colorWithHex:0x383838];
    CGSize feedbackSize = [feedbackLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
    feedbackLabel.frame = CGRectMake(20, 20, feedbackSize.width, 21);
    [scrollView addSubview:feedbackLabel];
    
    // 反馈
    _contentTextView = [[LPlaceholderTextView alloc] initWithFrame:CGRectMake(20, 53, 280, 100)];
    _contentTextView.placeholderText = @"请输入您要反馈的内容";
    _contentTextView.placeholderColor = [UIColor colorWithHex:0x9e9e9e];
    _contentTextView.font = [UIFont systemFontOfSize:14];
    _contentTextView.textColor = [UIColor colorWithHex:0x383838];
    _contentTextView.layer.borderWidth = 1.0f;
    _contentTextView.layer.borderColor = [UIColor colorWithHex:0xd1d1d1].CGColor;
    [scrollView addSubview:_contentTextView];
    
    // 联系方式的标签
    UILabel *contactLabel = [[UILabel alloc] init];
    contactLabel.text = @"联系方式：";
    contactLabel.font = [UIFont boldSystemFontOfSize:17];
    contactLabel.textColor = [UIColor colorWithHex:0x383838];
    CGSize contactSize = [contactLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
    contactLabel.frame = CGRectMake(20, 173, contactSize.width, 21);
    [scrollView addSubview:contactLabel];
    
    // 联系方式
    _contactTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 206, 280, 30)];
    _contactTextField.borderStyle = UITextBorderStyleRoundedRect;
    _contactTextField.delegate = self;
    _contactTextField.font = [UIFont systemFontOfSize:13];
    _contactTextField.textColor = [UIColor colorWithHex:0x383838];
    _contactTextField.clearButtonMode = YES;
    NSDictionary *placeholderAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHex:0x9e9e9e], NSFontAttributeName : [UIFont systemFontOfSize:14]};
    _contactTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入联系方式" attributes:placeholderAttributes];
    [scrollView addSubview:_contactTextField];

    
    // 添加手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [scrollView addGestureRecognizer:tapGestureRecognizer];
}


#pragma mark - Keyboard

// 隐藏键盘
- (void)hideKeyboard
{
    [self.contentTextView resignFirstResponder];
    [self.contactTextField resignFirstResponder];
}

#pragma mark - Bussiness methods

// 提交反馈
- (void)commitFeedback:(id)sender
{
    [self hideKeyboard];
    
    // 去除空格
    NSString *content = [_contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *contact = [_contactTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([self validateContent:content contact:contact]) {
        [self feedbackWithContent:content contact:contact];
    }
}

#pragma mark - API

// 调用后台意见反馈接口
- (void)feedbackWithContent:(NSString *)content contact:(NSString *)contact
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"feedback"];
    NSDictionary *parameters = @{@"content": content, @"phone":contact};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        TEResultModel *result = [[TEResultModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = result.state;
        if ([state isEqualToString:@"205"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"反馈成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            [self.navigationController popViewControllerAnimated:YES];
        }
        self.navigationItem.rightBarButtonItem.enabled = NO;

    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        TEResultModel *result = [[TEResultModel alloc] initWithDictionary:responseObject error:nil];
//        NSString *state = result.state;
//        if ([state isEqualToString:@"205"]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"反馈成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//        self.navigationItem.rightBarButtonItem.enabled = NO;
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        self.navigationItem.rightBarButtonItem.enabled = NO;
//    }];
}


#pragma mark - Validate

// 验证反馈内容和联系方式
- (BOOL)validateContent:(NSString *)content contact:(NSString *)contact
{
    if ([content length] <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入反馈内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if ([contact length] <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入联系方式" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}

@end
