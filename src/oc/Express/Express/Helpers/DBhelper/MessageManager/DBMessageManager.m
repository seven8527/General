//
//  DBMessageManager.m
//  Express
//
//  Created by owen on 15/11/9.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "DBMessageManager.h"
#import "DBHelper.h"
#import "DBDialogueListManager.h"
#import "DBDialogueMemberManager.h"

@implementation DBMessageManager

+(void) insertArray:(NSMutableArray *) messageArray  FMDatabase:(FMDatabase *)db  ResultStat:(ResultStatBlock)result{
        BOOL isRollBack = FALSE;
        BOOL insertResult = false;
    
        @try {
            for (MessageEntity *message in messageArray) {
//                NSDate *date = [NSDate date];
//                NSTimeInterval timeStamp= [date timeIntervalSince1970];
  //////////////////////////////////操作 t_message 表////////////////////////////////////////////////////
                NSNumber *isGroup = nil;
                NSString *groupId = nil;
                NSString *userId = nil;
                
                if (message.fromUser == nil) { //判断是否是发送的消息
                    message.messageId = message.toUserName;
                    groupId = message.messageId;
                    userId= message.fromUserName;
                }
                else
                {
                    if ([message.fromUser containsString:@"_"]) { //接受的是组消息
                        isGroup =[NSNumber numberWithBool:YES];
                        NSArray *array = [message.fromUser  componentsSeparatedByString:@"_"];
                        groupId = array[0];
                        userId = array[1];
                    }
                    else
                    {
                        groupId = message.fromUser;
                        userId = message.fromUser;
                        isGroup =[NSNumber numberWithBool:NO];
                        
                    }
                    message.messageId = groupId ;
                }
                long long  timeInt =[[NSDate date] timeIntervalSince1970]*1000;
                message.rectime = [NSNumber  numberWithLongLong:timeInt];
                
//                NSDate *dd = [NSDate dateWithTimeIntervalSince1970:timeInt/1000];
//                NSLog(@"d:%@",dd); //2011-01-18 03:55:49 +0000
                
                  //////////////////////////////////处理其他关联表////////////////////////////////////////////////////
                
                
                if ([message.msgType isEqualToString:@"user"] || [message.msgType isEqualToString:@"user_image"]) {
                    
                   [DBDialogueListManager queryByID:groupId FMDatabase:db QueryResult:^(DialogueListEntity *result) {
                      DialogueListEntity *  dialogueList = result;
                       if (dialogueList.groupId == nil) {
                           dialogueList.createTime = message.time;
                           dialogueList.groupId=groupId;
                           dialogueList.groupMemberCount = [NSNumber numberWithInt:2];
                           dialogueList.groupName = message.nickName;
                           dialogueList.groupOwer = groupId;
                           message.isshowtime = [NSNumber numberWithBool:YES];
                           
                       }
                       dialogueList.hasNewMessage = [NSNumber numberWithBool:YES];
                       if ([message.rectime longLongValue]-[dialogueList.lastMessageTime longLongValue]>1000*60*2) {
                           message.isshowtime = [NSNumber numberWithBool:YES];
                       }
                       else
                       {
                           message.isshowtime = [NSNumber numberWithBool:NO];
                       }
                       dialogueList.lastMessageTime = [NSString stringWithFormat:@"%@",message.rectime];
                       dialogueList.groupType =[NSNumber numberWithInt:p2p];
                       dialogueList.messageCount = [NSNumber numberWithLong:[dialogueList.messageCount integerValue] + 1];
                       if (![userId isEqualToString:APPDELEGATE.UserID]) {
                           dialogueList.NewmessageCount = [NSNumber numberWithLong:[dialogueList.NewmessageCount integerValue] + 1];
                       }
                       

                       if ([message.msgType isEqualToString:@"user"]) {
                           if (![message.video isEqualToString:@""] && message.video != nil) {
                               dialogueList.lastMessage = @"[视频]";
                           }
                           else if (![message.voice isEqualToString:@""]&& message.voice != nil) {
                               dialogueList.lastMessage = @"[语音]";
                           }
                           else if (![message.url isEqualToString:@""]&& message.url != nil) {
                               dialogueList.lastMessage = @"[链接]";
                           }
                           else
                           {
                               dialogueList.lastMessage = message.content;
                           }
                       }
                       else if ([message.msgType isEqualToString:@"user_image"]) {
                           dialogueList.lastMessage = @"[图片]";
                       }
                       [DBDialogueListManager updateByID:dialogueList.groupId FMDatabase:db DialogueListEntity:dialogueList UpdateResult:^(Boolean result) {
                           NSLog(@"result = %@", result?@"YES":@"NO" );
                       }];
                       
                   }];
                    
                }
                else if ([message.msgType isEqualToString:@"group"] || [message.msgType isEqualToString:@"group_image"]) {
                    
                        [DBDialogueListManager queryByID:groupId FMDatabase:db QueryResult:^(DialogueListEntity *result) {
                            if (result.groupId == nil) {
                                result.groupId = groupId;
                                result.createTime = message.time;
                                result.NewmessageCount =[NSNumber numberWithInt:0];
                                result.groupOwer = groupId;
                                message.isshowtime = [NSNumber numberWithBool:YES];
                                
                            }
                            result.hasNewMessage = [NSNumber numberWithBool:YES];
                            if ([message.rectime longLongValue]-[result.lastMessageTime longLongValue]>1000*60*2) {
                                message.isshowtime = [NSNumber numberWithBool:YES];
                            }
                            else
                            {
                                message.isshowtime = [NSNumber numberWithBool:NO];
                            }
                            result.lastMessageTime = [NSString stringWithFormat:@"%@",message.rectime];
                            result.groupType =[NSNumber numberWithInt:Group];
                            result.messageCount = [NSNumber numberWithLong:[result.messageCount integerValue] + 1];
                            if (![userId isEqualToString:APPDELEGATE.UserID]) {
                                result.NewmessageCount = [NSNumber numberWithLong:[result.NewmessageCount integerValue] + 1];
                            }
                            if ([message.msgType isEqualToString:@"group"]) {
                                if (![message.video isEqualToString:@""]&& message.video != nil) {
                                    result.lastMessage = @"[视频]";
                                }
                                else if (![message.voice isEqualToString:@""]&& message.voice != nil) {
                                    result.lastMessage = @"[语音]";
                                }
                                else if (![message.url isEqualToString:@""]&& message.url != nil) {
                                    result.lastMessage = @"[链接]";
                                }
                                else
                                {
                                    result.lastMessage = message.content;
                                }
                             }
                             else if ([message.msgType isEqualToString:@"group_image"]) {
                                  result.lastMessage = @"[图片]";
                             }
                            [DBDialogueListManager  updateByID:result.groupId  FMDatabase:db DialogueListEntity:result UpdateResult:^(Boolean result) {
                                   NSLog(@"result = %@", result?@"YES":@"NO" );
                             }];
                        }];
                }
                else if ([message.msgType isEqualToString:@"group_create"])
                {
                    message.group_info.groupId = groupId;
                    [DBDialogueListManager insert:message.group_info FMDatabase:db  GroupType:Group InsertResult:^(Boolean result) {
                        NSLog(@"result = %@", result?@"YES":@"NO" );
                    }];
                    return;
                }
                else if ([message.msgType isEqualToString:@"group_add"])
                {
                    message.group_info.groupId = groupId;
                    [DBDialogueListManager insert:message.group_info FMDatabase:db  GroupType:Group InsertResult:^(Boolean result) {
                        NSLog(@"result = %@", result?@"YES":@"NO" );
                    }];
                    
                    message.group_info.hasNewMessage = [NSNumber numberWithBool:YES];
                    message.isshowtime = [NSNumber numberWithBool:NO];
                    message.group_info.lastMessageTime = [NSString stringWithFormat:@"%@",message.rectime];
                    message.group_info.groupType =[NSNumber numberWithInt:Group];
                    message.group_info.messageCount = [NSNumber numberWithLong:[message.group_info.messageCount integerValue] + 1];
                    message.group_info.NewmessageCount = [NSNumber numberWithLong:[message.group_info.NewmessageCount integerValue] + 1];
                    message.group_info.lastMessage = message.content;
                    [DBDialogueListManager  updateByID:groupId  FMDatabase:db DialogueListEntity:message.group_info UpdateResult:^(Boolean result) {
                        NSLog(@"result = %@", result?@"YES":@"NO" );
                    }];
                }
                else if ([message.msgType isEqualToString:@"group_remove"])
                {
                    message.group_info.groupId = groupId;
                    [DBDialogueMemberManager deleteByNickName:message.content FMDatabase:db  WithGroupId:groupId DelResult:^(Boolean result) {
                        NSLog(@"result = %@", result?@"YES":@"NO" );
                    }];
                    [DBDialogueListManager queryByID:groupId FMDatabase:db QueryResult:^(DialogueListEntity *result) {
                        if (result.groupId == nil) {
                            result.groupId = groupId;
                            result.createTime = message.time;
                            result.NewmessageCount =[NSNumber numberWithInt:0];
                            result.groupOwer = groupId;
                            message.isshowtime = [NSNumber numberWithBool:NO];
                            
                        }
                        result.hasNewMessage = [NSNumber numberWithBool:YES];
                        message.isshowtime = [NSNumber numberWithBool:NO];
                        result.lastMessageTime = [NSString stringWithFormat:@"%@",message.rectime];
                        result.groupType =[NSNumber numberWithInt:Group];
                        result.messageCount = [NSNumber numberWithLong:[result.messageCount integerValue] + 1];
                        result.NewmessageCount = [NSNumber numberWithLong:[result.NewmessageCount integerValue] + 1];
                        result.lastMessage = message.content;
                        [DBDialogueListManager  updateByID:groupId  FMDatabase:db DialogueListEntity:result UpdateResult:^(Boolean result) {
                            NSLog(@"result = %@", result?@"YES":@"NO" );
                        }];
                    }];
                }
                else if ([message.msgType isEqualToString:@"group_quit"])
                {
                    message.group_info.groupId = groupId;
                    [DBDialogueMemberManager deleteByID:userId FMDatabase:db  WithGroupId:groupId DelResult:^(Boolean result) {
                        NSLog(@"result = %@", result?@"YES":@"NO" );
                    }];
                    [DBDialogueListManager queryByID:groupId FMDatabase:db QueryResult:^(DialogueListEntity *result) {
                        if (result.groupId == nil) {
                            result.groupId = groupId;
                            result.createTime = message.time;
                            result.NewmessageCount =[NSNumber numberWithInt:0];
                            result.groupOwer = groupId;
                            message.isshowtime = [NSNumber numberWithBool:NO];
                            
                        }
                        result.hasNewMessage = [NSNumber numberWithBool:YES];
                        message.isshowtime = [NSNumber numberWithBool:NO];
                        result.lastMessageTime = [NSString stringWithFormat:@"%@",message.rectime];
                        result.groupType =[NSNumber numberWithInt:Group];
                        result.messageCount = [NSNumber numberWithLong:[result.messageCount integerValue] + 1];
                        result.NewmessageCount = [NSNumber numberWithLong:[result.NewmessageCount integerValue] + 1];
                        result.lastMessage = message.content;
                        [DBDialogueListManager  updateByID:groupId  FMDatabase:db DialogueListEntity:result UpdateResult:^(Boolean result) {
                            NSLog(@"result = %@", result?@"YES":@"NO" );
                        }];
                    }];
                }
                else if ([message.msgType isEqualToString:@"group_destroy"] )
                {
                    [DBDialogueListManager deleteByGroupId:message.toUserName  FMDatabase:db DelResult:^(Boolean result) {
                        NSLog(@"result = %@", result?@"YES":@"NO" );
                    }];
                }
                
                // 正式插入数据
                insertResult  =[db executeUpdate:@"REPLACE INTO t_message(messageId, toUserName, fromUserName, fromUser, nickName, avatar, content, voice, time, msgType, mark, isFromWatch, url, image, brief, title, video, v_width, v_height, delay, isGroup, state, rectime, isshowtime) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
                                message.messageId, //暂时没有该字段
                                groupId,
                                userId,
                                message.fromUser,
                                message.nickName,
                                message.avatar,
                                message.content,
                                message.voice,
                                message.time,
                                message.msgType,
                                message.mark,
                                message.isFromWatch,
                                message.url,
                                message.image,
                                message.brief,
                                message.title,
                                message.video,
                                message.v_width,
                                message.v_height,
                                message.delay,
                                isGroup,
                                message.state,
                                message.rectime,
                                message.isshowtime];
                
                
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

+(void) queryAllByID:(NSString *)groupId FMDatabase:(FMDatabase *)db  QueryResult:(QueryMessageResultBlock)result
{
    BOOL isRollBack = FALSE;
    
    NSMutableArray * messageArray = [[NSMutableArray alloc]init];
    @try {
        
        FMResultSet *rs=  [db executeQuery:@"SELECT *  FROM t_message WHERE messageId=?",groupId];
        while ([rs next]) {
            MessageEntity * messageBean = [[MessageEntity alloc]init];
            messageBean.messageId =  [rs stringForColumn:@"messageId"];
            messageBean.toUserName =  [rs stringForColumn:@"toUserName"];
            messageBean.fromUserName =  [rs stringForColumn:@"fromUserName"];
            messageBean.fromUser =  [rs stringForColumn:@"fromUser"];
            messageBean.nickName =  [rs stringForColumn:@"nickName"];
            messageBean.avatar =  [rs stringForColumn:@"avatar"];
            messageBean.content =  [rs stringForColumn:@"content"];
            messageBean.voice =  [rs stringForColumn:@"voice"];
            messageBean.time =  [rs stringForColumn:@"time"];
            messageBean.msgType =  [rs stringForColumn:@"msgType"];
            messageBean.mark =  [rs stringForColumn:@"mark"];
            messageBean.isFromWatch =  [NSNumber numberWithInt:[rs intForColumn:@"isFromWatch"]];
            messageBean.url =  [rs stringForColumn:@"url"];
            messageBean.image =  [rs stringForColumn:@"image"];
            messageBean.brief =  [rs stringForColumn:@"brief"];
            messageBean.title =  [rs stringForColumn:@"title"];
            messageBean.video =  [rs stringForColumn:@"video"];
            messageBean.v_width =  [NSNumber numberWithInt:[rs intForColumn:@"v_width"]];
            messageBean.v_height =  [NSNumber numberWithInt:[rs intForColumn:@"v_height"]];
            messageBean.delay =  [rs stringForColumn:@"delay"];
            messageBean.isGroup =  [NSNumber numberWithInt:[rs boolForColumn:@"isGroup"]];
            messageBean.state =  [NSNumber numberWithInt:[rs intForColumn:@"state"]];
            messageBean.rectime =  [NSNumber numberWithLongLong:[rs longLongIntForColumn:@"rectime"]];
            messageBean.isshowtime = [NSNumber numberWithBool:[rs boolForColumn:@"isshowtime"]];
            [messageArray addObject:messageBean];
         
        }
        
    }
    @catch (NSException *exception) {
        isRollBack = YES;
        [db rollback];
    }
    @finally {
        if(result)
        {
            result(messageArray);
        }
    }
}
+(void) queryLimitByID:(NSString *)groupId FMDatabase:(FMDatabase *)db OffSet:(NSInteger)offset  QueryResult:(QueryMessageResultBlock)result;
{
    BOOL isRollBack = FALSE;
    
    NSMutableArray * messageArray = [[NSMutableArray alloc]init];
    @try {
        
        FMResultSet *rs=  [db executeQuery:@"SELECT *  FROM t_message WHERE messageId=? order by rectime DESC Limit 20 offset ?",groupId, [NSNumber numberWithInteger:offset]];
        while ([rs next]) {
            MessageEntity * messageBean = [[MessageEntity alloc]init];
            messageBean.messageId =  [rs stringForColumn:@"messageId"];
            messageBean.toUserName =  [rs stringForColumn:@"toUserName"];
            messageBean.fromUserName =  [rs stringForColumn:@"fromUserName"];
            messageBean.fromUser =  [rs stringForColumn:@"fromUser"];
            messageBean.nickName =  [rs stringForColumn:@"nickName"];
            messageBean.avatar =  [rs stringForColumn:@"avatar"];
            messageBean.content =  [rs stringForColumn:@"content"];
            messageBean.voice =  [rs stringForColumn:@"voice"];
            messageBean.time =  [rs stringForColumn:@"time"];
            messageBean.msgType =  [rs stringForColumn:@"msgType"];
            messageBean.mark =  [rs stringForColumn:@"mark"];
            messageBean.isFromWatch =  [NSNumber numberWithInt:[rs intForColumn:@"isFromWatch"]];
            messageBean.url =  [rs stringForColumn:@"url"];
            messageBean.image =  [rs stringForColumn:@"image"];
            messageBean.brief =  [rs stringForColumn:@"brief"];
            messageBean.title =  [rs stringForColumn:@"title"];
            messageBean.video =  [rs stringForColumn:@"video"];
            messageBean.v_width =  [NSNumber numberWithInt:[rs intForColumn:@"v_width"]];
            messageBean.v_height =  [NSNumber numberWithInt:[rs intForColumn:@"v_height"]];
            messageBean.delay =  [rs stringForColumn:@"delay"];
            messageBean.isGroup =  [NSNumber numberWithInt:[rs boolForColumn:@"isGroup"]];
            messageBean.state =  [NSNumber numberWithInt:[rs intForColumn:@"state"]];
            messageBean.rectime =  [NSNumber numberWithLongLong:[rs longLongIntForColumn:@"rectime"]];
            messageBean.isshowtime = [NSNumber numberWithBool:[rs boolForColumn:@"isshowtime"]];
            [messageArray addObject:messageBean];
            
        }
        
    }
    @catch (NSException *exception) {
        isRollBack = YES;
        [db rollback];
    }
    @finally {
        if(result)
        {
            result(messageArray);
        }
    }
}

+(void) updateStateByID:(NSString*)messageId Time:(NSString*)time State:(NSNumber*)state FMDatabase:(FMDatabase *)db   QueryResult:(ResultStatBlock)result
{
    BOOL isRollBack = FALSE;
    BOOL insertResult = false;
    @try {
          insertResult  = [db executeUpdate:@"UPDATE t_message SET state = ? WHERE messageId = ? and time = ?", state, messageId, time];
        if (!insertResult) {
            DLog(@"更新数据出错 messageId= %@, time = %@, state = %@",messageId, time , state);
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

+(void) deleteByGroupId:(NSString *)groupId FMDatabase:(FMDatabase *)db DelResult:(ResultStatBlock)result
{
    BOOL isRollBack = FALSE;
    BOOL insertResult = false;
    @try {
//         BOOL delResult=  [db executeUpdate:@"DELETE FROM t_friend WHERE focusUserName=?",Id];
        insertResult  = [db executeUpdate:@"DELETE FROM t_message WHERE messageId = ?", groupId];
        if (!insertResult) {
            DLog(@"删除出错 messageId= %@",groupId);
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

+(void) deleteByMessageId:(NSString *)messageId AndWithRectime:(NSNumber *) time  FMDatabase:(FMDatabase *)db DelResult:(ResultStatBlock)result
{
    BOOL isRollBack = FALSE;
    BOOL insertResult = false;
    @try {
        //         BOOL delResult=  [db executeUpdate:@"DELETE FROM t_friend WHERE focusUserName=?",Id];
        insertResult  = [db executeUpdate:@"DELETE FROM t_message WHERE messageId = ? AND rectime = ?", messageId, time];
        if (!insertResult) {
            DLog(@"删除出错 messageId= %@",messageId);
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

@end
