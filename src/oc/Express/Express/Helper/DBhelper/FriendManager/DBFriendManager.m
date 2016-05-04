//
//  DBFriendManager.m
//  Express
//
//  Created by owen on 15/11/4.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "DBFriendManager.h"
#import "DBHelper.h"


@implementation DBFriendManager


#pragma mark  ---插入单个好友---
/**
 *  插入单个好友
 *
 *  @param friends 好友实体
 *  @param result  插入结果
 */
+(void) insert:(FriendEntity *) friends  FMDatabase:(FMDatabase *)db  InsertResult:(InsertResultBlock)result
{
    
        BOOL insertResult = [db executeUpdate:@"REPLACE INTO t_friend(ShowPhoneNum, WatchStatus, avatar, focusType , focusUserName , gender, location, mark, nickName,  phoneType, registerTime, signature, time, verifyMsg) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
                               [NSNumber numberWithInt:friends.ShowPhoneNum],
                               [NSNumber numberWithInt:friends.WatchStatus],
                               friends.avatar,
                               [NSNumber numberWithInt:friends.focusType],
                               friends.focusUserName,
                               friends.gender,
                               friends.location,
                               friends.mark,
                               friends.nickName,
                               [NSNumber numberWithInt:friends.phoneType],
                               friends.registerTime,
                               friends.signature,
                               friends.time,
                               friends.verifyMsg];
        if (insertResult) {
            NSLog(@"数据插入成功");
        }else{
            NSLog(@"数据插入失败");
        }
        if(result)
        {
            result(insertResult);
        }
}

#pragma mark  ---批量插入好友---
/**
 *  批量插入好友（事务提交模式）
 *
 *  @param friends 好友列表实体
 *  @param result  插入结果
 */
