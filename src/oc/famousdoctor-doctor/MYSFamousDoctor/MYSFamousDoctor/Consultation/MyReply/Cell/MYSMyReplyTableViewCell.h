//
//  MYSMyReplyTableViewCell.h
//  MYSFamousDoctor
//
//  我的回复 - Cell
//
//  Created by lyc on 15/4/14.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSMyReplyTableViewCell : UITableViewCell
{
    UIView *bgView;
    UILabel *questionLabel;
    UILabel *replyLabel;
    
    // 新消息Image
    UIImageView *haveNewsImage;
    // 新消息Label
    UILabel *haveNewsLabel;
}

- (void)sendValue:(id)dic;

+ (CGFloat)calculateCellHeight:(NSString *)question reply:(NSString *)reply;

@end
