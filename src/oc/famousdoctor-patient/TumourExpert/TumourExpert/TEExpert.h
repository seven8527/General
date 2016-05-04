//
//  TEExpert.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-7.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "TEExpertModel.h"

@interface TEExpert : JSONModel
@property (nonatomic, assign) int total;
@property (nonatomic, strong) NSArray<TEExpertModel> *experts; // 专家
@end
