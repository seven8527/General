//
//  EXGroupNetManager.h
//  Express
//
//  Created by owen on 15/11/27.
//  Copyright © 2015年 owen. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^SuccessBlock) (int resultCode,  id responseObject);
typedef void (^FailureBlock) (NSError *error);


@interface EXGroupNetManager : NSObject

+(void)createGroup:(NSString *)userid
   groupList:(NSMutableArray *) groupArray
     success:(SuccessBlock)success
     failure:(FailureBlock)failure;

+(void)addFriendstoGroup:(NSString *)groupid
                userID :(NSString *)userid
             friendList:(NSMutableArray *) friendList
                success:(SuccessBlock)success
                failure:(FailureBlock)failure;


+(void)removeMembertoGroup:(NSString *)groupid
                   userID :(NSString *)userid
                    Member:(NSString *) member
                   success:(SuccessBlock)success
                   failure:(FailureBlock)failure;


+(void)quitGroup:(NSString *)groupid
         userID :(NSString *)userid
         success:(SuccessBlock)success
         failure:(FailureBlock)failure;


+(void)destroyGroup:(NSString *)groupid
         userID :(NSString *)userid
         success:(SuccessBlock)success
         failure:(FailureBlock)failure;

+(void)getGroupInfoList:(NSString *)groupid
            userID :(NSString *)userid
            success:(SuccessBlock)success
            failure:(FailureBlock)failure;



+(void)configGroupName:groupid
                userID :(NSString *)userid
                groupName:(NSString *)groupName
                success:(SuccessBlock)success
                failure:(FailureBlock)failure;

+(void)setGroupNickname:(NSString *)groupid
                userID :(NSString *)userid
               Nickname:(NSString *)nickname
                success:(SuccessBlock)success
                failure:(FailureBlock)failure;

@end
