//
//  TEAssistantModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-10.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol TEAssistantModel @end

// 医助
@interface TEAssistantModel : JSONModel
@property (nonatomic, strong) NSString *assistantId; // 医助ID
@property (nonatomic, strong) NSString *assistantName; // 医助姓名
@end
