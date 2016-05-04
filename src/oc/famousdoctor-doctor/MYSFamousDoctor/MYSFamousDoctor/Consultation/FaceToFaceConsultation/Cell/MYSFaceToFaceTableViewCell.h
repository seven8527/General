//
//  MYSFaceToFaceTableViewCell.h
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/19.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MYSFaceToFaceTableViewCellDelegate <NSObject>

- (void)cellBtnClick:(id)dic;

@end

@interface MYSFaceToFaceTableViewCell : UITableViewCell
{
    IBOutlet UIImageView *bgImageView;
    
    IBOutlet UILabel *topAddDate;
    IBOutlet UILabel *topType;
    
    IBOutlet UILabel *middleBillNo;
    IBOutlet UILabel *middleQueRenTime;
    IBOutlet UILabel *middleQiWangTime;
    
    IBOutlet UILabel *bottomUserInfo;
    IBOutlet UIButton *lookBtn;
    
    id mDic;
}

@property (assign, nonatomic)id<MYSFaceToFaceTableViewCellDelegate> delegate;

- (void)sendValue:(id)dic;

@end
