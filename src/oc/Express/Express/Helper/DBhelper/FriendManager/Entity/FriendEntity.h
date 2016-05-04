//
//  FriendEntity.h
//  Express
//
//  Created by owen on 15/11/4.
//  Copyright © 2015年 owen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendEntity : JSONModel

//ShowPhoneNum = 1;
//WatchStatus = 1;
//avatar = "icon_user01.jpg";
//focusType = 3;
//focusUserName = 10000000002;
//gender = F;
//location = "";
//mark = "";
//nickName = "\U571f\U66fc\U5ba2\U670d\U5c0f\U5947";
//phoneType = 0;
//registerTime = "2014-10-24";
//signature = "";
//time = "2015-10-31 06:54:00";
//verifyMsg = "";



@property (nonatomic, strong) NSNumber<Optional>   *Id ;
@property (nonatomic, assign) int  ShowPhoneNum;//是否显示电话号码
@property (nonatomic, assign) int  WatchStatus;//手表状态
@property (nonatomic, strong) NSString *avatar;// 头像
@property (nonatomic, assign) int      focusType;//关注类型
@property (nonatomic, strong) NSString *focusUserName;//好友账号
@property (nonatomic, strong) NSString *gender;//好友性别
@property (nonatomic, strong) NSString *location;//好友位置
@property (nonatomic, strong) NSString *mark;//好友备注名称
@property (nonatomic, strong) NSString *nickName;//好友昵称
@property (nonatomic, assign) int      phoneType;//手机类型
@property (nonatomic, strong) NSString *registerTime;//注册时间
@property (nonatomic, strong) NSString *signature;//好友签名
@property (nonatomic, strong) NSString *time;// 添加好友时间
@property (nonatomic, strong) NSString<Optional> *verifyMsg;//验证消息
@end
