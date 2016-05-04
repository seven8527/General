//
//  EXGroupNetManager.m
//  Express
//
//  Created by owen on 15/11/27.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "EXGroupNetManager.h"
#import "EXHttpHelper.h"

@implementation EXGroupNetManager

+(void)createGroup:(NSString *)userid
   groupList:(NSMutableArray *) groupArray
     success:(SuccessBlock)success
     failure:(FailureBlock)failure
{

    NSDictionary *parameters = @{@"userName":userid, @"groupUserList":groupArray};
    [EXHttpHelper POST:KACTION_CREATEGROUP deviceType:KDEVICE_TYPE_WT parameters:parameters success:^(int resultCode, id responseObject) {
        if(success)
        {
            success(resultCode, responseObject);
        }

    } failure:^(NSError *error) {
        if(failure)
        {
            failure(error);
        }
    }];
}


+(void)addFriendstoGroup:(NSString *)groupid
                userID :(NSString *)userid
             friendList:(NSMutableArray *) friendList
                success:(SuccessBlock)success
                failure:(FailureBlock)failure
{
    
    NSDictionary *parameters = @{@"groupId":groupid, @"userName":userid, @"friendNameList":friendList};
    [EXHttpHelper POST:KACTION_ADDFRIENDTOGROUP deviceType:KDEVICE_TYPE_WT parameters:parameters success:^(int resultCode, id responseObject) {
        if(success)
        {
            success(resultCode, responseObject);
        }
        
    } failure:^(NSError *error) {
        if(failure)
        {
            failure(error);
        }
    }];
}

+(void)removeMembertoGroup:(NSString *)groupid
                   userID :(NSString *)userid
                    Member:(NSString *) member
                   success:(SuccessBlock)success
                   failure:(FailureBlock)failure
{
    NSDictionary *parameters = @{@"groupId":groupid, @"userName":userid, @"groupMemName":member};
    [EXHttpHelper POST:KACTION_REMOVEMEMBERTOGROUP deviceType:KDEVICE_TYPE_WT parameters:parameters success:^(int resultCode, id responseObject) {
        if(success)
        {
            success(resultCode, responseObject);
        }
        
    } failure:^(NSError *error) {
        if(failure)
        {
            failure(error);
        }
    }];
}




+(void)quitGroup:(NSString *)groupid
         userID :(NSString *)userid
         success:(SuccessBlock)success
         failure:(FailureBlock)failure
{
    NSDictionary *parameters = @{@"groupId":groupid, @"userName":userid};
    [EXHttpHelper POST:KACTION_QUITGROUP deviceType:KDEVICE_TYPE_WT parameters:parameters success:^(int resultCode, id responseObject) {
        if(success)
        {
            success(resultCode, responseObject);
        }
        
    } failure:^(NSError *error) {
        if(failure)
        {
            failure(error);
        }
    }];
}


+(void)destroyGroup:(NSString *)groupid
            userID :(NSString *)userid
            success:(SuccessBlock)success
            failure:(FailureBlock)failure
{
    
    NSDictionary *parameters = @{@"groupId":groupid, @"userName":userid};
    [EXHttpHelper POST:KACTION_DESTROYGROUP deviceType:KDEVICE_TYPE_WT parameters:parameters success:^(int resultCode, id responseObject) {
        if(success)
        {
            success(resultCode, responseObject);
        }
        
    } failure:^(NSError *error) {
        if(failure)
        {
            failure(error);
        }
    }];

}

/**
 *  获取组成员列表
 *  @param groupid  组id 传入空值，查询所有组
 *  @param userid  用户名称
 *  @param success 成功block
 *  @param failure failure block
 */
+(void)getGroupInfoList:(NSString *)groupid
                userID :(NSString *)userid
                success:(SuccessBlock)success
                failure:(FailureBlock)failure
{
     NSDictionary *parameters = @{@"obtainType":groupid==nil?@"all":groupid, @"userName":userid};
    [EXHttpHelper POST:KACTION_GROUP_LIST deviceType:KDEVICE_TYPE_WT parameters:parameters success:^(int resultCode, id responseObject) {
        if(success)
        {
            success(resultCode, responseObject);
        }
        
    } failure:^(NSError *error) {
        if(failure)
        {
            failure(error);
        }
    }];
}

/**
 *  更新群名称
 *
 *  @param userid    userid 用户名
 *  @param groupName groupName 新名称
 *  @param success   success block
 *  @param failure   failure block
 */
+(void)configGroupName:(NSString *)groupid
               userID :(NSString *)userid
             groupName:(NSString *)groupName
               success:(SuccessBlock)success
               failure:(FailureBlock)failure
{
    NSDictionary *parameters = @{@"groupId":groupid, @"userName":userid, @"groupName":groupName};
    [EXHttpHelper POST:KACTION_CONFIGGROUPNAME deviceType:KDEVICE_TYPE_WT parameters:parameters success:^(int resultCode, id responseObject) {
        if(success)
        {
            success(resultCode, responseObject);
        }
        
    } failure:^(NSError *error) {
        if(failure)
        {
            failure(error);
        }
    }];

}

+(void)setGroupNickname:(NSString *)groupid
                userID :(NSString *)userid
               Nickname:(NSString *)nickname
                success:(SuccessBlock)success
                failure:(FailureBlock)failure
{
    NSDictionary *parameters = @{@"groupId":groupid, @"userName":userid, @"inGroupNick":nickname};
    [EXHttpHelper POST:KACTION_SETMEMBERNICKNAME deviceType:KDEVICE_TYPE_WT parameters:parameters success:^(int resultCode, id responseObject) {
        if(success)
        {
            success(resultCode, responseObject);
        }
        
    } failure:^(NSError *error) {
        if(failure)
        {
            failure(error);
        }
    }];
    
}


@end
