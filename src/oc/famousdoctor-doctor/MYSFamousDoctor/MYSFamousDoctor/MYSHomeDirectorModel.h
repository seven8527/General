//
//  MYSHomeDirectorModel.h
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/16.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@interface MYSHomeDirectorModel : JSONModel

@property (nonatomic, strong) NSString *doctor_name; //医生姓名
@property (nonatomic, strong) NSString *doctor_type; // 医生类型 0名医汇 1主任医师团
@property (nonatomic, strong) NSString *hdid;
@property (nonatomic, strong) NSString *hid;
@property (nonatomic, strong) NSString *myanswer; //我回答的问题总数(医生类型为主任医师团时显示)
@property (nonatomic, strong) NSString *pic; //医生头像
@property (nonatomic, strong) NSString *pnid;
@property (nonatomic, strong) NSString *question; //待回答问题总数(医生类型为主任医师团时显示)
@property (nonatomic, strong) NSString *title;  //医院名称
@property (nonatomic, strong) NSString *uid; //医生id

@end
