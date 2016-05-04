//
//  NSString+URLEncoded.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-8-14.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "NSString+URLEncoded.h"

@implementation NSString (URLEncoded)

/**
 *  URL 编码
 *
 *  @return 编码后的字符串
 */
- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self,
                                                                           NULL,
																		   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8));
	return result;

}

@end
