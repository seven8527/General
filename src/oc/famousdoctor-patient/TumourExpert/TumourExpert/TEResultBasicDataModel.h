//
//  TEResultBasicDataModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-24.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

// 基本资料返回的结果
@interface TEResultBasicDataModel : JSONModel
@property (nonatomic, strong) NSString *state; // 服务器返回的状态码
@property (nonatomic, strong) NSString<Optional> *pmid;  // 资料Id
@property (nonatomic, strong) NSString<Optional> *pmname; // 资料名
@end
