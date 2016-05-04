//
//  TEHealthArchiveDetail.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-13.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "TEHealthArchiveUserInfoModel.h"
#import "TEHealthArchiveDataInfoModel.h"

@interface TEHealthArchiveDetail : JSONModel
@property (nonatomic, strong) TEHealthArchiveUserInfoModel *userInfo;
@property (nonatomic, strong) NSMutableArray<TEHealthArchiveDataInfoModel> *datas;
@end
