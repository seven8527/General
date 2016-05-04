//
//  MYSCollectionViewCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-29.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSCollectionViewCell.h"
#import "UIColor+Hex.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MYSFoundationCommon.h"


#define userIconWidth 20
#define doctorIconWidth 45
#define subViewMarginToLeft 10
#define subViewMarginToRight 10
#define timePicWidth 10



@interface MYSCollectionViewCell ()
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, weak) UIImageView *userIconImageView; // 用户头衔
@property (nonatomic, weak) UILabel *userNameLabel; // 用户名称
@property (nonatomic, weak) UILabel *orderStatusLabel; // 订单状态
@property (nonatomic, weak) UIView *topLine;
@property (nonatomic, weak) UIImageView *doctorIconImageView; // 专家头像
@property (nonatomic, weak) UILabel *doctorNameLabel; // 专家名称
//@property (nonatomic, weak) UILabel *consultTypeLabel; // 咨询类型
@property (nonatomic, weak) UILabel *orderNumberLabel; // 订单号
@property (nonatomic, weak) UIView *bottomLine;
@property (nonatomic, weak) UIImageView *timePicView; // 时间图标
@property (nonatomic, weak) UILabel *timeLabel; // 时间
@property (nonatomic, weak) UIButton *payButton; // 去支付
@property (nonatomic, weak) UIButton *checkOrderButton; // 查看订单
@property (nonatomic, weak) UIImageView *backImageView; //背景

@end
@implementation MYSCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorFromHexRGB:KFFFFFFColor];
         self.didSetupConstraints = NO;
        
        UIImageView *backImageView = [UIImageView newAutoLayoutView];
        backImageView.image = [[UIImage imageNamed:@"zoe_bg_white_"] resizableImageWithCapInsets:UIEdgeInsetsMake(50, 2, 0, 2) resizingMode:UIImageResizingModeTile];
        backImageView.userInteractionEnabled = YES;
        self.backImageView = backImageView;
        [self.contentView addSubview:backImageView];

        
        UIImageView *userIconImageView = [UIImageView newAutoLayoutView]; // 用户头衔
        userIconImageView.layer.cornerRadius = userIconWidth/2;
        userIconImageView.clipsToBounds = YES;
        self.userIconImageView = userIconImageView;
        [self.backImageView addSubview:userIconImageView];
        
        UILabel *userNameLabel = [UILabel newAutoLayoutView]; // 用户名称
        userNameLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
        userNameLabel.font = [UIFont systemFontOfSize:13];
        self.userNameLabel = userNameLabel;
        [self.backImageView addSubview:userNameLabel];
        
        UILabel *orderStatusLabel = [UILabel newAutoLayoutView]; // 订单状态
        orderStatusLabel.textAlignment = NSTextAlignmentRight;
        orderStatusLabel.textColor = [UIColor colorFromHexRGB:KEF8004Color];
        orderStatusLabel.font = [UIFont systemFontOfSize:13];
        self.orderStatusLabel = orderStatusLabel;
        [self.backImageView addSubview:orderStatusLabel];
        
        UIView *topLine = [UIView newAutoLayoutView];
        topLine.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
        self.topLine = topLine;
        [self.backImageView addSubview:topLine];
        
        UIImageView *doctorIconImageView = [UIImageView newAutoLayoutView]; // 专家头像
        doctorIconImageView.layer.cornerRadius = doctorIconWidth/2;
        doctorIconImageView.clipsToBounds = YES;
        doctorIconImageView.backgroundColor = [UIColor purpleColor];
        self.doctorIconImageView = doctorIconImageView;
        [self.backImageView addSubview:doctorIconImageView];
        
        UILabel *doctorNameLabel = [UILabel newAutoLayoutView]; // 专家名称
        self.doctorNameLabel = doctorNameLabel;
        doctorNameLabel.font = [UIFont systemFontOfSize:16];
        doctorNameLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
        [self.backImageView addSubview:doctorNameLabel];
        
