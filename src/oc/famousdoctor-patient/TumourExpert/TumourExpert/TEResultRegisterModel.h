//
//  TEResultRegisterModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-7-8.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

// 注册返回的结果
@interface TEResultRegisterModel : JSONModel
@property (nonatomic, strong) NSString *state; // 服务器返回的状态码
@property (nonatomic, strong) NSString<Optional> *uid;  // 用户Id
@property (nonatomic, strong) NSString<Optional> *cookie; // cookie
@end
