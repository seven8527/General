//
//  DialogueListEntity.h
//  Express
//
//  Created by owen on 15/11/6.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "JSONModel.h"
#import "DialogueMemberEntity.h"

@protocol DialogueListEntity @end


@interface DialogueListEntity : JSONModel

//Id INTEGER PRIMARY KEY  NOT NULL ,
//createTime VARCHAR,
//groupId VARCHAR UNIQUE ,
//groupMemberCount INTEGER,
//groupOwer VARCHAR
//groupName VARCHAR,
//groupType INTEGER NOT NULL ,
//isShowMember BOOL,
//showMemberSetTime VARCHAR,
//isShowTop BOOL,
//showTopSetTime VARCHAR,
//isMsgNotification BOOL,
//lastMessage VARCHAR,
//lastMessageTime VARCHAR
//hasNewMessage BOOL
//messageCount INTEGER
//NewmessageCount INTEGER

@property (nonatomic, strong) NSNumber<Optional>*  Id;
@property (nonatomic, strong) NSString<Optional>  *createTime;
@property (nonatomic, strong) NSString<Optional>  *groupId;
@property (nonatomic, strong) NSNumber  *groupMemberCount;
@property (nonatomic, strong) NSString<Optional>    *groupOwer;
@property (nonatomic, strong) NSString  *groupName;
@property (nonatomic, strong) NSNumber<Optional>   *groupType; // 0为group 1 单人对话
@property (nonatomic, strong) NSNumber<Optional>   *isShowMember;
@property (nonatomic, strong) NSString<Optional>   *showMemberSetTime;
@property (nonatomic, strong) NSNumber<Optional>   *isShowTop;
@property (nonatomic, strong) NSString<Optional>   *showTopSetTime;
@property (nonatomic, strong) NSNumber<Optional>   *isMsgNotification;
@property (nonatomic, strong) NSString<Optional>   *lastMessage;
@property (nonatomic, strong) NSString<Optional>   *lastMessageTime;
@property (nonatomic, strong) NSNumber<Optional>   *hasNewMessage;
@property (nonatomic, strong) NSNumber<Optional>   *messageCount;
@property (nonatomic, strong) NSNumber<Optional>   *NewmessageCount;
@property (nonatomic, strong) NSMutableArray<DialogueMemberEntity> *groupMemberList;

@end
