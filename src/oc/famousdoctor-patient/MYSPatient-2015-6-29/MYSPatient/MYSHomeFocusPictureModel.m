//
//  MYSHomeFocusPictureModel.m
//  MYSPatient
//
//  Created by 闫文波 on 15-3-19.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSHomeFocusPictureModel.h"

@implementation MYSHomeFocusPictureModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"image_path": @"picUrl",
                                                       @"url": @"contentUrl"
                                                       }];
}

@end
