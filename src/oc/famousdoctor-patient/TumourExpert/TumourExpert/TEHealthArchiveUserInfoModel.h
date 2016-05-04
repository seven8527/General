//
//  TEHealthArchiveUserInfoModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-13.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol TEHealthArchiveUserInfoModel @end

@interface TEHealthArchiveUserInfoModel : JSONModel
@property (nonatomic, strong) NSString <Optional>*archiveNumber;
@property (nonatomic, strong) NSString <Optional>*idCard;
@property (nonatomic, strong) NSString <Optional>*patientId;
@property (nonatomic, strong) NSString <Optional>*patientName;
@end
