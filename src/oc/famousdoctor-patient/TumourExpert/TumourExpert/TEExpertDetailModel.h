//
//  TEExpertDetailModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-8.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol TEExpertDetailModel @end

// 专家详情
@interface TEExpertDetailModel : JSONModel
@property (nonatomic, strong) NSString *expertId; // 专家ID
@property (nonatomic, strong) NSString *expertName; // 专家姓名
@property (nonatomic, strong) NSString *expertIcon; // 专家头像
@property (nonatomic, strong) NSString *expertTitle; // 专家职称
@property (nonatomic, strong) NSString<Optional> *expertForte; // 专家擅长
@property (nonatomic, strong) NSString<Optional> *expertIntroduce; // 专家介绍
@property (nonatomic, strong) NSString<Optional> *department; // 所在科室
@property (nonatomic, strong) NSString<Optional> *hospitalId; // 医院ID
@property (nonatomic, strong) NSString<Optional> *hospitalName; // 医院名称
@end
