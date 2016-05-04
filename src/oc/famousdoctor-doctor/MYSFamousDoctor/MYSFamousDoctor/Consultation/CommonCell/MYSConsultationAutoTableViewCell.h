//
//  MYSConsultationAutoTableViewCell.h
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/13.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum AutoCellType
{
    AutoTableViewCellHaveTitle,
    AutoTableViewCellNoTitle
} AutoCellType;

typedef enum BottomLineType
{
    HaveMargin,
    All
} BottomLineType;

@interface MYSConsultationAutoTableViewCell : UITableViewCell
{
    UILabel *contentLabel;
    UILabel *titleLabel;
}

/**
 * 设定Cell
 */
- (void)sendValue:(NSString *)title titleFont:(UIFont *)titleFont content:(NSString *)content contentFont:(UIFont *)contentFont cellType:(AutoCellType)type bottomLineType:(BottomLineType)lineType;

/**
 * 通过字体，和字符串计算Cell的高度
 */
+ (CGFloat)cellHeight:(NSString *)title titleFont:(UIFont *)titleFont content:(NSString *)content contentFont:(UIFont *)contentFont cellType:(AutoCellType)type;

@end
