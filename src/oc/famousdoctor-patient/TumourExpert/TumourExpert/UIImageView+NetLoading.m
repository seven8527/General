//
//  UIImageView+NetLoading.m
//  TumourExpert
//
//  Created by 闫文波 on 14-11-11.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "UIImageView+NetLoading.h"
#import "TEUITools.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation UIImageView (NetLoading)

- (void)accordingToNetLoadImagewithUrlstr:(NSString *)urlStr and:(NSString *)placeholderImageName
{
    if ([TEUITools enableLoadPic]) {
        if ([urlStr rangeOfString:@"_150X150"].location != NSNotFound) {
            [self sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:placeholderImageName]];
        } else {
            [self compress_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:placeholderImageName]];
        }
    } else {
        [self sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:placeholderImageName]];
    }

}
@end
