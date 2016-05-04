//
//  MYSPatientQuestionsTableViewCell.h
//  MYSFamousDoctor
//
//  患者提问-cell
//
//  Created by lyc on 15/4/14.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MYSPatientQuestionsTableViewCellDelegate <NSObject>

- (void)cellBtnClick:(id)dic;

@end

@interface MYSPatientQuestionsTableViewCell : UITableViewCell
{
    UIView *bgView;
    UILabel *questionLabel;
    
    id mDic;
}

@property (assign, nonatomic)id<MYSPatientQuestionsTableViewCellDelegate> delegate;

- (void)sendValue:(id)dic;

+ (CGFloat)calculateCellHeight:(NSString *)question;

@end
