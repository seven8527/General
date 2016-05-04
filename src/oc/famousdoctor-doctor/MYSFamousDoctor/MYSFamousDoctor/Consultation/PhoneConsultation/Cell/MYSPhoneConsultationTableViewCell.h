//
//  MYSPhoneConsultationTableViewCell.h
//  MYSFamousDoctor
//
//  电话咨询 -- 有确认时间Cell
//
//  Created by lyc on 15/4/13.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MYSPhoneConsultationTableViewCellDelegate <NSObject>

- (void)cellBtnClick:(id)dic;

@end

@interface MYSPhoneConsultationTableViewCell : UITableViewCell
{
    IBOutlet UIImageView *bgImageView;
    
    IBOutlet UILabel *timeDateLabel;
    IBOutlet UILabel *typeLabel;
    IBOutlet UILabel *billNoLabel;
    IBOutlet UILabel *queRenTimeLabel;
    IBOutlet UILabel *qiWangTimeLabel;
    IBOutlet UILabel *userInfoLabel;
    
    // 查看病例按钮
    IBOutlet UIButton *lookBtn;
    
    id mDic;
}

@property (assign, nonatomic)id<MYSPhoneConsultationTableViewCellDelegate> delegate;

- (void)sendValue:(id)dic;

@end
