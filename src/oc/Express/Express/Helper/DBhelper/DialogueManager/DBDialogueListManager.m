//
//  DBDialogueListManager.m
//  Express
//
//  Created by owen on 15/11/6.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "DBDialogueListManager.h"
#import "DBHelper.h"
#import "DialogueListEntity.h"
#import "DBDialogueMemberManager.h"

@implementation DBDialogueListManager

/**
 *  此方法只负责与服务器进行 相关数据同步。 本地配置相关的功能和字段不更新
 *
 *  @param dialogueList 从服务器拉取的相关数据
 *  @param result       返回插入状态结果
 */
+(void) insert:(DialogueListEntity *) dialogueList  FMDatabase:(FMDatabase *)db GroupType:(GroupType)groupType    InsertResult:(InsertResultBlock)result{
    BOOL isRollBack = FALSE;
    BOOL __block insertResult = false;
    @try
    {
        [DBDialogueListManager queryByID:dialogueList.groupId FMDatabase:db QueryResult:^(DialogueListEntity *result) {
            if (result.groupId == nil) {
                insertResult  =[db executeUpdate:@"REPLACE INTO t_dialogue(createTime, groupId, groupMemberCount, groupOwer , groupName , groupType) VALUES(?,?,?,?,?,?)",
                                dialogueList.createTime,
                                dialogueList.groupId,
                                dialogueList.groupMemberCount,
                                dialogueList.groupOwer,
                                dialogueList.groupName,
                                [NSNumber numberWithInt:groupType]];
                [DBDialogueMemberManager insertArray: dialogueList.groupMemberList FMDatabase:db WithGroupId:dialogueList.groupId InsertResult:^(Boolean result) {
                    if (!result) {
                        NSLog(@"插入失败");
                    }
                }];
                
                if (!insertResult) {
                    NSLog(@"插入失败");
                }
                
            }
            else
            {
                DialogueListEntity *tempDialogueList = result;
                tempDialogueList.createTime = dialogueList.createTime;
                tempDialogueList.groupMemberCount =dialogueList.groupMemberCount;
                tempDialogueList.groupOwer =dialogueList.groupOwer;
                tempDialogueList.groupName = dialogueList.groupName;
                tempDialogueList.groupType = [NSNumber numberWithInt:groupType];
                
                [DBDialogueListManager updateByID:tempDialogueList.groupId FMDatabase:db DialogueListEntity:tempDialogueList UpdateResult:^(Boolean result) {
                    insertResult = result;
                    if (result) {
                        [DBDialogueMemberManager insertArray: dialogueList.groupMemberList FMDatabase:db WithGroupId:dialogueList.groupId InsertResult:^(Boolean result) {
                            if (!result) {
                                
                                NSLog(@"插入失败");
                                
                            }
                        }];
                        
                    }
                    else{
                        NSLog(@"插入失败");
                    }
                }];
                
                
            }
        }];
        
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

+(void) insertArray:(NSMutableArray<DialogueListEntity> *) dialogueListArray FMDatabase:(FMDatabase *)db  GroupType:(GroupType)groupType    InsertArrayResult:(InsertArrayResultBlock)result{
        BOOL isRollBack = FALSE;
        BOOL __block insertResult = false;
        @try {
            for (DialogueListEntity *dialogueList in dialogueListArray) {
                
                [DBDialogueListManager queryByID:dialogueList.groupId FMDatabase:db QueryResult:^(DialogueListEntity *result) {
                    if (result.groupId == nil) {
                        insertResult  =[db executeUpdate:@"REPLACE INTO t_dialogue(createTime, groupId, groupMemberCount, groupOwer , groupName , groupType) VALUES(?,?,?,?,?,?)",
                                        dialogueList.createTime,
                                        dialogueList.groupId,
                                        dialogueList.groupMemberCount,
                                        dialogueList.groupOwer,
                                        dialogueList.groupName,
                                        [NSNumber numberWithInt:groupType]];
                        [DBDialogueMemberManager insertArray: dialogueList.groupMemberList FMDatabase:db WithGroupId:dialogueList.groupId InsertResult:^(Boolean result) {
                            if (!result) {
                                NSLog(@"插入失败");
                            }
                        }];
                        
                        if (!insertResult) {
                            NSLog(@"插入失败");
                        }

                    }
                    else
                    {
                        DialogueListEntity *tempDialogueList = result;
                        tempDialogueList.createTime = dialogueList.createTime;
                        tempDialogueList.groupMemberCount =dialogueList.groupMemberCount;
                        tempDialogueList.groupOwer =dialogueList.groupOwer;
                        tempDialogueList.groupName = dialogueList.groupName;
                        tempDialogueList.groupType = [NSNumber numberWithInt:groupType];
                        
                        [DBDialogueListManager updateByID:tempDialogueList.groupId FMDatabase:db DialogueListEntity:tempDialogueList UpdateResult:^(Boolean result) {
                            insertResult = result;
                            if (result) {
                                [DBDialogueMemberManager insertArray: dialogueList.groupMemberList FMDatabase:db WithGroupId:dialogueList.groupId InsertResult:^(Boolean result) {
                                    if (!result) {
                                  
                                        NSLog(@"插入失败");
                                        
                                    }
                                }];

                            }
                            else{
                                NSLog(@"插入失败");
                            }
                        }];
                        

                    }
                }];
                
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

+(void) queryByID:(NSString *)groupId FMDatabase:(FMDatabase *)db  QueryResult:(QueryResultBlock)result{
    
        BOOL isRollBack = FALSE;
        DialogueListEntity * dialogueList= [[DialogueListEntity alloc] init];
        @try {
            FMResultSet *rs=  [db executeQuery:@"SELECT * FROM t_dialogue WHERE groupId=?",groupId];
            while ([rs next]) {
                dialogueList.Id = [NSNumber numberWithInt:[rs intForColumn:@"id"]];
                dialogueList.createTime = [rs stringForColumn:@"createTime"];
                dialogueList.groupId = [rs stringForColumn:@"groupId"];
                dialogueList.groupMemberCount = [NSNumber numberWithInt:[rs intForColumn:@"groupMemberCount"]];
                dialogueList.groupOwer = [rs stringForColumn:@"groupOwer"];
                dialogueList.groupName = [rs stringForColumn:@"groupName"];
                dialogueList.groupType =[NSNumber numberWithInt:[rs intForColumn:@"groupType"]];
                dialogueList.isShowMember =[NSNumber numberWithBool:[rs boolForColumn:@"isShowMember"]];
                dialogueList.showMemberSetTime = [rs stringForColumn:@"showMemberSetTime"];
                dialogueList.isShowTop =[NSNumber numberWithBool:[rs boolForColumn:@"isShowTop"]];
                dialogueList.showTopSetTime = [rs stringForColumn:@"showTopSetTime"];
                dialogueList.isMsgNotification =[NSNumber numberWithBool:[rs boolForColumn:@"isMsgNotification"]];
                dialogueList.lastMessage = [rs stringForColumn:@"lastMessage"];
                dialogueList.lastMessageTime = [rs stringForColumn:@"lastMessageTime"];
                dialogueList.hasNewMessage =[NSNumber numberWithBool:[rs boolForColumn:@"hasNewMessage"]];
                dialogueList.messageCount =[NSNumber numberWithInt:[rs intForColumn:@"messageCount"]];
                dialogueList.NewmessageCount =[NSNumber numberWithInt:[rs intForColumn:@"NewmessageCount"]];

                //查询另一张表
                [DBDialogueMemberManager queryByGroupId:groupId FMDatabase:db QueryGroupResult:^(NSMutableArray<DialogueMemberEntity>  *result) {
                    dialogueList.groupMemberList  =result;
                }];
                
            }
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [db rollback];
        }
        @finally {
            if(result)
            {
                result(dialogueList);
            }
        }
}

+(void) queryBySelect:(SelectType)selectType FMDatabase:(FMDatabase *)db  QueryBySelectResult:(QueryBySelectResultBlock)result{
   
    
        NSString *sql = nil;
        switch (selectType) {
            case all:
                sql = @"SELECT * FROM t_dialogue";
                break;
            case newMsg:
                sql = [NSString stringWithFormat:@"SELECT * FROM t_dialogue WHERE  messageCount >= 1"];
                break;
        }
        FMResultSet *rs=  [db executeQuery:sql];
        NSMutableArray *  dialogueListArray= [[NSMutableArray alloc]init];
        while ([rs next]) {
            DialogueListEntity * dialogueList = [[DialogueListEntity alloc]init];
            dialogueList.Id = [NSNumber numberWithInt:[rs intForColumn:@"id"]];
            dialogueList.createTime = [rs stringForColumn:@"createTime"];
            dialogueList.groupId = [rs stringForColumn:@"groupId"];
            dialogueList.groupMemberCount = [NSNumber numberWithInt:[rs intForColumn:@"groupMemberCount"]];
            dialogueList.groupOwer = [rs stringForColumn:@"groupOwer"];
            dialogueList.groupName = [rs stringForColumn:@"groupName"];
            dialogueList.groupType =[NSNumber numberWithInt:[rs intForColumn:@"groupType"]];
            dialogueList.isShowMember =[NSNumber numberWithBool:[rs boolForColumn:@"isShowMember"]];
            dialogueList.showMemberSetTime = [rs stringForColumn:@"showMemberSetTime"];
            dialogueList.isShowTop =[NSNumber numberWithBool:[rs boolForColumn:@"isShowTop"]];
            dialogueList.showTopSetTime = [rs stringForColumn:@"showTopSetTime"];
            dialogueList.isMsgNotification =[NSNumber numberWithBool:[rs boolForColumn:@"isMsgNotification"]];
            dialogueList.lastMessage = [rs stringForColumn:@"lastMessage"];
            dialogueList.lastMessageTime = [rs stringForColumn:@"lastMessageTime"];
            dialogueList.hasNewMessage =[NSNumber numberWithBool:[rs boolForColumn:@"hasNewMessage"]];
            dialogueList.messageCount =[NSNumber numberWithInt:[rs intForColumn:@"messageCount"]];
            dialogueList.NewmessageCount =[NSNumber numberWithInt:[rs intForColumn:@"NewmessageCount"]];
            
            //查询另一张表
            [DBDialogueMemberManager queryByGroupId:dialogueList.groupId FMDatabase:db QueryGroupResult:^(NSMutableArray<DialogueMemberEntity>  *result) {
                dialogueList.groupMemberList  =result;
            }];
            [dialogueListArray addObject:dialogueList];
        }
        if(result)
        {
            result(dialogueListArray);
        }

}
+(void) updateByID:(NSString *)groupId  FMDatabase:(FMDatabase *)db DialogueListEntity:(DialogueListEntity *) dialogueList UpdateResult:(UpdateResultBlock)result{
        BOOL insertResult = false;
        @try {
            insertResult  = [db executeUpdate:@"REPLACE INTO t_dialogue(createTime, groupId, groupMemberCount, groupOwer , groupName , groupType,isShowMember,showMemberSetTime,isShowTop, showTopSetTime, isMsgNotification,lastMessage, lastMessageTime,hasNewMessage, messageCount,NewmessageCount) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
                             dialogueList.createTime,
                             dialogueList.groupId,
                             dialogueList.groupMemberCount,
                             dialogueList.groupOwer,
                             dialogueList.groupName,
                             dialogueList.groupType,
                             dialogueList.isShowMember,
                             dialogueList.showMemberSetTime,
                             dialogueList.isShowTop,
                             dialogueList.showTopSetTime,
                             dialogueList.isMsgNotification,
                             dialogueList.lastMessage,
                             dialogueList.lastMessageTime,
                             dialogueList.hasNewMessage,
                             dialogueList.messageCount,
                             dialogueList.NewmessageCount
                             ];
            if (!insertResult) {
                NSLog(@"更新失败");
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


+(void) deleteByGroupId:(NSString *)groupId  FMDatabase:(FMDatabase *)db DelResult:(DelResultBlock)result{
    
        BOOL delResult = false;
        @try {
            delResult=  [db executeUpdate:@"DELETE FROM t_dialogue WHERE groupId=?",groupId];
            delResult=  delResult&&[db executeUpdate:@"DELETE FROM t_dialogue_member WHERE groupId=?",groupId];
//          delResult=  delResult&&[db executeUpdate:@"DELETE FROM t_message WHERE groupId=?",groupId];
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
