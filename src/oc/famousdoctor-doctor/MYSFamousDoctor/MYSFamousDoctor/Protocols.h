//
//  Protocols.h
//  MYSFamousDoctor
//
//  Created by yanwb on 15/4/8.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#ifndef MYSFamousDoctor_Protocols_h
#define MYSFamousDoctor_Protocols_h


#endif

#import "MYSLoginViewController.h"


// 登录
@protocol MYSLoginViewControllerProtocol <NSObject>
@property (nonatomic, strong) Class source; // 来源
@property (nonatomic, assign) SEL aSelector; // 方法
@property (nonatomic, strong) id instance; // 实例
@property (nonatomic, assign) BOOL isHiddenRegisterButton; // 是否隐藏注册按钮

//@property (nonatomic, weak) id <MYSLoginViewControllerDelegate> delegate;
@end