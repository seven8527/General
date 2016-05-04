//
//  TEHttpTools.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-12-3.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEHttpTools.h"
#import <AFNetworking/AFNetworking.h>

@implementation TEHttpTools

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1. 获得请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager  manager];
    
    // 2. 发送Get请求
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1. 获得请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager  manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    // 2. 发送Post请求
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
