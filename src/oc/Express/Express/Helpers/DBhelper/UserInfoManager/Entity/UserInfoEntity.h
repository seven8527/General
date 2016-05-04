//
//  UserInfoEntity.h
//  Express
//
//  Created by owen on 15/11/20.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "JSONModel.h"

@interface UserInfoEntity : JSONModel
//Age = "";
//Avatar = "1320190355620151031070213.jpg";
//BackgroundPicture = "picture01.png";
//Email = "";
//Gender = M;
//Hobbies = "";
//Location = "";
//Nickname = "\U7528\U6237446245640";
//RegisterTime = "2015-10-31";
//ShowPhoneNum = 1;
//Signature = "";
//WatchStatus = 0;

@property (nonatomic, strong) NSNumber<Optional> *Id;  //id
@property (nonatomic, strong) NSNumber  *Age; //年龄
@property (nonatomic, strong) NSString  *Avatar; //头像
@property (nonatomic, strong) NSString  *BackgroundPicture; //背景
@property (nonatomic, strong) NSString  *Email;
@property (nonatomic, strong) NSString  *Gender; //M F
@property (nonatomic, strong) NSString  *Hobbies; //爱好
@property (nonatomic, strong) NSString  *Location; //位置
@property (nonatomic, strong) NSString  *Nickname; //昵称
@property (nonatomic, strong) NSString  *RegisterTime; //注册时间
@property (nonatomic, strong) NSNumber  *ShowPhoneNum; //是否显示号码  bool值
@property (nonatomic, strong) NSString  *Signature;
@property (nonatomic, strong) NSNumber  *WatchStatus; //手表状态

@end
