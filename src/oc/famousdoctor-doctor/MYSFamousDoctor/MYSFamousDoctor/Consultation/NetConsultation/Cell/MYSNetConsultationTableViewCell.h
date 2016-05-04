//
//  MYSNetConsultationTableViewCell.h
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/17.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MYSNetConsultationTableViewCellDelegate <NSObject>

- (void)cellBtnClick:(id)dic;

@end

@interface MYSNetConsultationTableViewCell : UITableViewCell
{
    UIView *bgView;
    UILabel *questionLabel;
    
    id mDic;
}

@property (assign, nonatomic)id<MYSNetConsultationTableViewCellDelegate> delegate;

- (void)sendValue:(id)dic;

+ (CGFloat)calculateCellHeight:(NSString *)content;

@end
