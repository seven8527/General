//
//  TEHealthArchivesUserModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-9-28.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

/**
 *  健康档案用户信息
 */
@interface TEHealthArchivesUserModel : JSONModel
@property (nonatomic, strong) NSString <Optional>*name;
@property (nonatomic, strong) NSString <Optional>*idCard;
@property (nonatomic, strong) NSString <Optional>*gender;
@property (nonatomic, strong) NSString <Optional>*birthday;
@property (nonatomic, strong) NSString <Optional>*height;
@property (nonatomic, strong) NSString <Optional>*weight;
@end
