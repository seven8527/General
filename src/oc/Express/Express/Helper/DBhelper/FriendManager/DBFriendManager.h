//
//  DBFriendManager.h
//  Express
//
//  Created by owen on 15/11/4.
//  Copyright © 2015年 owen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendEntity.h"
typedef void (^InsertResultBlock)       (Boolean result);               //插入单个好友结果block
typedef void (^InsertArrayResultBlock)  (Boolean result);               //批量插入好友结果block
typedef void (^QueryMemberResultBlock)        (FriendEntity * result);  //通过手机号查询结果block
typedef void (^QueryAllResultBlock)     (NSMutableArray * result);      //查询所有好友结果block
typedef void (^DelResultBlock)          (Boolean result);               //删除单个好友结果block

typedef enum {
    All = 0 ,               //所有好友
    WaitOthersVerify ,      //等待对方确认
    WaitMeVerify,           //等待我确认
    IsFriend,               //已经是好友
}FocusType;



@interface DBFriendManager : NSObject

+(void) insert:(FriendEntity *) friends   FMDatabase:(FMDatabase *)db   InsertResult:(InsertResultBlock)result;

+(void) insertArray:(NSMutableArray *) friendsArray  FMDatabase:(FMDatabase *)db InsertArrayResult:(InsertArrayResultBlock)result;

+(void) queryByID:(NSString *)Id   FMDatabase:(FMDatabase *)db QueryResult:(QueryMemberResultBlock)result;

+(void) queryAll:(FocusType)focusType FMDatabase:(FMDatabase *)db QueryAllResult:(QueryAllResultBlock)result; // 类型传入枚举

+(void) deleteByID:(NSString *)Id   FMDatabase:(FMDatabase *)db DelResult:(DelResultBlock)result;

@end
