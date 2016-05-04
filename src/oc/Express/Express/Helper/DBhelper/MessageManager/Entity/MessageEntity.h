//
//  MessageEntity.h
//  Express
//
//  Created by owen on 15/11/9.
//  Copyright © 2015年 owen. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "DialogueListEntity.h"

@interface MessageEntity : JSONModel

//fromUser:发送者账号,
//nickName:发送者昵称,
//avatar:发送者头像,
//content:文字消息内容,
//voice:语音文件名称,
//time:消息发送时间,
//msgType:消息类型,
//mark:好友备注名称,
//isFromWatch:消息来源,
//url:链接地址,
//image:图片文件名称,
//brief:链接的文章摘要,
//title:链接的标题,
//video:视频文件名称,
//v_width:视频文件宽,
//v_height:视频文件高
//delay:图片文件名称
@property (nonatomic, strong) NSNumber<Optional> *Id;  //id
@property (nonatomic, strong) NSString<Optional> *messageId;//消息id (fromUser_time)
@property (nonatomic, strong) NSString<Optional> *toUserName;  //组id
@property (nonatomic, strong) NSString<Optional> *fromUserName;   //用户id

@property (nonatomic, strong) NSString *fromUser;
@property (nonatomic, strong) NSString<Optional> *nickName;
@property (nonatomic, strong) NSString<Optional> *avatar;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString<Optional> *voice;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *msgType;
@property (nonatomic, strong) NSString<Optional> *mark;
@property (nonatomic, strong) NSNumber<Optional> *isFromWatch;
@property (nonatomic, strong) NSString<Optional> *url;
@property (nonatomic, strong) NSString<Optional> *image;
@property (nonatomic, strong) NSString<Optional> *brief;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *video;
@property (nonatomic, strong) NSNumber<Optional> *v_width;
@property (nonatomic, strong) NSNumber<Optional> *v_height;
@property (nonatomic, strong) NSString<Optional> *delay;
@property (nonatomic, strong) NSNumber<Optional> *isGroup;
@property (nonatomic, strong) NSNumber<Optional> *state;
@property (nonatomic, strong) NSNumber<Optional> *rectime;
@property (nonatomic, strong) NSNumber<Optional> *isshowtime; //1显示

@property (nonatomic, strong) DialogueListEntity<Optional> *group_info;



@end
