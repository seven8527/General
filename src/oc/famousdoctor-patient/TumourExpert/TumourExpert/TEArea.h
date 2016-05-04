//
//  TEArea.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-14.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "TEAreaModel.h"

@interface TEArea : JSONModel
@property (nonatomic, strong) NSArray<TEAreaModel> *areas; // 地区
@end
