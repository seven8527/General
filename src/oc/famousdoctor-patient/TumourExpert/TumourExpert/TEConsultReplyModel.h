//
//  TEConsultReplyModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-6.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

// 专家回复
@interface TEConsultReplyModel : JSONModel
@property (nonatomic, strong) NSString *question; // 问题
@property (nonatomic, strong) NSString *answer; // 回答
@property (nonatomic, strong) NSString *firstQuestion; // 追问一
@property (nonatomic, strong) NSString *firstAnswer; // 回答一
@property (nonatomic, strong) NSString *secondQuestion; // 追问二
@property (nonatomic, strong) NSString *secondAnswer; // 回答二
@property (nonatomic, strong) NSString *thirdQuestion; // 追问三
@property (nonatomic, strong) NSString *thirdAnswer; // 回答三
@property (nonatomic, strong) NSString *dataId; // 资料id
@property (nonatomic, strong) NSString *dataName; // 资料名
@property (nonatomic, assign) int dataState; // 资料状态
@property (nonatomic, assign) int consultState; // 咨询状态
@end
