//
//  MYSMyColumuTableViewCell.h
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/9.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSMyColumuTableViewCell : UITableViewCell

+ (CGFloat)getCellHeight;

- (void)sendTitle:(NSString *)title time:(NSString *)time count:(NSString *)count;

@end
