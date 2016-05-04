//
//  TEOrderCell.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-4.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TEOrderCell : UITableViewCell

@property (nonatomic, strong) UILabel *orderIDLabel; // 订单编号
@property (nonatomic, strong) UILabel *priceLabel; // 订单价格
@property (nonatomic, strong) UILabel *stateLabel; // 订单状态
@property (nonatomic, strong) UILabel *timeLabel; // 订单时间
@property (nonatomic, strong) UILabel *doctorLabel; // 医生姓名
@property (nonatomic, strong) UIImageView *iconImageView; // 医生头像
@property (nonatomic, strong) UILabel *titleLabel; // 医生职称
@property (nonatomic, strong) UILabel *hospitalLabel; // 医院名称
@property (nonatomic, strong) UIButton *cancelOrderButton; // 取消订单
@property (nonatomic, strong) UIButton *payButton; // 支付按钮
@property (nonatomic, strong) UILabel *askTypeLabel; // 咨询类型

// 计算cell的高度
+ (CGFloat)rowHeightWitObject:(id)object;

@end
