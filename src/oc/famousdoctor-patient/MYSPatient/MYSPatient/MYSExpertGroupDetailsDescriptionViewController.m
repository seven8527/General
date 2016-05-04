//
//  MYSExpertGroupDetailsDescriptionViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-11.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupDetailsDescriptionViewController.h"
#import "LPlaceholderTextView.h"
#import "UIColor+Hex.h"
#import "MYSFoundationCommon.h"

#define marginToSuperView 10

@interface MYSExpertGroupDetailsDescriptionViewController () <UITextViewDelegate>
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, weak) UILabel *tipLabel; // 描述提示
@property (nonatomic, weak) LPlaceholderTextView *contentTextView; // 描述内容
@property (nonatomic, weak) UILabel *textTipLabel; // 字数提示
@end

@implementation MYSExpertGroupDetailsDescriptionViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"详细描述";
    
    self.view.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [rightButton addTarget:self action:@selector(clickRightBarBurron) forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorFromHexRGB:K9E9E9EColor] forState:UIControlStateDisabled];
    [rightButton setTitleColor:[UIColor colorFromHexRGB:K00907FColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    
    [self layoutUI];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

// UI布局
- (void)layoutUI
{
    
    // 反馈的标签
    UILabel *tipLabel = [UILabel newAutoLayoutView];
    tipLabel.numberOfLines = 0;
    tipLabel.text = self.tipText;
    tipLabel.font = [UIFont boldSystemFontOfSize:16];
    tipLabel.textColor = [UIColor colorFromHexRGB:K525252Color];
    self.tipLabel = tipLabel;
    [self.view addSubview:tipLabel];
    
    // 反馈
    LPlaceholderTextView *contentTextView = [LPlaceholderTextView newAutoLayoutView];
    contentTextView.delegate = self;
    //    contentTextView.placeholderText = @"请输入您要反馈的内容";
    contentTextView.text = self.contentStr;
    contentTextView.placeholderColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    contentTextView.font = [UIFont systemFontOfSize:13];
    contentTextView.textColor = [UIColor blackColor];
    contentTextView.layer.borderWidth = 0.5f;
    contentTextView.layer.cornerRadius = 5;
    contentTextView.layer.borderColor = [UIColor colorFromHexRGB:KC2C2C2Color].CGColor;
    self.contentTextView = contentTextView;
    [self.view addSubview:contentTextView];
    
    UILabel *textTipLabel = [UILabel newAutoLayoutView];
    textTipLabel.text = @"20-1000个字";
    textTipLabel.textAlignment = NSTextAlignmentRight;
    textTipLabel.font = [UIFont systemFontOfSize:13];
    textTipLabel.textColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    self.textTipLabel = textTipLabel;
    [self.view addSubview:textTipLabel];
    
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
        
        //        CGFloat subviewMargin = iPhone4 ? 10 : 25;
        //
        //        CGFloat suviewHeight = iPhone4 ? 21 : 40;
        //
        // 反馈内容提示
        [self.tipLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:marginToSuperView];
        [self.tipLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:marginToSuperView];
        [self.tipLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:74];
        CGSize tipSize = [MYSFoundationCommon sizeWithText:self.tipLabel.text withFont:self.tipLabel.font constrainedToSize:CGSizeMake(kScreen_Width - 2 * marginToSuperView, MAXFLOAT)];
        [self.tipLabel autoSetDimension:ALDimensionHeight toSize:tipSize.height + 10];
        
        // 字数提示
        [self.textTipLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [self.textTipLabel autoSetDimensionsToSize:CGSizeMake(200, 30)];
        [self.textTipLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:250];
        
        
        // 反馈内容
        [self.contentTextView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:marginToSuperView];
        [self.contentTextView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:marginToSuperView];
        [self.contentTextView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.tipLabel withOffset:15];
        [self.contentTextView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.textTipLabel withOffset:0];
    }
    
    [super updateViewConstraints];
}

#pragma mark textViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
    }
}


- (void)setTipText:(NSString *)tipText
{
    _tipText = tipText;
    
}

- (void)setContentStr:(NSString *)contentStr
{
    _contentStr = contentStr;
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
}


// 点击退出键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard];
}

// 保存
- (void)clickRightBarBurron
{
    if ([self validate]) {
        [self.navigationController popViewControllerAnimated:YES];
        if ([self.delegate respondsToSelector:@selector(expertGroupDetailsDescriptionViewSavedWithContentStr:withMark:)]) {
            [self.delegate expertGroupDetailsDescriptionViewSavedWithContentStr:self.contentTextView.text withMark:self.mark];
        }
    }
    
}

- (BOOL)validate
{
    if (self.contentTextView.text.length > 20 && self.contentTextView.text.length < 1000) {
        return YES;
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入20 - 1000个字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
        return NO;
    }
}

@end
