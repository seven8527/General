//
//  DialogueMemberEntity.h
//  Express
//
//  Created by owen on 15/11/6.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "JSONModel.h"


@protocol DialogueMemberEntity @end

@interface DialogueMemberEntity : JSONModel

//id INTEGER
//groupId VARCHAR
//avatar VARCHAR,
//joinOrder INTEGER
//nickName VARCHAR
//userName VARCHAR
//groupid_uid VARCHAR


@property (nonatomic, strong) NSNumber<Optional> *Id;
@property (nonatomic, strong) NSString<Optional> *groupId;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSNumber *joinOrder;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString<Optional> *inGroupNick;
@property (nonatomic, strong) NSString<Optional> *groupid_uid;


@end
