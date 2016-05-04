//
//  TEHomeHealthInfoModel.h
//  TumourExpert
//
//  Created by 闫文波 on 14-10-13.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol TEHomeHealthInfoModel @end

@interface TEHomeHealthInfoModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *healthInfoId; // 健康资讯ID
@property (nonatomic, strong) NSString<Optional> *healthName; // 健康资讯名称

@end
