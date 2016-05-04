//
//  TEExpertCell.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-26.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TEExpertCell : UITableViewCell

@property (nonatomic, strong) UILabel *doctorLabel; // 医生姓名
@property (nonatomic, strong) UIImageView *iconImageView; // 医生头像
@property (nonatomic, strong) UILabel *titleLabel; // 医生职称
@property (nonatomic, strong) UILabel *departmentLabel; // 所在科室
@property (nonatomic, strong) UILabel *hospitalLabel; // 医院名称

@property (nonatomic, strong) UILabel *areaLabel; // 地区
@property (nonatomic, strong) UILabel *consultCountLabel; // 咨询人数

@end


