//
//  TESeekExpertCell.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-27.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TESeekExpertCell : UITableViewCell

@property (nonatomic, strong) UILabel *doctorLabel; // 医生姓名
@property (nonatomic, strong) UIImageView *iconImageView; // 医生头像
@property (nonatomic, strong) UILabel *titleLabel; // 医生职称
@property (nonatomic, strong) UILabel *hospitalLabel; // 医院名称

@end
