//
//  MYSRegisterPicTableViewCell.m
//  MYSFamousDoctor
//
//  Created by yanwb on 15/4/9.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSRegisterPicTableViewCell.h"
#import "UIColor+Hex.h"


@implementation MYSRegisterPicTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 15, 15)];
        tipImageView.image = [UIImage imageNamed:@"sign_in_data_check"];
        [self.contentView addSubview:tipImageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tipImageView.frame) + 5, 15, kScreen_Width - CGRectGetMaxX(tipImageView.frame) - 5, 15)];
        titleLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
        titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLable = titleLabel;
        [self.contentView addSubview:titleLabel];
        
        
        UITextView *tipTitleView = [[UITextView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(tipImageView.frame), kScreen_Width - 30, 35)];
        tipTitleView.textColor = [UIColor colorFromHexRGB:K747474Color];
        tipTitleView.font = [UIFont systemFontOfSize:12];
        tipTitleView.selectable = NO;
        self.tipTitleView  = tipTitleView;
        [self.contentView addSubview:tipTitleView];
        
        UIButton *picButton = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(tipTitleView.frame) + 15, 60, 60)];
        self.picButton = picButton;
        [picButton addTarget:self action:@selector(clickPicButton) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:picButton];
        
        UIImageView *picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(tipTitleView.frame) + 15, 60, 60)];
        picImageView.image = [UIImage imageNamed:@"sign_in_data_uploading"];
        self.picImageView = picImageView;
        [self.contentView addSubview:picImageView];
    }
    return self;
}

- (void)clickPicButton
{
    if ([self.delegate respondsToSelector:@selector(registerPicTabelViewCellDidClickPicButtonWithIndex:)])
    {
        [self.delegate registerPicTabelViewCellDidClickPicButtonWithIndex:self.index];
    }
}

@end
