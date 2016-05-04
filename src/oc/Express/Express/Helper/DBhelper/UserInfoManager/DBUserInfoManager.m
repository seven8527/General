//
//  DBUserInfoManager.m
//  Express
//
//  Created by owen on 15/11/20.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "DBUserInfoManager.h"

@implementation DBUserInfoManager
+(void) insert:(UserInfoEntity *) userinfo   FMDatabase:(FMDatabase *)db   InsertResult:(ResultStatBlock)result{
    
    BOOL insertResult = [db executeUpdate:@"REPLACE INTO t_userinfo(Age , Avatar  , BackgroundPicture, Email, Gender , Hobbies , Location , Nickname , RegisterTime , ShowPhoneNum , Signature , WatchStatus) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)",
                         userinfo.Age,
                         userinfo.Avatar,
                         userinfo.BackgroundPicture,
                         userinfo.Email,
                         userinfo.Gender,
                         userinfo.Hobbies,
                         userinfo.Location,
                         userinfo.Nickname,
                         userinfo.RegisterTime,
                         userinfo.ShowPhoneNum,
                         userinfo.Signature,
                         userinfo.WatchStatus
                         ];
    if (insertResult) {
        NSLog(@"数据插入成功");
    }else{
        DLog(@"数据插入失败");
    }
    if(result)
    {
        result(insertResult);
    }

}
+(void) queryAll:(FMDatabase *)db QueryUserInfoResult:(QueryUserInfoResultBlock)result
{
    FMResultSet *rs=  [db executeQuery:@"SELECT * FROM t_userinfo"];
    UserInfoEntity * userinfo= [[UserInfoEntity alloc] init];
    while ([rs next]) {
        userinfo.Id = [NSNumber numberWithInt:[rs intForColumn:@"id"]];
        userinfo.Age= [NSNumber numberWithInt:[rs intForColumn:@"Age"]];
        userinfo.Avatar= [rs stringForColumn:@"avatar"];
        userinfo.BackgroundPicture= [rs stringForColumn:@"BackgroundPicture"];
        userinfo.Email= [rs stringForColumn:@"Email"];
        userinfo.Gender= [rs stringForColumn:@"Gender"];
        userinfo.Hobbies= [rs stringForColumn:@"Hobbies"];
        userinfo.Location= [rs stringForColumn:@"Location"];
        userinfo.Nickname= [rs stringForColumn:@"Nickname"];
        userinfo.RegisterTime= [rs stringForColumn:@"RegisterTime"];
        userinfo.ShowPhoneNum = [NSNumber numberWithBool:[rs boolForColumn:@"ShowPhoneNum"]];
        userinfo.Signature = [rs stringForColumn:@"Signature"];
        userinfo.WatchStatus = [NSNumber numberWithBool:[rs boolForColumn:@"WatchStatus"]];
    }
    if(result)
    {
        result(userinfo);
    }
}
@end
