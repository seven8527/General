//
//  TEConsultReply.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-6.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@interface TEConsultReply : NSObject

@property (nonatomic, strong) NSString *prompt; // 提示问题
@property (nonatomic, strong) NSString *question; // 问题
@property (nonatomic, strong) NSString *answer; // 回答
@end
