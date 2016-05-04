//
//  TEBriefConsultQuestionViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-19.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEBriefConsultQuestionViewController.h"
#import "UIColor+Hex.h"
#import "TEUITools.h"
#import "TEAppDelegate.h"
#import "TEResultBasicDataModel.h"
#import "LPlaceholderTextView.h"
#import "TETextConsultViewController.h"
#import "TEPhoneConsultViewController.h"
#import "TEChoosePatientDataViewController.h"
#import "TEHttpTools.h"

@interface TEBriefConsultQuestionViewController ()
@property (nonatomic, strong) UITextField *majorDiseaseTextField;
@property (nonatomic, strong) UITextField *otherDiseaseTextField;
@property (nonatomic, strong) UITextField *purposeTextField;
@property (nonatomic, strong) LPlaceholderTextView *questionTextView;
@end

@implementation TEBriefConsultQuestionViewController

#pragma mark - UIViewController lifecycle

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
    // 设置标题
    self.title = @"咨询问题";
}

// UI布局
- (void)layoutUI
{
    //初始化scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.contentSize = CGSizeMake(0, 450);
    scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    scrollView.contentOffset = CGPointMake(0, 0);
    scrollView.contentInset = UIEdgeInsetsZero;
    
    NSLog(@"-%f  -%f  -%f  -%f   -%f", scrollView.contentInset.top, scrollView.scrollIndicatorInsets.top, scrollView.contentOffset.y, self.view.frame.size.height, scrollView.frame.size.height);
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    
    // 主要疾病标签
    UIImageView *startImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 35, 6, 6)];
    startImageView.image = [UIImage imageNamed:@"star.png"];
    [scrollView addSubview:startImageView];

    UILabel *majorDiseaseLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 28, 200, 21)];
    majorDiseaseLabel.text = @"主要疾病：";
    majorDiseaseLabel.font = [UIFont boldSystemFontOfSize:17];
    majorDiseaseLabel.textColor = [UIColor colorWithHex:0x383838];
    [scrollView addSubview:majorDiseaseLabel];
    
    // 输入主要疾病
    _majorDiseaseTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 58, 280, 30)];
    _majorDiseaseTextField.borderStyle = UITextBorderStyleRoundedRect;
    _majorDiseaseTextField.delegate = self;
    _majorDiseaseTextField.font = [UIFont systemFontOfSize:13];
    _majorDiseaseTextField.textColor = [UIColor colorWithHex:0x9e9e9e];
    NSDictionary *placeholderAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHex:0x9e9e9e], NSFontAttributeName : [UIFont systemFontOfSize:13]};
    _majorDiseaseTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"例如：乳房癌" attributes:placeholderAttributes];
    [scrollView addSubview:_majorDiseaseTextField];
    
    // 其他疾病标签
    UILabel *otherDiseaseLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 98, 200, 21)];
    otherDiseaseLabel.text = @"其他疾病：";
    otherDiseaseLabel.font = [UIFont boldSystemFontOfSize:17];
    otherDiseaseLabel.textColor = [UIColor colorWithHex:0x383838];
    [scrollView addSubview:otherDiseaseLabel];
    
    // 输入其他疾病
    _otherDiseaseTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 128, 280, 30)];
    _otherDiseaseTextField.borderStyle = UITextBorderStyleRoundedRect;
    _otherDiseaseTextField.delegate = self;
    _otherDiseaseTextField.font = [UIFont systemFontOfSize:13];
    _otherDiseaseTextField.textColor = [UIColor colorWithHex:0x9e9e9e];
    _otherDiseaseTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"例如：乳房癌" attributes:placeholderAttributes];
    [scrollView addSubview:_otherDiseaseTextField];
    
    // 您本次咨询的目的标签
    UIImageView *startImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 175, 6, 6)];
    startImageView1.image = [UIImage imageNamed:@"star.png"];
    [scrollView addSubview:startImageView1];
    
    UILabel *purposeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 168, 200, 21)];
    purposeLabel.text = @"您本次咨询的目的：";
    purposeLabel.font = [UIFont boldSystemFontOfSize:17];
    purposeLabel.textColor = [UIColor colorWithHex:0x383838];
    [scrollView addSubview:purposeLabel];
    
    // 输入您本次咨询的目的
    _purposeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 198, 280, 30)];
    _purposeTextField.borderStyle = UITextBorderStyleRoundedRect;
    _purposeTextField.delegate = self;
    _purposeTextField.font = [UIFont systemFontOfSize:13];
    _purposeTextField.textColor = [UIColor colorWithHex:0x9e9e9e];
    _purposeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您本次咨询的目的" attributes:placeholderAttributes];
    [scrollView addSubview:_purposeTextField];
    
    // 您本次咨询的问题标签
    UIImageView *startImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 245, 6, 6)];
    startImageView2.image = [UIImage imageNamed:@"star.png"];
    [scrollView addSubview:startImageView2];
    
    UILabel *questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 238, 200, 21)];
    questionLabel.text = @"您本次咨询的问题：";
    questionLabel.font = [UIFont boldSystemFontOfSize:17];
    questionLabel.textColor = [UIColor colorWithHex:0x383838];
    [scrollView addSubview:questionLabel];
    
    // 输入您本次咨询的问题
    _questionTextView = [[LPlaceholderTextView alloc] initWithFrame:CGRectMake(20, 268, 280, 100)];
    _questionTextView.placeholderText = @"例如：1.根据现有资料能否确诊疾病？2.是否需要手术？3.最经济有效的化疗方案是什么？4.单纯中医抗肿瘤及辅助治疗对患者的疗效如何？";
    _questionTextView.placeholderColor = [UIColor colorWithHex:0x9e9e9e];
    _questionTextView.font = [UIFont systemFontOfSize:14];
    _questionTextView.textColor = [UIColor colorWithHex:0x383838];
    _questionTextView.layer.borderWidth = 1.0f;
    _questionTextView.layer.borderColor = [UIColor colorWithHex:0xd1d1d1].CGColor;
    [scrollView addSubview:_questionTextView];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(21, 390, 277, 51);
    [confirmButton setTitle:@"确  认" forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(commitQuestion:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:confirmButton];

    // 添加手势
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
//    tapGestureRecognizer.numberOfTapsRequired = 1;
//    tapGestureRecognizer.numberOfTouchesRequired = 1;
//    [scrollView addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Bussiness methods

// 提交咨询问题
- (void)commitQuestion:(id)sender
{
    [self hideKeyboard];
    
    // 去除空格
    NSString *majorDisease = [_majorDiseaseTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *otherDisease = [_otherDiseaseTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *purpose = [_purposeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *question = [_questionTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([self validateMajorDisease:majorDisease otherDisease:otherDisease purpose:purpose question:question]) {

        [self consultQuestionWithMajorDisease:majorDisease otherDisease:otherDisease purpose:purpose question:question];
    }
}


#pragma mark - API methods

// 调用后台提交咨询问题接口
- (void)consultQuestionWithMajorDisease:(NSString *)majorDisease otherDisease:(NSString *)otherDisease purpose:(NSString *)purpose question:(NSString *)question
{
    NSLog(@"pid: %@, dataId: %@, consultType:%@  majorDisease:%@ otherDisease:%@ purpose:%@ question:%@", self.patientId, self.patientDataId, self.consultType, majorDisease, otherDisease, purpose, question);
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"question"];
    NSLog(@"-----------%--------@", URLString);
    NSDictionary *parameters = @{@"userid": ApplicationDelegate.userId, @"patientid":self.patientId, @"pmid":self.patientDataId, @"type": self.consultType, @"main_disease": majorDisease, @"others_disease": otherDisease, @"consult": purpose, @"question": question, @"cookie": ApplicationDelegate.cookie};
    
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"---------------------%@", responseObject);
        
        TEResultBasicDataModel *result = [[TEResultBasicDataModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = result.state;
        if ([state isEqualToString:@"201"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            
            for (UIViewController *ctrl in self.navigationController.viewControllers) {
                
                if ([ctrl isMemberOfClass:[TEChoosePatientDataViewController class]]) {
                    [self.navigationController popToViewController:ctrl animated:YES];
                }
            }
        }

    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"---------------------%@", responseObject);
//        
//        TEResultBasicDataModel *result = [[TEResultBasicDataModel alloc] initWithDictionary:responseObject error:nil];
//        NSString *state = result.state;
//        if ([state isEqualToString:@"201"]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//            
//            for (UIViewController *ctrl in self.navigationController.viewControllers) {
//
//                if ([ctrl isMemberOfClass:[TEChoosePatientDataViewController class]]) {
//                    [self.navigationController popToViewController:ctrl animated:YES];
//                }
//            }
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
}

#pragma mark - Keyboard

// 隐藏键盘
- (void)hideKeyboard
{
    [self.majorDiseaseTextField resignFirstResponder];
    [self.otherDiseaseTextField resignFirstResponder];
    [self.purposeTextField resignFirstResponder];
    [self.questionTextView resignFirstResponder];
}

#pragma mark - Validate

// 验证主要疾病，其他疾病，咨询目的，咨询问题
- (BOOL)validateMajorDisease:(NSString *)majorDisease otherDisease:(NSString *)otherDisease purpose:(NSString *)purpose question:(NSString *)question
{
    if ([majorDisease length] <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入主要疾病" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if ([purpose length] <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入咨询的目的" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if ([question length] <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入咨询的问题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}

@end
