//
//  TERemindModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-7-21.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

// 提醒
@interface TERemindModel : JSONModel
@property (nonatomic, assign) int text; // 网络咨询
@property (nonatomic, assign) int phone; // 电话咨询
@property (nonatomic, assign) int refer; // 线下咨询
@end
