//
//  DBUserInfoManager.h
//  Express
//
//  Created by owen on 15/11/20.
//  Copyright © 2015年 owen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoEntity.h"

typedef void (^ResultStatBlock)                         (Boolean result);
typedef void (^QueryUserInfoResultBlock)                (UserInfoEntity * result);  //通过查询结果block


@interface DBUserInfoManager : NSObject
+(void) insert:(UserInfoEntity *) userinfo   FMDatabase:(FMDatabase *)db   InsertResult:(ResultStatBlock)result;
+(void) queryAll:(FMDatabase *)db QueryUserInfoResult:(QueryUserInfoResultBlock)result;
@end
