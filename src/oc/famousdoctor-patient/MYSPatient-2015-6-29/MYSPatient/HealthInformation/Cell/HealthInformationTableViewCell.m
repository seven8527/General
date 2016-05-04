//
//  HealthInformationTableViewCell.m
//  MYSPatient
//
//  Created by lyc on 15/5/19.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "HealthInformationTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation HealthInformationTableViewCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)sendValue:(id)dic
{
    // TODO 目前没有图片，发布时请更换解析
    NSString *imageUrl = [dic objectForKey:@"pic"];
    [infoImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"unload_image"]];
    infoTitleLabel.text = [dic objectForKey:@"title"];
    infoTimeLabel.text = [dic objectForKey:@"publish_time"];
    infoCountLabel.text = [dic objectForKey:@"views"];
}

@end
