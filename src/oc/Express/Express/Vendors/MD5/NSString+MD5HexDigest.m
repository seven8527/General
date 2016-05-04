//
//  NSString+MD5HexDigest.m
//  Express
//
//  Created by owen on 15/11/4.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "NSString+MD5HexDigest.h"

@implementation NSString(md5)
-(NSString *)md5HexDigest {
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    
    return [[hash lowercaseString] uppercaseString];
}
@end
