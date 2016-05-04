//
//  TEHealthArchivesBasicDataModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-9-28.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

/**
 *  健康档案基本信息
 */
@interface TEHealthArchivesBasicDataModel : JSONModel
@property (nonatomic, strong) NSString *dataName;
@property (nonatomic, strong) NSString *hospital;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *keshi;
@property (nonatomic, strong) NSString *zhenduan;
@end