//        UILabel *consultTypeLabel = [UILabel newAutoLayoutView]; // 咨询类型
//        consultTypeLabel.font = [UIFont systemFontOfSize:13];
//        consultTypeLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
//        self.consultTypeLabel = consultTypeLabel;
//        [self.backImageView addSubview:consultTypeLabel];
        
        UILabel *orderNumberLabel = [UILabel newAutoLayoutView]; // 订单号
        orderNumberLabel.font = [UIFont systemFontOfSize:12];
        orderNumberLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
        self.orderNumberLabel = orderNumberLabel;
        [self.backImageView addSubview:orderNumberLabel];
        
        UIView *bottomLine = [UIView newAutoLayoutView];
        self.bottomLine = bottomLine;
        bottomLine.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
        [self.backImageView addSubview:bottomLine];
        
        UIImageView *timePicView = [UIImageView newAutoLayoutView]; // 时间图标
        self.timePicView = timePicView;
        [self.backImageView addSubview:timePicView];
        
        UILabel *timeLabel = [UILabel newAutoLayoutView]; // 时间
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
        self.timeLabel = timeLabel;
        [self.backImageView addSubview:timeLabel];
        
        UIButton *payButton = [UIButton newAutoLayoutView]; // 去支付
        payButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [payButton setTitle:@"去支付" forState:UIControlStateNormal];
        payButton.backgroundColor = [UIColor colorFromHexRGB:KFFFFFFColor];
        payButton.layer.borderWidth = 1.0;
        [payButton addTarget:self action:@selector(clickPayButton) forControlEvents:UIControlEventTouchUpInside];
        payButton.layer.borderColor = [UIColor colorFromHexRGB:KEF8004Color].CGColor;
        [payButton setTitleColor:[UIColor colorFromHexRGB:KEF8004Color] forState:UIControlStateNormal];
        payButton.layer.cornerRadius = 3;
        payButton.clipsToBounds = YES;
        self.payButton = payButton;
        [self.backImageView addSubview:payButton];
        
        UIButton *checkOrderButton = [UIButton newAutoLayoutView]; // 查看订单
        checkOrderButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [checkOrderButton setTitle:@"查看订单" forState:UIControlStateNormal];
        checkOrderButton.backgroundColor = [UIColor colorFromHexRGB:KFFFFFFColor];
        checkOrderButton.layer.borderWidth = 0.50;
        [checkOrderButton addTarget:self action:@selector(clickCheckOrderButton) forControlEvents:UIControlEventTouchUpInside];
        checkOrderButton.layer.borderColor = [UIColor colorFromHexRGB:K00907FColor].CGColor;
        [checkOrderButton setTitleColor:[UIColor colorFromHexRGB:K00907FColor] forState:UIControlStateNormal];
        checkOrderButton.layer.cornerRadius = 3;
        checkOrderButton.clipsToBounds = YES;
        self.checkOrderButton = checkOrderButton;
        [self.backImageView addSubview:checkOrderButton];
       
    }
    
    [self updateViewConstraints];
    return self;
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.backImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.backImageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.backImageView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.backImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        
        [self.userIconImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:subViewMarginToLeft];
        [self.userIconImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12];
        [self.userIconImageView autoSetDimensionsToSize:CGSizeMake(userIconWidth, userIconWidth)];
        
        [self.orderStatusLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:subViewMarginToRight];
        [self.orderStatusLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:16];
        [self.orderStatusLabel autoSetDimensionsToSize:CGSizeMake(100, 12)];
        
        [self.userNameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:16];
        [self.userNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.userIconImageView withOffset:5];
        [self.userNameLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.orderStatusLabel withOffset:10];
        [self.userNameLabel autoSetDimension:ALDimensionHeight toSize:12];
        
        [self.topLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:subViewMarginToLeft];
        [self.topLine autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:43];
        [self.topLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:subViewMarginToRight];
        [self.topLine autoSetDimension:ALDimensionHeight toSize:1];
        
        
        [self.doctorIconImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:subViewMarginToLeft];
        [self.doctorIconImageView autoSetDimensionsToSize:CGSizeMake(doctorIconWidth, doctorIconWidth)];
        [self.doctorIconImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.topLine withOffset:10];
        
        [self.doctorNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.doctorIconImageView withOffset:10];
        [self.doctorNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.topLine withOffset:13];
        [self.doctorNameLabel autoSetDimension:ALDimensionHeight toSize:15];
        [self.doctorNameLabel autoSetDimension:ALDimensionWidth toSize:80]; // 根据长度判断 需放到模型
