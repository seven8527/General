//
//  MYSSignTool.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-28.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#define platformSignKey @"Za3nt1JuzS4GOTjtuwT3m04gVeq4hO92"

#import "MYSSignTool.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MYSSignTool

+ (NSString *)healthPlatformSignWith:(NSDictionary *)parameters
{
    NSString *sordValued = [[self sortValueWithKeyOf:parameters] componentsJoinedByString:@""];
    
    return [self md5:[NSString stringWithFormat:@"%@%@",sordValued,platformSignKey]];
}


+ (NSMutableArray *)sortValueWithKeyOf:(NSDictionary *)parameters
{
    NSArray *keys = [parameters allKeys];
    
    NSArray *sortKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(NSString *key1, NSString *key2) {
        return [key1 compare:key2];
    }];
    
    NSMutableArray *sortedValues = [NSMutableArray array];
    
    for (NSString * key in sortKeys) {
        [sortedValues addObject:[parameters objectForKey:key]];
    }
    
    return sortedValues;
}


// md5加密
+ (NSString *)md5:(NSString *)aText
{
    const char *cStr = [aText UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    
    return [hash lowercaseString];
}
@end
