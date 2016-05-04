//
//  NSString+URLEncoded.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-10.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
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
