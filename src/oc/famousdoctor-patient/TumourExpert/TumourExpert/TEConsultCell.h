//
//  TEConsultCell.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-29.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TEConsultCell : UITableViewCell

@property (nonatomic, strong) UILabel *patientLabel; // 患者姓名
@property (nonatomic, strong) UILabel *timeLabel; // 咨询时间
@property (nonatomic, strong) UILabel *doctorLabel; // 咨询的医生
@property (nonatomic, strong) UILabel *stateLabel; // 咨询状态

@end
