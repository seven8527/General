//
//  TETextConsultInstructionCell.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-20.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TETextConsultInstructionCellDelegate
- (void)didSelectedAgreement:(BOOL)selected;
@end

// 网络咨询说明
@interface TETextConsultInstructionCell : UITableViewCell
@property (nonatomic, strong) UILabel *promptInstructionLabel; // 提示服务说明
@property (nonatomic, strong) UILabel *instructionLabel; // 服务说明内容
@property (nonatomic, strong) UIButton *agreementCheckbox; // 同意提示信息按钮
@property (nonatomic, strong) UILabel *agreementLabel; // 同意提示信息
@property (nonatomic, strong) UIView *gestureView;

@property (nonatomic, assign) id<TETextConsultInstructionCellDelegate> delegate;

// 计算cell的高度
+ (CGFloat)rowHeight;
@end
