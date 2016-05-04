//
//  MYSPhoneConsultationTableViewCell1.h
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/13.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MYSPhoneConsultationTableViewCell1Delegate <NSObject>

- (void)cell1BtnClick:(id)dic;

@end

@interface MYSPhoneConsultationTableViewCell1 : UITableViewCell
{
    IBOutlet UIImageView *bgImageView;
    
    IBOutlet UILabel *timeDateLabel;
    IBOutlet UILabel *billNoLabel;
    IBOutlet UILabel *qiWangTimeLabel;
    IBOutlet UILabel *userInfoLabel;
    
    // 查看病例按钮
    IBOutlet UIButton *lookBtn;
    
    id mDic;
}

@property (assign, nonatomic)id<MYSPhoneConsultationTableViewCell1Delegate> delegate;

- (void)sendValue:(id)dic;

@end
