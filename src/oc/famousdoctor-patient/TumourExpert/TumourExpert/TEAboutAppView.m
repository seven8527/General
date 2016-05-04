//
//  TEAboutAppView.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-7-8.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEAboutAppView.h"
#import "UIColor+Hex.h"
#import "NSString+CalculateTextSize.h"

@interface TEAboutAppView ()
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *versionLabel;
@end

@implementation TEAboutAppView

#pragma mark - Life Cycle

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.logoImageView];
    [self addSubview:self.versionLabel];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Propertys

- (UIImageView *)logoImageView
{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width-94)/2, 20, 94, 84)];
        _logoImageView.image = [UIImage imageNamed:@"logo1.png"];
    }
    
    return _logoImageView;
}

- (UILabel *)versionLabel
{
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.text = [NSString stringWithFormat:@"名医生 V%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        _versionLabel.font = [UIFont boldSystemFontOfSize:14];
        _versionLabel.textColor = [UIColor colorWithHex:0x9e9e9e];
        CGSize versionSize = [_versionLabel.text boundingRectWithSize:CGSizeMake(300, CGFLOAT_MAX) font:[UIFont boldSystemFontOfSize:14]];
        _versionLabel.frame = CGRectMake((kScreen_Width - versionSize.width) / 2, 114, versionSize.width, 21);
    }
    
    return _versionLabel;
}

@end
