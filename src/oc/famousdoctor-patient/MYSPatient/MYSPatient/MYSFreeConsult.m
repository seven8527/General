//
//  MYSFreeConsult.m
//  MYSPatient
//
//  Created by 吴玉龙 on 15-3-24.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSFreeConsult.h"

@implementation MYSFreeConsult
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"children": @"plusAskArray",
                                                       @"main": @"briefAskModel"
                                                       }];
}

@end
