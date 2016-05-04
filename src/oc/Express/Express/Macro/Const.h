//
//  Const.h
//  Express
//
//  Created by Owen on 15/11/3.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#ifndef BigNews_Const_h
#define BigNews_Const_h
// 设置颜色值
#define KBACKGROUND 0xEDEDED //背景颜色
#define KEDEDEDColor 0xEDEDED //背景颜色
#define KC2C2C2Color 0xc2c2c2
#define K69AE42Color 0x69ae42
#define K9D76AAColor 0x9d76aa
#define K398CCCColor 0x398ccc
#define KEF8004Color 0xef8004
#define K333333Color 0x333333
#define K9E9E9EColor 0x9e9e9e
#define KF6F6F6Color 0xf6f6f6 // 导航背景颜色
#define k00947DColor 0x00947d // tabbar颜色
#define KEB3C00Color 0xeb3c00 // 红色按钮颜色
#define KFFFFFFColor 0xffffff
#define K525252Color 0x525252
#define K00A693Color 0x00a693 // 默认绿色
#define K00907FColor 0x00907f // 按钮高亮默认颜色
#define K747474Color 0x747474
#define K525252Color 0x525252
#define K00907FColor 0x00907f
#define K69AF41Color 0x69af41
#define KD1D1D1Color 0xd1d1d1
#define K989898Color 0x989898
#define K00A48FColor 0x00a48f
#define KFAFAFAColor 0xfafafa
#define K484848Color 0x484848
#define KB8B8B8Color 0xb8b8b8
#define K000000Color 0x000000
#define K61A3D6Color 0x61a3d6
#define K68A8DBColor 0x68a8d8
#define KD9FAF6Color 0xd9faf6
#define KB3B3B3Color 0xb3b3b3
#define K575757Color 0x575757
#define KABABABColor 0xababab
#define KC6C6C6Color 0xc6c6c6
#define K8F8F8FColor 0x8f8f8f
#define KC2C1C0Color 0xc2c1c0

#define K00C3D5Color 0x00c3d5
#define KFFFCD1Color 0xfffcd1


#pragma mark ---KColor ---

#define K7F7F7FColor 0x7f7f7f
#define KADADADColor 0xadadad
#define KF8F8F8Color 0xf8f8f8
#define KFFE1D0Color 0xffe1d0
#define KEBBBAAColor 0xebbbaa
#define KEEEEEEColor 0xeeeeee
#define KC8C8C8Color 0xc8c8c8
#define K595555Color 0x595555
#define KFE784BColor 0xfe784b
#define KE6E6E6Color 0xe6e6e6
#define KF5895CColor 0xf5895c
#define KE6554aColor 0xe6554a

#pragma mark --- ROOT_PATH ---
//#define  KROOT_PATH @"http://www.yugong-tech.com/DigitalFrame/"

//#define  KROOT_GROUP_PATH               @"http://img.tomoon.cn/DigitalFrame/"

#define  KROOT_PATH                     @"http://biaoda.tomoon.cn/DigitalFrame/"
#define  KLOGO_ROOT_PATH                @"http://img.biaoda.tomoon.cn/down_avatar.php?avatar=" //图片请求根路径
#define  KVOICE_DOWNLOAD_ROOT_PATH      @"http://img.tomoon.cn/download_voice_wt?voice_file="
#define  KIMAGE_DOWNLOAD_ROOT_PATH      @"http://img.tomoon.cn/download_voice_wt?image_file="
#define  KVIDEO_DOWNLOAD_ROOT_PATH      @"http://img.tomoon.cn/share/download/video.gif?username="
#define  KVIDEOIMAGE_DOWNLOAD_ROOT_PATH @"http://img.tomoon.cn/share/download/video_snapshot.png?username="

#define  KFILE_ROOT_PATH                @"http://img.tomoon.cn/"
#define  KVOICE_UPLOAD_PATH             @"upload_voice_wt"
#define  KIMAGE_UPLOAD_PATH             @"upload_voice_wt"
#define  KVIDEO_UPLOAD_PATH             @"share/upload/video"

#pragma mark --- DEVICE_TYPE ---
#define  KDEVICE_TYPE_MP @"MP"
#define  KDEVICE_TYPE_WT @"WT"

#pragma mark --- ACTION ---
#define  KACTION_LOGIIN                 @"login"                    //登陆
#define  KACTION_FRIENDS_LIST           @"obtainMyFocusList"        //获取好友列表
#define  KACTION_GROUP_LIST             @"obtainMyGroupList"        //获取群组列表
#define  KACTION_GETMESSAGE             @"getMessage"               //获取消息
#define  KACTION_SENDMESSAGE            @"sendMessage"              //发送消息
#define  KACTION_GETUSERINFO            @"getUserProfile"           //获取用户信息
#define  KACTION_CREATEGROUP            @"createGroup"              //创建群组
#define  KACTION_ADDFRIENDTOGROUP       @"addFriendGroup"           //将好友拉入群
#define  KACTION_REMOVEMEMBERTOGROUP    @"removeGroupMem"           //将好友移除群
#define  KACTION_QUITGROUP              @"quitGroup"                //退出群
#define  KACTION_DESTROYGROUP           @"destroyGroup"             //解散群

#define  KACTION_CONFIGGROUPNAME        @"configGroup"              //设置群名称
#define  KACTION_SETMEMBERNICKNAME      @"setGroupNickname"         //设置群成员昵称


#pragma mark --- NSNotificationCenter_message_type ---

#define  KNOTIFI_MESSAGE_UPDATE_DIALOGUE_LIST   @"UPDATE_DIALOGUE_LIST"    //更新对话列表
#define  KNOTIFI_MESSAGE_UPDATE_DIALOGUE_DETAIL @"UPDATE_DIALOGUE_DETAIL"  //更新消息


#endif
