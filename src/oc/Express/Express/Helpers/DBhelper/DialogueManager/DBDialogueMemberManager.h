//
//  DBDialogueMemberManager.h
//  Express
//
//  Created by owen on 15/11/6.
//  Copyright © 2015年 owen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DialogueMemberEntity.h"

typedef void (^InsertResultBlock)           (Boolean result);                                   //插入结果block
typedef void (^QueryMembersResultBlock)      (DialogueMemberEntity * result);                    //通过查询结果block
typedef void (^QueryGroupResultBlock)       (NSMutableArray *result);   //通过查询结果block
typedef void (^DelResultBlock)              (Boolean result);                                   //删除结果block

@interface DBDialogueMemberManager : NSObject

+(void) insert:(DialogueMemberEntity *) dialogueMember   FMDatabase:(FMDatabase *)db WithGroupId:(NSString *) groupId  InsertResult:(InsertResultBlock)result;

+(void) insertArray:(NSMutableArray<DialogueMemberEntity> *) dialogueMemberArray  FMDatabase:(FMDatabase *)db  WithGroupId:(NSString *) groupId  InsertResult:(InsertResultBlock)result;

+(void) queryByID:(NSString *)Id  FMDatabase:(FMDatabase *)db WithGroupId:(NSString *) groupId QueryResult:(QueryMembersResultBlock)result;

+(void) queryByGroupId:(NSString *)groupId FMDatabase:(FMDatabase *)db  QueryGroupResult:(QueryGroupResultBlock)result;

+(void) deleteByID:(NSString *)Id FMDatabase:(FMDatabase *)db  WithGroupId:(NSString *) groupId DelResult:(DelResultBlock)result;

+(void) deleteByNickName:(NSString *)nickName  FMDatabase:(FMDatabase *)db WithGroupId:(NSString *) groupId DelResult:(DelResultBlock)result;

+(void) deleteByGroupId:(NSString *) groupId  FMDatabase:(FMDatabase *)db  DelResult:(DelResultBlock)result;

@end
