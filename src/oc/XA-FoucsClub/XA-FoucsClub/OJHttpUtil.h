//
//  HttpUtil.h
//  Login
//
//  Created by Owen on 15-6-4.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock) ( id responseObject);
typedef void (^FailureBlock) ( NSError *error);

@interface OJHttpUtil : NSObject
/**
 *  Post网络请求
 *
 *  @param URLString  地址
 *  @param parameters 参数
 *  @param success    成功后回调
 *  @param failure    失败后回调
 *
 */
+ (void)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(SuccessBlock)success
                         failure:(FailureBlock)failure;


/**
 *  get网络请求
 *
 *  @param URLSting   请求地址
 *  @param parameters 请求参数
 *  @param success    成功后回调的block
 *  @param failure    失败后回调的block
 *
 */
+(void) GET:(NSString*)URLSting
                     parameters:(id)parameters
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure;


+ (void)GETWITHKEY:(NSString *)URLSting parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;
@end
