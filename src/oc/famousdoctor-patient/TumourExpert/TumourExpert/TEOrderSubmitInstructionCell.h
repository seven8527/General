//
//  TEOrderSubmitInstructionCell.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-20.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

// 订单提交说明
@interface TEOrderSubmitInstructionCell : UITableViewCell
@property (nonatomic, assign) int payType; // 支付方式
@property (nonatomic, strong) UILabel *nameLabel; // 开户名
@property (nonatomic, strong) UILabel *accountLabel; // 账号
@property (nonatomic, strong) UILabel *bankLabel; // 开户银行
@property (nonatomic, strong) UILabel *messageLabel; // 提示信息
@property (nonatomic, strong) UILabel *remindLabel; // 特别提醒
@property (nonatomic, strong) UIImageView *starImageView; // *

// 计算cell的高度
+ (CGFloat)rowHeight:(int)payType;
@end
