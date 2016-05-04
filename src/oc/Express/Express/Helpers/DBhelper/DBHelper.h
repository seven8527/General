//
//  DBHelper.h
//  Express
//
//  Created by Owen on 15/11/3.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ExecuteBlock) (FMDatabase *db);

@interface DBHelper : NSObject

+(FMDatabaseQueue *) getShareInstance;
+(void) initDB;
+(void) inTransaction:(ExecuteBlock)sql; //db 提交事务 方法
@end
