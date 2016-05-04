//
//  NSString+URLEncoded.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-8-14.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoded)

/**
 *  URL 编码
 *
 *  @return 编码后的字符串
 */
- (NSString *)URLEncodedString;

@end
