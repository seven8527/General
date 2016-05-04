//
//  TEResultDeleteImageModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-7-24.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

// 删除图片返回的结果
@interface TEResultDeleteImageModel : JSONModel
@property (nonatomic, strong) NSString *state; // 服务器返回的状态码
@end
