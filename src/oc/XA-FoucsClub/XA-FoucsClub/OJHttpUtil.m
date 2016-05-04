//
//  HttpUtil.m
//  Login
//
//  Created by Owen on 15-6-4.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import "OJHttpUtil.h"

@implementation OJHttpUtil

+(void)POST:(NSString *)URLString parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure
{
  
    //获得管理器
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //发送请求
    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
        {
            success(responseObject);
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure)
        {
            failure(error);
        }
    }];
}

+ (void)GET:(NSString *)URLSting parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure
{
    //获得管理器
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //发送请求
    [manager GET:URLSting parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
        {
            
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        {
            if(failure)
                failure(error);
        }
    }];

}

+ (void)GETWITHKEY:(NSString *)URLSting parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure
{
    //获得管理器
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
   [manager.requestSerializer setValue: API_KEY forHTTPHeaderField:@"apikey"];
    
    //发送请求
    [manager GET:URLSting parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
        {
            
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        {
            if(failure)
                failure(error);
        }
    }];
    
}
@end