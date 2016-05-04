//
//  HealthInfomationDetailTableViewCell.h
//  MYSPatient
//
//  Created by lyc on 15/5/21.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthInfomationDetailTableViewCell : UITableViewCell
{
    UIImageView *xuXianImage;
}

- (void)sendValue:(id)dic;
+ (CGFloat)calculateCellHeight:(NSString *)title content:(NSString *)content;

@end
