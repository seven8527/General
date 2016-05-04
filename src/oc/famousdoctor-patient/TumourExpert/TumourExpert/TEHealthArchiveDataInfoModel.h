//
//  TEHealthArchiveDataInfoModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-13.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol TEHealthArchiveDataInfoModel @end

@interface TEHealthArchiveDataInfoModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *patientId;
@property (nonatomic, strong) NSString<Optional> *patientDataId;
@property (nonatomic, strong) NSString<Optional> *patientDataName;
@property (nonatomic, strong) NSString<Optional> *selcted;
@end
