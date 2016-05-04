//
//  TEHomePicCollectionViewCell.m
//  TumourExpert
//
//  Created by 闫文波 on 14-9-29.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEHomePicCollectionViewCell.h"
#import <AFNetworking/AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import "TEUITools.h"
#import "UIImageView+NetLoading.h"


#define homePicCollectionHeight 112
@interface TEHomePicCollectionViewCell ()

@property (nonatomic, weak) UIImageView *imageView;

@end
@implementation TEHomePicCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 0, 320, homePicCollectionHeight);
        self.imageView = imageView;
        [self addSubview:imageView];
    }
    return self;
}


- (void)setPicURL:(NSString *)picURL
{
    _picURL = picURL;
     [self.imageView accordingToNetLoadImagewithUrlstr:picURL and:@"logo.png"];
}

@end
