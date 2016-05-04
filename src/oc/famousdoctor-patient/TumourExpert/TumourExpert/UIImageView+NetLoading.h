//
//  UIImageView+NetLoading.h
//  TumourExpert
//
//  Created by 闫文波 on 14-11-11.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (NetLoading)
- (void)accordingToNetLoadImagewithUrlstr:(NSString *)urlStr and:(NSString *)placeholderImageName;
@end
