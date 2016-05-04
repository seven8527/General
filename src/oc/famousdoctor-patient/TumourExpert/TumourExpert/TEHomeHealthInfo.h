//
//  TEHomeHealthInfo.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "TEHomeHealthInfoModel.h"

@interface TEHomeHealthInfo : JSONModel
@property (nonatomic, assign) int count;
@property (nonatomic, strong) NSString<Optional> *state;
@property (nonatomic, strong) NSArray<TEHomeHealthInfoModel> *healthInfos;
@end
