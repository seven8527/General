//
//  EXHttpHelper.h
//  Express
//
//  Created by owen on 15/11/4.
//  Copyright © 2015年 owen. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^SuccessBlock) (int resultCode,  id responseObject);
typedef void (^FailureBlock) (NSError *error);

@interface EXHttpHelper : NSObject

+ (BOOL)isExistenceNetwork; //网络状态判断
/**
 *  Post网络请求
 *
 *  @param action  动作
 *  @param deviceType  设备类型 ， MP or WT
 *  @param parameters 参数
 *  @param success    成功后回调
 *  @param failure    失败后回调
 *
 */
+ (void)POST:(NSString *)action
  deviceType:(NSString *)deviceType
  parameters:(id)parameters
     success:(SuccessBlock)success
     failure:(FailureBlock)failure;


/**
 *  get网络请求
 *
 *  @param action  动作
 *  @param parameters 请求参数
 *  @param success    成功后回调的block
 *  @param failure    失败后回调的block
 *
 */
+(void) GET:(NSString*)action
 parameters:(id)parameters
    success:(SuccessBlock)success
    failure:(FailureBlock)failure;


/**
 * 下载文件
 *
 * @param string aUrl 请求文件地址
 * @param string aSavePath 保存地址
 * @param string aFileName 文件名
 *  @param success    成功后回调的block
 *  @param failure    失败后回调的block
 *
 */
+(void)downloadFileURL:(NSString *)aUrl
              savePath:(NSString *)aSavePath
              fileName:(NSString *)aFileName
               success:(SuccessBlock)success
               failure:(FailureBlock)failure;




/**
 * 上传文件
 *
 * @param string aUrl 请求文件地址
 *  @param success    成功后回调的block
 *  @param failure    失败后回调的block
 *
 */
+(void)uploadFileURL:(NSURL *)aUrl
          parameters:(id)parameters
                addr:(NSString *)rootUrl
                name:(NSString *)name
            fileName:(NSString *)fileName
            mimeType:(NSString *)mimeType
             success:(SuccessBlock)success
             failure:(FailureBlock)failure;


+ (void)sessionDownloadWithUrl:(NSString *)urlStr success:(void (^)(NSURL *fileURL))success fail:(void (^)())fail;
@end
