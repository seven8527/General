//
//  DBDialogueListManager.h
//  Express
//
//  Created by owen on 15/11/6.
//  Copyright © 2015年 owen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DialogueListEntity.h"
typedef void (^InsertResultBlock)               (Boolean result);                                           //插入单个结果block
typedef void (^InsertArrayResultBlock)          (Boolean result);                                           //批量插入结果block
typedef void (^QueryResultBlock)               (DialogueListEntity * result);                               //通过查询结果block
typedef void (^QueryBySelectResultBlock)        (NSMutableArray * result);           //根据条件查询结果block
typedef void (^DelResultBlock)                  (Boolean result);                                           //单个删除结果block
typedef void (^UpdateResultBlock)               (Boolean result);                                           //更新单个结果block

typedef enum {
    p2p  = 0 ,      //个人会话
    Group  //群组
   
    }GroupType;

typedef enum {
    all = 0 , //所有
    newMsg ,  //新消息
}SelectType;

@interface DBDialogueListManager : NSObject

+(void) queryByID:(NSString *)groupId FMDatabase:(FMDatabase *)db  QueryResult:(QueryResultBlock)result;

+(void) insert:(DialogueListEntity *) dialogueList FMDatabase:(FMDatabase *)db  GroupType:(GroupType)groupType  InsertResult:(InsertResultBlock)result;

+(void) insertArray:(NSMutableArray *) dialogueListArray FMDatabase:(FMDatabase *)db  GroupType:(GroupType)groupType  InsertArrayResult:(InsertArrayResultBlock)result;

+(void) queryBySelect:(SelectType)selectType FMDatabase:(FMDatabase *)db   QueryBySelectResult:(QueryBySelectResultBlock)result;

+(void) updateByID:(NSString *)groupId FMDatabase:(FMDatabase *)db DialogueListEntity:(DialogueListEntity *) dialogueList UpdateResult:(UpdateResultBlock)result;


+(void) deleteByGroupId:(NSString *)groupId  FMDatabase:(FMDatabase *)db DelResult:(DelResultBlock)result;


@end
