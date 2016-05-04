//
//  TECloseRemindModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-7-21.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

// 关闭提醒
@interface TECloseRemindModel : JSONModel
@property (nonatomic, strong) NSString *state; // 服务器返回的状态码
@end
