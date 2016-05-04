//
//  MYSFeedBackViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-6.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSFeedBackViewController.h"
#import "LPlaceholderTextView.h"
#import "NSString+CalculateTextSize.h"
#import "UIColor+Hex.h"
#import "UIImage+Corner.h"
#import "MYSFoundationCommon.h"
#import "HttpTool.h"
#import "ValidateTools.h"

#define marginToSuperView 10

@interface MYSFeedBackViewController () <UITextViewDelegate, UITextFieldDelegate>
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, weak) UILabel *feedbackLabel;
@property (nonatomic, weak) UILabel *contactLabel;
@property (nonatomic, weak) LPlaceholderTextView *contentTextView; // 反馈内容
@property (nonatomic, weak) UITextField *contactTextField; // 联系方式
@property (nonatomic, weak) UIButton *commitButton; // 提交
@end

@implementation MYSFeedBackViewController

#pragma mark - UIViewController lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    
    self.view.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    [self layoutUI];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    UIImage *normalImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:K00A693Color] withButton:self.commitButton];
    [self.commitButton setBackgroundImage:[UIImage createRoundedRectImage:normalImage size:normalImage.size radius:5] forState:UIControlStateNormal];
    
    UIImage *highlightImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:K00907FColor] withButton:self.commitButton];
    [self.commitButton setBackgroundImage:[UIImage createRoundedRectImage:highlightImage size:normalImage.size radius:5] forState:UIControlStateHighlighted];
}

// UI布局
- (void)layoutUI
{
    
    // 反馈的标签
    UILabel *feedbackLabel = [UILabel newAutoLayoutView];
    feedbackLabel.text = @"我们将认真聆听，您的建议是";
    feedbackLabel.font = [UIFont boldSystemFontOfSize:16];
    feedbackLabel.textColor = [UIColor colorFromHexRGB:K525252Color];
    self.feedbackLabel = feedbackLabel;
    [self.view addSubview:feedbackLabel];
    
    // 反馈
    LPlaceholderTextView *contentTextView = [LPlaceholderTextView newAutoLayoutView];
    contentTextView.placeholderText = @"请输入您要反馈的内容";
    contentTextView.placeholderColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    contentTextView.font = [UIFont systemFontOfSize:13];
    contentTextView.textColor = [UIColor blackColor];
    contentTextView.layer.borderWidth = 0.5f;
    contentTextView.layer.cornerRadius = 5;
    contentTextView.layer.borderColor = [UIColor colorFromHexRGB:KC2C2C2Color].CGColor;
    self.contentTextView = contentTextView;
    [self.view addSubview:contentTextView];
    
    // 联系方式的标签
    UILabel *contactLabel = [UILabel newAutoLayoutView];
    contactLabel.text = @"您的手机联系方式是";
    contactLabel.font = [UIFont boldSystemFontOfSize:16];
    contactLabel.textColor = [UIColor colorFromHexRGB:K525252Color];
    self.contactLabel = contactLabel;
    [self.view addSubview:contactLabel];
    
    // 联系方式
    UITextField *contactTextField = [UITextField newAutoLayoutView];
    contactTextField.layer.cornerRadius = 5.0;
    contactTextField.borderStyle = UITextBorderStyleRoundedRect;
    contactTextField.delegate = self;
    contactTextField.font = [UIFont systemFontOfSize:13];
    contactTextField.textColor = [UIColor blackColor];
    contactTextField.clearButtonMode = YES;
    contactTextField.keyboardType = UIKeyboardTypeNumberPad;
    NSDictionary *placeholderAttributes = @{NSForegroundColorAttributeName : [UIColor colorFromHexRGB:KC2C2C2Color], NSFontAttributeName : [UIFont systemFontOfSize:14]};
    contactTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入联系方式" attributes:placeholderAttributes];
    self.contactTextField = contactTextField;
    [self.view addSubview:contactTextField];
    
    // 提交
    UIButton *commitButton = [UIButton newAutoLayoutView];
    commitButton.layer.cornerRadius = 5.0;
    commitButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [commitButton setTitleColor:[UIColor colorFromHexRGB:KFFFFFFColor] forState:UIControlStateNormal];
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commitFeedback) forControlEvents:UIControlEventTouchUpInside];
    self.commitButton = commitButton;
    [self.view addSubview:commitButton];
    
    // 添加手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    
    [self updateViewConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        self.didSetupConstraints = YES;
        
        CGFloat subviewMargin = iPhone4 ? 10 : 25;
        
        CGFloat suviewHeight = iPhone4 ? 21 : 40;

        if (kScreen_Height == 480) {
            subviewMargin = 10;
            suviewHeight = 21;
        }

        // 反馈内容提示
        [self.feedbackLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:marginToSuperView];
        [self.feedbackLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:marginToSuperView];
        [self.feedbackLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:74];
        [self.feedbackLabel autoSetDimension:ALDimensionHeight toSize:suviewHeight];
        
        // 提交按钮
        [self.commitButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [self.commitButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [self.commitButton autoSetDimension:ALDimensionHeight toSize:44];
        [self.commitButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:220];

        // 联系方式
        [self.contactTextField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:marginToSuperView];
        [self.contactTextField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:marginToSuperView];
        [self.contactTextField autoSetDimension:ALDimensionHeight toSize:44];
        [self.contactTextField autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.commitButton withOffset:- subviewMargin];
        
        // 联系方式提示
        [self.contactLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:marginToSuperView];
        [self.contactLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:marginToSuperView];
        [self.contactLabel autoSetDimension:ALDimensionHeight toSize:suviewHeight];
        [self.contactLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.contactTextField withOffset:0];
        
        // 反馈内容
        [self.contentTextView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:marginToSuperView];
        [self.contentTextView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:marginToSuperView];
        [self.contentTextView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.feedbackLabel withOffset:0];
        [self.contentTextView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.contactLabel withOffset:0];
    }
    
    [super updateViewConstraints];
}


// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}


// 隐藏键盘
- (void)hideKeyboard
{
    [self.contentTextView resignFirstResponder];
    [self.contactTextField resignFirstResponder];
}


// 点击退出键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard];
}

// 提交意见反馈
- (void)commitFeedback
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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"feedback"];
    NSDictionary *parameters = @{@"content": content, @"phone":contact};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"%@", responseObject);
        int state = [[responseObject valueForKey:@"state"] intValue];
        if (state == 205) {
            self.contentTextView.text = @"";
            self.contactTextField.text = @"";
            
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"反馈成功";
            [hud hide:YES afterDelay:1];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        LOG(@"Error: %@", error);
    }];
}

#pragma mark - Validate

// 验证反馈内容和联系方式
- (BOOL)validateContent:(NSString *)content contact:(NSString *)contact
{
    if ([content length] < 10 || [content length] > 200) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"反馈内容10至200个字符" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        [_contentTextView becomeFirstResponder];
        return NO;
    }
    
    if (![ValidateTools validateMobile:contact]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        [_contactTextField becomeFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
