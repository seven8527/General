//
//  TEPhoneConsultInstructionCell.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-20.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TEPhoneConsultInstructionCellDelegate
- (void)didSelectedPhone:(BOOL)phoneSelected agreement:(BOOL)agreementSelected;
@end

@interface TEPhoneConsultInstructionCell : UITableViewCell
@property (nonatomic, strong) UIButton *phoneCheckbox; // 同意电话咨询协议按钮
@property (nonatomic, strong) UILabel *promptInstructionLabel; // 提示服务说明
@property (nonatomic, strong) UIButton *agreementButton;  // 电话咨询协议
@property (nonatomic, strong) UILabel *instructionLabel; // 服务说明内容
@property (nonatomic, strong) UIButton *agreementCheckbox; // 同意提示信息按钮
@property (nonatomic, strong) UILabel *agreementLabel; // 同意提示信息
@property (nonatomic, strong) UIView *phoneGestureView;
@property (nonatomic, strong) UIView *agreementGestureView;

@property (nonatomic, assign) id<TEPhoneConsultInstructionCellDelegate> delegate;

// 计算cell的高度
+ (CGFloat)rowHeight;
@end
