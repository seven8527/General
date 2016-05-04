//
//  MYSHotOneSearchCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-11.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSHotOneSearchCell.h"



@implementation MYSHotOneSearchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *hotNameLabel = [[UILabel alloc] init];
        self.hotNameLable = hotNameLabel;
        hotNameLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
        [self.contentView addSubview:hotNameLabel];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.height - 20, 2)];
        self.lineImageView = lineImageView;
        lineImageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:lineImageView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    self.hotNameLable.frame = self.bounds;
}

@end
