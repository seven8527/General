//
//  MYSUpdatePatientIconModel.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-10.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@interface MYSUpdatePatientIconModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *imageUrl; // 图像地址
@property (nonatomic, copy) NSString<Optional> *thumbnailUrl; // 缩略图地址
@property (nonatomic, copy) NSString<Optional> *state; // 患者头像
@end
