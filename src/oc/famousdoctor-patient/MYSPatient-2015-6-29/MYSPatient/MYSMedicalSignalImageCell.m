//
//  MYSMedicalSignalImageCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-20.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSMedicalSignalImageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation MYSMedicalSignalImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 60, 60)];
        self.picImageView = picImageView;
//        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImage:)];
//        [picImageView addGestureRecognizer:tap];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        picImageView.userInteractionEnabled = YES;
        picImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
        [self.contentView addSubview:picImageView];
        
    }
    return self;
}

- (void)setPicurl:(NSString *)picurl
{
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:picurl] placeholderImage:nil];
}

@end
