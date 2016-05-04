//
//  MYSFreeConsult.h
//  MYSPatient
//
//  Created by 吴玉龙 on 15-3-24.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

// 列表
#import "JSONModel.h"
#import "MYSBriefAskModel.h"
#import "MYSPlusAskModel.h"

@protocol MYSFreeConsult @end

@interface MYSFreeConsult : JSONModel
@property (nonatomic, strong) MYSBriefAskModel<Optional> *briefAskModel;
@property (nonatomic, strong) NSArray<MYSPlusAskModel> *plusAskArray;
@end
