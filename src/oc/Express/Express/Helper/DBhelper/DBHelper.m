//
//  DBHelper.m
//  Express
//
//  Created by Owen on 15/11/3.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import "DBHelper.h"

@implementation DBHelper

static DBHelper *dBHelper = nil;
static NSString *DBNAME    = @"ExpressDatabase.db";



+(FMDatabaseQueue *)getShareInstance
{
    FMDatabaseQueue *dbQueue    = nil;
    if (!dbQueue)
    {
        //只有document directory 是可以进行读写的
        NSArray *paths              = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        NSString *dbPath            = [documentDirectory stringByAppendingPathComponent:DBNAME];
        dbQueue                     = [FMDatabaseQueue databaseQueueWithPath:dbPath];
     }

    return dbQueue;
}

+(void)initDB
{
    
    FMDatabaseQueue *dbQueue    = [DBHelper getShareInstance];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        //创建好友表 //id integer PRIMARY KEY AUTOINCREMENT,
        BOOL createTableResult=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_friend (id integer PRIMARY KEY AUTOINCREMENT,ShowPhoneNum integer, WatchStatus integer, avatar varchar, focusType integer, focusUserName varchar UNIQUE, gender varchar, location varchar, mark varchar, nickName varchar, phoneType integer, registerTime varchar, signature varchar, time varchar, verifyMsg varchar)"];
//        BOOL createIndexResult=[db executeUpdate:@"CREATE UNIQUE INDEX  t_friend_index ON  t_friend (focusUserName)"];
        
        
        NSString * dialogueSql =  @"CREATE TABLE IF NOT EXISTS t_dialogue (id INTEGER PRIMARY KEY  AUTOINCREMENT , createTime VARCHAR, groupId VARCHAR UNIQUE , groupMemberCount INTEGER,groupOwer VARCHAR, groupName VARCHAR, groupType INTEGER NOT NULL , isShowMember BOOL, showMemberSetTime VARCHAR, isShowTop BOOL, showTopSetTime VARCHAR, isMsgNotification BOOL, lastMessage VARCHAR, lastMessageTime VARCHAR, hasNewMessage BOOL, messageCount INTEGER,NewmessageCount INTEGER NOT NULL  DEFAULT 0)";
        
        
        NSString * dialogue_memberSql =  @"CREATE TABLE  IF NOT EXISTS t_dialogue_member (id INTEGER PRIMARY KEY  AUTOINCREMENT ,groupId VARCHAR NOT NULL ,avatar VARCHAR,joinOrder INTEGER,nickName VARCHAR, inGroupNick VARCHAR,userName VARCHAR,groupid_uid VARCHAR UNIQUE NOT NULL)";
        
//        NSString * messaegSql =   @"CREATE TABLE IF NOT EXISTS t_message (id INTEGER PRIMARY KEY  NOT NULL , messageId VARCHAR NOT NULL  UNIQUE , groupId VARCHAR NOT NULL , userId VARCHAR NOT NULL , fromUser VARCHAR NOT NULL , nickName VARCHAR, avatar VARCHAR, content VARCHAR, voice VARCHAR, time VARCHAR NOT NULL , msgType VARCHAR NOT NULL , mark VARCHAR, isFromWatch INTEGER, url VARCHAR, image VARCHAR, brief VARCHAR, title VARCHAR, video VARCHAR, v_width INTEGER, v_height VARCHAR, delay VARCHAR, isGroup BOOL)";
        NSString * messaegSql =   @"CREATE TABLE IF NOT EXISTS t_message (id INTEGER PRIMARY KEY  NOT NULL , messageId VARCHAR    , toUserName VARCHAR , fromUserName VARCHAR, fromUser VARCHAR  , nickName VARCHAR, avatar VARCHAR, content VARCHAR , voice VARCHAR, time VARCHAR NOT NULL , msgType VARCHAR NOT NULL , mark VARCHAR, isFromWatch INTEGER, url VARCHAR, image VARCHAR, brief VARCHAR, title VARCHAR, video VARCHAR, v_width INTEGER, v_height VARCHAR, delay VARCHAR, isGroup BOOL , state INTEGER , rectime INTEGER, isshowtime BOOL)";
        
         NSString * userinfoSql =   @"CREATE  TABLE  IF NOT EXISTS t_userinfo (id INTEGER PRIMARY KEY  NOT NULL , Age INTEGER, Avatar VARCHAR NOT NULL , BackgroundPicture VARCHAR, Email VARCHAR, Gender VARCHAR, Hobbies VARCHAR, Location VARCHAR, Nickname VARCHAR, RegisterTime VARCHAR, ShowPhoneNum BOOL, Signature VARCHAR, WatchStatus BOOL)";
        createTableResult=createTableResult && [db executeUpdate:dialogueSql];
        createTableResult=createTableResult && [db executeUpdate:dialogue_memberSql];
        createTableResult=createTableResult && [db executeUpdate:messaegSql];
        createTableResult=createTableResult && [db executeUpdate:userinfoSql];
        if (createTableResult ) {
            NSLog(@"创建表成功");
        }else{
            NSLog(@"创建表失败");
        }
    }];
     

}
+(void) inTransaction:(ExecuteBlock)sql
{
    FMDatabaseQueue *dbQueue    = [DBHelper getShareInstance];
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isRollBack = FALSE;
        @try {
            if (sql) {
                sql(db);
            }
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [db rollback];
        }
        
    }];
}
@end
