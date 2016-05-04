//
//  MYSNetDetailDocTableViewCell.h
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/19.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSNetDetailDocTableViewCell : UITableViewCell

- (void)sendValue:(id)dic;

+ (CGFloat)calculateCellHeight:(NSString *)content;

@end
