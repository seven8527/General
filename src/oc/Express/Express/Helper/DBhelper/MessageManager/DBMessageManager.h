//
//  DBMessageManager.h
//  Express
//
//  Created by owen on 15/11/9.
//  Copyright © 2015年 owen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageEntity.h"

typedef void (^ResultStatBlock) (Boolean result);
typedef void (^QueryMessageResultBlock)               (NSMutableArray * result);                               //通过查询结果block



@interface DBMessageManager : NSObject


//+(void) insert:(MessageEntity *) dialogueList   InsertResult:(InsertResultBlock)result;

+(void) insertArray:(NSMutableArray *) messageArray  FMDatabase:(FMDatabase *)db   ResultStat:(ResultStatBlock)result;

//+(void) queryBySelect:(SelectType)selectType QueryBySelectResult:(QueryBySelectResultBlock)result;
//
+(void) queryAllByID:(NSString *)groupId FMDatabase:(FMDatabase *)db  QueryResult:(QueryMessageResultBlock)result;
+(void) queryLimitByID:(NSString *)groupId FMDatabase:(FMDatabase *)db OffSet:(NSInteger)offset  QueryResult:(QueryMessageResultBlock)result;
//select * from users order by id limit 10 offset 0;
+(void) updateStateByID:(NSString*)messageId Time:(NSString*)time State:(NSNumber*)state FMDatabase:(FMDatabase *)db   QueryResult:(ResultStatBlock)result;


//
+(void) deleteByGroupId:(NSString *)groupId FMDatabase:(FMDatabase *)db DelResult:(ResultStatBlock)result;

+(void) deleteByMessageId:(NSString *)messageId AndWithRectime:(NSNumber *) time  FMDatabase:(FMDatabase *)db DelResult:(ResultStatBlock)result;
@end
