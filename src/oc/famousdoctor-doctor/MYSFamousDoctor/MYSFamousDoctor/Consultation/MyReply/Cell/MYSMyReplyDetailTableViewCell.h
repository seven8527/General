//
//  MYSMyReplyDetailTableViewCell.h
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/15.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSMyReplyDetailTableViewCell : UITableViewCell
{
    // 头像ImageView
    UIImageView *headImageView;
    // 内容Label
    UILabel *contentLabel;
}

- (void)sendValue:(id)dic;

+ (CGFloat)calculateCellHeight:(NSString *)content type:(NSString *)type;

@end
