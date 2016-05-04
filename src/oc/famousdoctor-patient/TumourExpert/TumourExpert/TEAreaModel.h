//
//  TEAreaModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-14.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol TEAreaModel @end

@interface TEAreaModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *hid; // Id
@property (nonatomic, strong) NSString<Optional> *province; // 省
@property (nonatomic, strong) NSString<Optional> *city; // 市
@property (nonatomic, strong) NSString<Optional> *provinceId; // 省
@property (nonatomic, strong) NSString<Optional> *provinceName; // 省
@property (nonatomic, strong) NSString<Optional> *englishName;
@end
