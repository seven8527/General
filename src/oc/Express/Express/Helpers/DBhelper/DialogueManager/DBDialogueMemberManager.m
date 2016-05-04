//
//  DBDialogueMemberManager.m
//  Express
//
//  Created by owen on 15/11/6.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "DBDialogueMemberManager.h"
#import "DBHelper.h"
#import "DialogueMemberEntity.h"

@implementation DBDialogueMemberManager

+(void) insert:(DialogueMemberEntity *) dialogueMember  FMDatabase:(FMDatabase *)db  WithGroupId:(NSString *) groupId InsertResult:(InsertResultBlock)result
{
   
        BOOL insertResult = false;
        @try {
            insertResult  = [db executeUpdate:@"REPLACE INTO t_dialogue_member(groupId, avatar, joinOrder, nickName , userName , groupid_uid,inGroupNick) VALUES(?,?,?,?,?,?,?)",
                                 groupId,
                                 dialogueMember.avatar,
                                 dialogueMember.joinOrder,
                                 dialogueMember.nickName,
                                 dialogueMember.userName,
                                 [NSString stringWithFormat:@"%@_%@",groupId,dialogueMember.userName],
                                 dialogueMember.inGroupNick];
                
           if (!insertResult) {
                NSLog(@"插入失败");
            }
        }
        @catch (NSException *exception) {
            NSLog(@"数据库操作异常");

        }
        @finally {
            if(result)
            {
                result(insertResult);
            }
        }
 
}

+(void) insertArray:(NSMutableArray * ) dialogueMemberArray FMDatabase:(FMDatabase *)db WithGroupId:(NSString *) groupId  InsertResult:(InsertResultBlock)result{
 
        BOOL isRollBack = FALSE;
        BOOL insertResult = false;
        @try {
            for (DialogueMemberEntity * member in dialogueMemberArray) {
                insertResult  = [db executeUpdate:@"REPLACE INTO t_dialogue_member(groupId, avatar, joinOrder, nickName , userName , groupid_uid,inGroupNick) VALUES(?,?,?,?,?,?,?)",
                                 groupId,
                                 member.avatar,
                                 member.joinOrder,
                                 member.nickName,
                                 member.userName,
                                [NSString stringWithFormat:@"%@_%@",groupId,member.userName],
                                 member.inGroupNick];
                
                if (!insertResult) {
                    NSLog(@"插入失败");
                }
            }
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [db rollback];
        }
        @finally {
            if(result)
            {
                result(insertResult);
            }
        }
   
}

+(void) queryByID:(NSString *)Id  FMDatabase:(FMDatabase *)db WithGroupId:(NSString *) groupId QueryResult:(QueryMembersResultBlock)result{
    
        DialogueMemberEntity * memberEntity= [[DialogueMemberEntity alloc] init];
        @try {
            FMResultSet *rs=  [db executeQuery:@"SELECT * FROM t_dialogue_member WHERE groupid_uid=?",[NSString stringWithFormat:@"%@_%@",groupId,Id]];
            while ([rs next]) {
                memberEntity.Id = [NSNumber numberWithInt:[rs intForColumn:@"id"]];
                memberEntity.groupId =[rs stringForColumn:@"groupId"];
                memberEntity.avatar =[rs stringForColumn:@"avatar"];
                memberEntity.joinOrder =[NSNumber numberWithInt:[rs intForColumn:@"joinOrder"]];
                memberEntity.nickName =[rs stringForColumn:@"nickName"];
                memberEntity.userName =[rs stringForColumn:@"userName"];
                memberEntity.groupid_uid =[rs stringForColumn:@"groupid_uid"];
                memberEntity.inGroupNick =[rs stringForColumn:@"inGroupNick"];
            }
        }
        @catch (NSException *exception) {
           NSLog(@"数据库操作失败");
        }
        @finally {
            if(result)
            {
                result(memberEntity);
            }
        }
    
}

+(void) queryByGroupId:(NSString *)groupId FMDatabase:(FMDatabase *)db  QueryGroupResult:(QueryGroupResultBlock)result{
    
        NSMutableArray *memberArray = [[NSMutableArray alloc]init];
        @try {
            FMResultSet *rs=  [db executeQuery:@"SELECT * FROM t_dialogue_member WHERE groupid=?",groupId];
            while ([rs next]) {
                DialogueMemberEntity * memberEntity= [[DialogueMemberEntity alloc] init];
                memberEntity.Id = [NSNumber numberWithInt:[rs intForColumn:@"id"]];
                memberEntity.groupId =[rs stringForColumn:@"groupId"];
                memberEntity.avatar =[rs stringForColumn:@"avatar"];
                memberEntity.joinOrder =[NSNumber numberWithInt:[rs intForColumn:@"joinOrder"]];
                memberEntity.nickName =[rs stringForColumn:@"nickName"];
                memberEntity.userName =[rs stringForColumn:@"userName"];
                memberEntity.groupid_uid =[rs stringForColumn:@"groupid_uid"];
                memberEntity.inGroupNick =[rs stringForColumn:@"inGroupNick"];
                [memberArray addObject:memberEntity];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"数据库操作失败");
        }
        @finally {
            if(result)
            {
                result(memberArray);
            }
        }
}


+(void) deleteByID:(NSString *)Id  FMDatabase:(FMDatabase *)db WithGroupId:(NSString *) groupId DelResult:(DelResultBlock)result{

        BOOL delResult = false;
        @try {
            delResult=  [db executeUpdate:@"DELETE FROM t_dialogue_member WHERE groupid_uid=?",[NSString stringWithFormat:@"%@_%@", groupId, Id]];
        }
        @catch (NSException *exception) {
            NSLog(@"数据库操作失败");
        }
        @finally {
            if(result)
            {
                result(delResult);
            }
        }

}

+(void) deleteByNickName:(NSString *)nickName  FMDatabase:(FMDatabase *)db WithGroupId:(NSString *) groupId DelResult:(DelResultBlock)result{
    
    BOOL delResult = false;
    @try {
        delResult=  [db executeUpdate:@"DELETE FROM t_dialogue_member WHERE groupid=? AND nickName=?", groupId, nickName];
    }
    @catch (NSException *exception) {
        NSLog(@"数据库操作失败");
    }
    @finally {
        if(result)
        {
            result(delResult);
        }
    }
    
}

+(void) deleteByGroupId:(NSString *) groupId  FMDatabase:(FMDatabase *)db DelResult:(DelResultBlock)result{
   
        BOOL delResult = false;
        @try {
            delResult=  [db executeUpdate:@"DELETE FROM t_dialogue_member WHERE groupId=?",groupId];
        }
        @catch (NSException *exception) {
           NSLog(@"数据删除失败");
        }
        @finally {
            if(result)
            {
                result(delResult);
            }
        }
}



@end
