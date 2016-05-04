//
//  TEAssistant.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-10.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "TEAssistantModel.h"

@interface TEAssistant : JSONModel
@property (nonatomic, assign) int total;
@property (nonatomic, strong) NSArray<TEAssistantModel> *assistants;
@end
