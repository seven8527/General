//
//  TEResultModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-9.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

// 服务器返回的结果
@interface TEResultModel : JSONModel
@property (nonatomic, strong) NSString *state; // 服务器返回的状态码
@end
