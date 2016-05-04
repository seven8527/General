//
//  MYSNetDetailAllTableViewCell.h
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/19.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MYSNetDetailAllTableViewCellDelegate <NSObject>

- (void)detailCellShouQiBtnClick;

@end

@interface MYSNetDetailAllTableViewCell : UITableViewCell
{
    id mDic;
}

@property (assign, nonatomic)id<MYSNetDetailAllTableViewCellDelegate> delegate;

- (void)sendValue:(id)dic;

+ (CGFloat)calculateCellHeight:(NSString *)content;

@end
