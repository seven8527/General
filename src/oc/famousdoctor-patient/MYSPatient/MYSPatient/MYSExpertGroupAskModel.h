//
//  MYSExpertGroupAskModel.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-10.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol MYSExpertGroupAskModel@end

// 网络 电话 面对面咨询
@interface MYSExpertGroupAskModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *expertId; // 专家ID
@property (nonatomic, copy) NSString<Optional> *expertName; // 专家姓名
@property (nonatomic, copy) NSString<Optional> *expertIcon; // 专家头像
@property (nonatomic, copy) NSString<Optional> *expertTitle; // 专家职称
@property (nonatomic, copy) NSString<Optional> *department; // 所在科室
@property (nonatomic, copy) NSString<Optional> *hospitalId; // 医院ID
@property (nonatomic, copy) NSString<Optional> *hospitalName; // 医院名称
@property (nonatomic, copy) NSString<Optional> *price; // 价格
@property (nonatomic, copy) NSString<Optional> *productId; // 产品ID
@end