+(void) insertArray:(NSMutableArray *) friendsArray FMDatabase:(FMDatabase *)db InsertArrayResult:(InsertArrayResultBlock)result
{
//    FMDatabaseQueue *dbQueue    = [DBHelper getShareInstance];
//    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isRollBack = FALSE;
        BOOL insertResult = false;
        @try {
            for (FriendEntity *friends in friendsArray) {
                
                insertResult  = [db executeUpdate:@"REPLACE INTO t_friend(ShowPhoneNum, WatchStatus, avatar, focusType , focusUserName , gender, location, mark, nickName,  phoneType, registerTime, signature, time, verifyMsg) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
                                [NSNumber numberWithInt:friends.ShowPhoneNum],
                                [NSNumber numberWithInt:friends.WatchStatus],
                                friends.avatar,
                                [NSNumber numberWithInt:friends.focusType],
                                friends.focusUserName,
                                friends.gender,
                                friends.location,
                                friends.mark,
                                friends.nickName,
                                [NSNumber numberWithInt:friends.phoneType],
                                friends.registerTime,
                                friends.signature,
                                friends.time,
                                friends.verifyMsg];
                
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
//    }];
}

#pragma mark ---根据手机号码查询好友-----
/**
 *  根据手机号码查询好友
 *
 *  @param Id     手机号码
 *  @param result 查询到的结果
 */
+(void) queryByID:(NSString *)Id  FMDatabase:(FMDatabase *)db  QueryResult:(QueryMemberResultBlock)result;
{
    
 
       
        FMResultSet *rs=  [db executeQuery:@"SELECT * FROM t_friend WHERE focusUserName=?",Id];
        FriendEntity * friendEntity= [[FriendEntity alloc] init];
        while ([rs next]) {
            friendEntity.Id = [NSNumber numberWithInt:[rs intForColumn:@"id"]];
            friendEntity.ShowPhoneNum= [rs intForColumn:@"ShowPhoneNum"];
            friendEntity.WatchStatus= [rs intForColumn:@"WatchStatus"];
            friendEntity.avatar= [rs stringForColumn:@"avatar"];
            friendEntity.focusType= [rs intForColumn:@"focusType"];
            friendEntity.focusUserName= [rs stringForColumn:@"focusUserName"];
            friendEntity.gender= [rs stringForColumn:@"gender"];
            friendEntity.location= [rs stringForColumn:@"location"];
            friendEntity.mark= [rs stringForColumn:@"mark"];
            friendEntity.nickName= [rs stringForColumn:@"nickName"];
            friendEntity.phoneType = [rs intForColumn:@"phoneType"];
            friendEntity.registerTime= [rs stringForColumn:@"registerTime"];
            friendEntity.signature= [rs stringForColumn:@"signature"];
            friendEntity.time= [rs stringForColumn:@"time"];
            friendEntity.verifyMsg= [rs stringForColumn:@"verifyMsg"];
            
        }
        if(result)
        {
            result(friendEntity);
        }
}

#pragma mark ---查询所有好友-----
/**
 * 查询所有好友
 *  @param focusType 查询的类型 ，是个枚举
 *  @param result 查询到的结果
 */
+(void) queryAll:(FocusType)focusType FMDatabase:(FMDatabase *)db QueryAllResult:(QueryAllResultBlock)result{
//    FMDatabaseQueue *dbQueue    = [DBHelper getShareInstance];
//    [dbQueue inDatabase:^(FMDatabase *db) {
    
        NSString *sql = nil;
        switch (focusType) {
            case All:
                sql = @"SELECT * FROM t_friend";
                break;
            case WaitMeVerify:
                sql = [NSString stringWithFormat:@"SELECT * FROM t_friend WHERE  focusType = %d", WaitMeVerify];
                break;
            case WaitOthersVerify:
                sql = [NSString stringWithFormat:@"SELECT * FROM t_friend WHERE  focusType = %d", WaitOthersVerify];
                break;
            case IsFriend:
                sql = [NSString stringWithFormat:@"SELECT * FROM t_friend WHERE  focusType = %d", IsFriend];
                break;
        }
        FMResultSet *rs=  [db executeQuery:sql];
        
        NSMutableArray * friendArray = [[NSMutableArray alloc]init];
        while ([rs next]) {
            FriendEntity * friendEntity= [[FriendEntity alloc] init];
            friendEntity.Id = [NSNumber numberWithInt:[rs intForColumn:@"id"]];
            friendEntity.ShowPhoneNum= [rs intForColumn:@"ShowPhoneNum"];
            friendEntity.WatchStatus= [rs intForColumn:@"WatchStatus"];
            friendEntity.avatar= [rs stringForColumn:@"avatar"];
            friendEntity.focusType= [rs intForColumn:@"focusType"];
            friendEntity.focusUserName= [rs stringForColumn:@"focusUserName"];
            friendEntity.gender= [rs stringForColumn:@"gender"];
            friendEntity.location= [rs stringForColumn:@"location"];
            friendEntity.mark= [rs stringForColumn:@"mark"];
            friendEntity.nickName= [rs stringForColumn:@"nickName"];
            friendEntity.phoneType = [rs intForColumn:@"phoneType"];
            friendEntity.registerTime= [rs stringForColumn:@"registerTime"];
            friendEntity.signature= [rs stringForColumn:@"signature"];
            friendEntity.time= [rs stringForColumn:@"time"];
            friendEntity.verifyMsg= [rs stringForColumn:@"verifyMsg"];
            [friendArray addObject:friendEntity];
        }
        if(result)
        {
            result(friendArray);
        }
//    }];
}


/**
 *  删除好友
 *
 *  @param result 是否删除成功
 */
+(void) deleteByID:(NSString *)Id  FMDatabase:(FMDatabase *)db  DelResult:(DelResultBlock)result;{
//    FMDatabaseQueue *dbQueue    = [DBHelper getShareInstance];
//    [dbQueue inDatabase:^(FMDatabase *db) {
    
        BOOL delResult=  [db executeUpdate:@"DELETE FROM t_friend WHERE focusUserName=?",Id];
        if (delResult) {
            NSLog(@"数据删除成功");
        }else{
            NSLog(@"数据删除失败");
        }
        if(result)
        {
            result(delResult);
        }
//    }];
}

@end
