//
//  TEHomeFocusPictureModel.m
//  TumourExpert
//
//  Created by 闫文波 on 14-10-13.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEHomeFocusPictureModel.h"

@implementation TEHomeFocusPictureModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"data_title": @"focusPicTitle",
                                                       @"data_bath": @"focusPicUrl",
                                                       @"data_id": @"healthInfoID"
                                                       }];
}
@end
