//
//  TEConsultQuestionViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-23.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEConsultQuestionViewController.h"
#import "TEAppDelegate.h"
#import "UIColor+Hex.h"
#import "LPlaceholderTextView.h"
#import "TEResultModel.h"
#import "TEHttpTools.h"

@interface TEConsultQuestionViewController ()
@property (nonatomic, strong) LPlaceholderTextView *questionTextView;
@end

@implementation TEConsultQuestionViewController

#pragma mark - UIViewController lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self layoutUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI


// UI布局
- (void)layoutUI
{
    // Create a rightBarButtonItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleBordered target:self action:@selector(commitQuestion:)];
    
    // 问题
    _questionTextView = [[LPlaceholderTextView alloc] initWithFrame:CGRectMake(20, 20, 280, 200)];
    _questionTextView.placeholderText = @"请输入您要咨询专家的问题";
    _questionTextView.placeholderColor = [UIColor colorWithHex:0x9e9e9e];
    _questionTextView.font = [UIFont systemFontOfSize:14];
    _questionTextView.layer.borderWidth = 1.0f;
    _questionTextView.layer.borderColor = [UIColor colorWithHex:0xd1d1d1].CGColor;
    [self.view addSubview:_questionTextView];
}


#pragma mark - Bussiness methods

// 提交问题
- (void)commitQuestion:(id)sender
{
    // 去除空格
    NSString *question = [_questionTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([self validateQuestion:question]) {
        [self consultQuestionWithConsultId:self.consultId nextQuestion:self.nextQuestion question:question];
    }
}

#pragma mark - API

// 调用后台追问接口
- (void)consultQuestionWithConsultId:(NSString *)consultId nextQuestion:(NSString *)nextQuestion question:(NSString *)question
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"seereply/updatequestion"];
    NSDictionary *parameters = @{@"pqid": consultId, @"question_time":nextQuestion, @"question": question, @"cookie": ApplicationDelegate.cookie};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        TEResultModel *result = [[TEResultModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = result.state;
        if ([state isEqualToString:@"204"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"追问成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        TEResultModel *result = [[TEResultModel alloc] initWithDictionary:responseObject error:nil];
//        NSString *state = result.state;
//        if ([state isEqualToString:@"204"]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"追问成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
}


#pragma mark - Validate

// 验证用户名和手机
- (BOOL)validateQuestion:(NSString *)question
{
    if ([question length] <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入您要咨询专家的问题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}

@end
