//
//  TEHomeExpertColumnModel.h
//  TumourExpert
//
//  Created by 闫文波 on 14-10-13.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol TEHomeExpertColumnModel @end

@interface TEHomeExpertColumnModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *expertConlumnId; // 专家专栏ID
@property (nonatomic, strong) NSString<Optional> *expertConlumnName; // 专家专栏名称

@end
