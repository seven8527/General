//
//  TEConsultReplyCell.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-30.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDHTMLLabel.h"

@interface TEConsultReplyCell : UITableViewCell

@property (nonatomic, strong) UILabel *promptLabel; // 提示是第几个问题
@property (nonatomic, strong) UILabel *userLabel; // 用户
@property (nonatomic, strong) MDHTMLLabel *questionLabel; // 用户的问题
@property (nonatomic, strong) UILabel *doctorLabel; // 医生
@property (nonatomic, strong) MDHTMLLabel *answerLabel; // 医生的回答
@property (nonatomic, strong) UIImageView *line; // 线

// 计算cell的高度
+ (CGFloat)rowHeightWitObject:(id)object;

@end
