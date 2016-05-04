//
//  TEHealthInfoDetailModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@interface TEHealthInfoDetailModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *healthInfoTitle; // 文章标题
@property (nonatomic, strong) NSString<Optional> *healthInfoContent; // 文章内容
@end
