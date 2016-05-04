//
//  MYSResultModel.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-9.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

// 服务器返回的结果
@interface MYSResultModel : JSONModel
@property (nonatomic, strong) NSString *state; // 服务器返回的状态码
@end