//        
//        [self.consultTypeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.doctorNameLabel withOffset:0];
//        [self.consultTypeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.topLine withOffset:15];
//        [self.consultTypeLabel autoSetDimension:ALDimensionHeight toSize:12];
//        [self.consultTypeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:subViewMarginToRight];
        
        [self.orderNumberLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.doctorIconImageView withOffset:10];
        [self.orderNumberLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.doctorNameLabel withOffset:12];
        [self.orderNumberLabel autoSetDimension:ALDimensionHeight toSize:11];
        [self.orderNumberLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:subViewMarginToRight];
        
        [self.bottomLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:subViewMarginToLeft];
        [self.bottomLine autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.doctorIconImageView withOffset:9];
        [self.bottomLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:subViewMarginToRight];
        [self.bottomLine autoSetDimension:ALDimensionHeight toSize:1];

        [self.timePicView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:subViewMarginToLeft];
        [self.timePicView autoSetDimensionsToSize:CGSizeMake(timePicWidth, timePicWidth)];
        [self.timePicView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.bottomLine withOffset:19];
        
        [self.timeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.timePicView withOffset:5];
        [self.timeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.bottomLine withOffset:19];
        [self.timeLabel autoSetDimensionsToSize:CGSizeMake(150, 12)];
        
        [self.checkOrderButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:subViewMarginToRight];
        [self.checkOrderButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.bottomLine withOffset:13.5];
        [self.checkOrderButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:13];
        [self.checkOrderButton autoSetDimension:ALDimensionWidth toSize:64];
        
        [self.payButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.checkOrderButton withOffset:-10];
        [self.payButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.bottomLine withOffset:13.5];
        [self.payButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:13];
        [self.payButton autoSetDimension:ALDimensionWidth toSize:64];
        
        
        self.didSetupConstraints = YES;
    }
    
    
}

- (void)setOrderModel:(MYSOrderModel *)orderModel
{
    _orderModel = orderModel;
     self.payButton.hidden = YES;
    
     self.timePicView.image =[UIImage imageNamed:@"doctor_icon_time_"];
    
    self.userNameLabel.text = orderModel.patientName;
    if (orderModel.orderState == 0) {
        self.orderStatusLabel.text = @"待审核";
    } else if (orderModel.orderState == 1) {
        self.orderStatusLabel.text = @"已通过";
    } else if (orderModel.orderState == 2) {
        self.orderStatusLabel.text = @"等待咨询";
    } else if (orderModel.orderState == 3) {
        self.orderStatusLabel.text = @"已完成";
    } else if (orderModel.orderState == 4) {
        self.orderStatusLabel.text = @"已取消";
    } else if (orderModel.orderState == 5) {
        self.orderStatusLabel.text = @"爽约";
    } else if (orderModel.orderState == 7) {
        self.orderStatusLabel.text = @"退款申请中";
    } else if (orderModel.orderState == 8) {
        self.orderStatusLabel.text = @"退款已审核";
    } else if (orderModel.orderState == 9) {
        self.orderStatusLabel.text = @"已退款";
    }
    
    if (orderModel.payState == 0) {
        self.payButton.hidden = NO;
    } else{
        self.payButton.hidden = YES;
    }
    
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单号：%@",orderModel.orderId];
    
    self.timeLabel.text = [orderModel.orderTime substringToIndex:10];
//    if (orderModel.orderType == 0) {
//        self.consultTypeLabel.text = @""; //网络咨询
//    } else if (orderModel.orderType == 1) {
//        self.consultTypeLabel.text = @"";//电话咨询
//    } else if (orderModel.orderType == 2) {
//        self.consultTypeLabel.text = @"";//面对面咨询
//    }
    
    self.doctorNameLabel.text = orderModel.expertName;
    
   [self.doctorNameLabel autoSetDimension:ALDimensionWidth toSize:[MYSFoundationCommon sizeWithText:self.doctorNameLabel.text withFont:self.doctorNameLabel.font].width];
    
    NSString *placeholerImage = [MYSFoundationCommon placeHolderImageWithGender:orderModel.gender andBirthday:orderModel.birthday];
    
    [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:orderModel.patientPic] placeholderImage:[UIImage imageNamed:placeholerImage]];
    [self.doctorIconImageView sd_setImageWithURL:[NSURL URLWithString:orderModel.doctorPic] placeholderImage:[UIImage imageNamed:@"favicon_doctor_man"]];
}


#warning 点击查看订单
- (void)clickCheckOrderButton
{
    NSDictionary *userInfo = @{@"orderId": self.orderModel.orderId, @"consultType" :[NSString stringWithFormat:@"%d",self.orderModel.orderType], @"doctorPic": self.orderModel.doctorPic, @"patientPic": self.userIconImageView.image};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"personalCheckOrderButton" object:nil userInfo:userInfo];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)clickPayButton
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"personalClickPayButton" object:self.orderModel userInfo:nil];
}

@end
