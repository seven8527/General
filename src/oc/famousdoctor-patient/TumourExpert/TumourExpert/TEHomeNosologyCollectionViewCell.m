//
//  TEHomeNosologyCollectionViewCell.m
//  TumourExpert
//
//  Created by 闫文波 on 14-9-29.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEHomeNosologyCollectionViewCell.h"
#import "UIColor+Hex.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TEUITools.h"
#import "UIImageView+NetLoading.h"

@interface TEHomeNosologyCollectionViewCell ()

@property (nonatomic, weak) UIImageView *nosologyImageView;
@property (nonatomic, weak) UILabel *titleLable;

@end

@implementation TEHomeNosologyCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *nosologyImageView = [[UIImageView alloc] init];
        [nosologyImageView setBackgroundColor: [UIColor whiteColor]];
        nosologyImageView.frame = CGRectMake(25, 5, 55, 55);
        self.nosologyImageView = nosologyImageView;
        [self addSubview:nosologyImageView];
        
        
        UILabel *titleLable = [[UILabel alloc] init];
        titleLable.font = [UIFont systemFontOfSize:17];
        titleLable.textColor = [UIColor colorWithHex:0x6b6b6b];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.frame = CGRectMake(0, 68, 106, 15);
        self.titleLable = titleLable;
        [self addSubview:titleLable];
    }
    return self;
}
- (void)setPicString:(NSString *)picString
{
    _picString = picString;

    [self.nosologyImageView accordingToNetLoadImagewithUrlstr:picString and:@"hone_icon_coming_default"];
}

- (void)setPicSelectUrl:(NSString *)picSelectUrl
{
    _picSelectUrl = picSelectUrl;

  [self.nosologyImageView accordingToNetLoadImagewithUrlstr:picSelectUrl and:@"hone_icon_coming_default"];
}


- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLable.text = title;
}

@end
