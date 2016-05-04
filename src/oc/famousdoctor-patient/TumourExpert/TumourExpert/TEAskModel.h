//
//  TEAskModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-10.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol TEAskModel@end

// 网络咨询、电话咨询
@interface TEAskModel : JSONModel
@property (nonatomic, strong) NSString *expertId; // 专家ID
@property (nonatomic, strong) NSString *expertName; // 专家姓名
@property (nonatomic, strong) NSString *expertIcon; // 专家头像
@property (nonatomic, strong) NSString *expertTitle; // 专家职称
@property (nonatomic, strong) NSString *department; // 所在科室
@property (nonatomic, strong) NSString *hospitalId; // 医院ID
@property (nonatomic, strong) NSString *hospitalName; // 医院名称
@property (nonatomic, strong) NSString *price; // 价格
@property (nonatomic, strong) NSString *productId; // 产品ID
@end
