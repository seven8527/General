//
//  TEQuestionDescribeCell.h
//  TumourExpert
//
//  Created by 闫文波 on 14-10-9.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDHTMLLabel.h"
@interface TEQuestionDescribeCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel; // 题目
@property (nonatomic, strong) MDHTMLLabel *questionLabel; // 题目内容

// 计算cell的高度
+ (CGFloat)rowHeightWitObject:(id)object;
@end
