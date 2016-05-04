//
//  TEDiseaseCell.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-28.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDHTMLLabel.h"

@interface TEDiseaseCell : UITableViewCell

@property (nonatomic, strong) UIImageView *dot; // 圆点
@property (nonatomic, strong) UILabel *itemLabel; // 疾病项目
@property (nonatomic, strong) MDHTMLLabel *itemIntroLabel; // 疾病项目介绍

@end
