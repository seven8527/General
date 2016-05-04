//
//  TEHomeExpertColumn.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "TEHomeExpertColumnModel.h"

@interface TEHomeExpertColumn : JSONModel
@property (nonatomic, assign) int total;
@property (nonatomic, strong) NSArray<TEHomeExpertColumnModel> *articles; // 文章
@end
