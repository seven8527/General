//
//  MYSMyColumnDetailTableViewCell.h
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/20.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSMyColumnDetailTableViewCell : UITableViewCell
{
    UIImageView *xuXianImage;
}

- (void)sendValue:(id)dic;
+ (CGFloat)calculateCellHeight:(NSString *)title content:(NSString *)content;

@end
