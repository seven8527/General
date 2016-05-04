//
//  MYSNetDetailTableViewCell.h
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/17.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MYSNetDetailTableViewCellDelegate <NSObject>

- (void)detailCellZhanKaiBtnClick;

@end

@interface MYSNetDetailTableViewCell : UITableViewCell
{
    id mDic;
}

@property (assign, nonatomic)id<MYSNetDetailTableViewCellDelegate> delegate;

- (void)sendValue:(id)dic;

+ (CGFloat)calculateCellHeight:(NSString *)content;

@end
