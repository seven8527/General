//
//  TEResultOrderModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-30.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

// 订单返回的结果
@interface TEResultOrderModel : JSONModel
@property (nonatomic, strong) NSString *state; // 服务器返回的状态码
@property (nonatomic, strong) NSString<Optional> *billno;  // 订单Id
@end
