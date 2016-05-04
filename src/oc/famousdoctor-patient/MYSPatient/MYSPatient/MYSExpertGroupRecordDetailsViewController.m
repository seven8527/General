//
//  MYSExpertGroupRecordDetailsViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-16.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupRecordDetailsViewController.h"
#import "MYSFoundationCommon.h"
#import <DTCoreText/DTCoreText.h>
#import "UIColor+Hex.h"

#define leftMargin 15

@interface MYSExpertGroupRecordDetailsViewController ()
@property (nonatomic, weak) UIScrollView *mainView;
@property (nonatomic, weak) UIView *leftLine; // 标题左侧竖线
@property (nonatomic, weak) UILabel *titleLabel; // 标题
@property (nonatomic, weak) UIView *firstLine;
//@property (nonatomic, weak) UILabel *resourceLabel; // 来源
//@property (nonatomic, weak) UILabel *timeLabel; // 时间
@property (nonatomic, weak) DTAttributedTextView *contentView;
@end

@implementation MYSExpertGroupRecordDetailsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    
    
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_button_share_"] style:UIBarButtonItemStyleDone target:self action:@selector(share)];
//    rightButton.tintColor = [UIColor colorFromHexRGB:K00A693Color];
//    self.navigationItem.rightBarButtonItem = rightButton;

    
    [self layoutUI];
}

- (void)layoutUI
{
    
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 174)];
    self.mainView = mainView;
    [self.view addSubview:mainView];
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, 14, 2, 24)];
    self.leftLine = leftLine;
    leftLine.backgroundColor = [UIColor redColor];
    [mainView addSubview:leftLine];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.text = @"阿发哪个，都可能发到付件啊啊大房间；就看看；了；拉克等方式就卡卡里是否考虑将爱的疯狂了；是否健康的飞机看来；东方健康了；东方健康了；大家快乐；阿发监考老师";
    CGSize  titleSize = [MYSFoundationCommon sizeWithText:titleLabel.text withFont:titleLabel.font constrainedToSize:CGSizeMake(kScreen_Width - 40, MAXFLOAT)];
    titleLabel.frame = CGRectMake(leftMargin + 10, 14, titleSize.width, titleSize.height);
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
    self.titleLabel = titleLabel;
    [mainView addSubview:titleLabel];
    
    
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, CGRectGetMaxY(titleLabel.frame), kScreen_Width - 30 , 0.5)];
    self.firstLine = firstLine;
    firstLine.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    [mainView addSubview:firstLine];

    
}

- (void)setModel:(id)model
{
    _model = model;
    
}


// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
