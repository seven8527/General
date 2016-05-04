//
//  NSString+EMAdditions.h
//  EMString
//
//  Created by Tanguy Aladenise on 2014-11-27.
//  Copyright (c) 2014 Tanguy Aladenise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMMarkupProperty.h"
#import "EMStringStylingConfiguration.h"


@interface NSString (EMAdditions)

/**
 *  Return the styled attributedString according to markup contained in the string.
 */
@property (readonly, copy) NSAttributedString *attributedString;


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com