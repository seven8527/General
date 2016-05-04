//
//  TEHome.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-7.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "TEExpertModel.h"
#import "TEHomeFocusPictureModel.h"
#import "TEHomeDepartmentModel.h"
#import "TEHomeHealthInfoModel.h"
#import "TEHomeExpertColumnModel.h"

@interface TEHome : JSONModel
@property (nonatomic, strong) NSArray<TEHomeFocusPictureModel> *focusPictures; // 焦点图组
@property (nonatomic, strong) NSArray<TEHomeDepartmentModel> *departments; // 科室
@property (nonatomic, strong) NSArray<TEExpertModel> *experts; // 专家
@property (nonatomic, strong) NSArray<TEHomeHealthInfoModel> *healthInfos; // 健康资讯
@property (nonatomic, strong) NSArray<TEHomeExpertColumnModel> *expertColumns; // 专家专栏
@end
