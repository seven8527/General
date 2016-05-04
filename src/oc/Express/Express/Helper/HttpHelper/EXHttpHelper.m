//
//  EXHttpHelper.m
//  Express
//
//  Created by owen on 15/11/4.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "EXHttpHelper.h"
#import "AppDelegate.h"

@implementation EXHttpHelper

static NSString * APIVERSION = @"1.0";
/***
 * 此函数用来判断是否网络连接服务器正常
 * 需要导入Reachability类
 */
+ (BOOL)isExistenceNetwork
{
    BOOL isExistenceNetwork;
    Reachability *reachability = [Reachability reachabilityWithHostname:KROOT_PATH];  // 测试服务器状态
    
    switch([reachability currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = FALSE;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = TRUE;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = TRUE;
            break;
    }
    return  isExistenceNetwork;
}

+(void)POST:(NSString *)action deviceType:(NSString *)deviceType parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure
{
    
    //获得管理器 设置请求和回应都为json类型
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval  = 40.0f;
    
    //http 头设置
    [manager.requestSerializer setValue:deviceType forHTTPHeaderField:@"Device-Type"];
    [manager.requestSerializer setValue:action forHTTPHeaderField:@"Action"];
    [manager.requestSerializer setValue:APIVERSION forHTTPHeaderField:@"APIVersion"];
    [manager.requestSerializer setValue:@"14684874548785457" forHTTPHeaderField:@"UUID"];
    [manager.requestSerializer setValue:APPDELEGATE.UserID forHTTPHeaderField:@"UserID"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //除了登陆和注册，其余请求都需要SessionID字段
    if (![action isEqualToString:KACTION_LOGIIN]&&![action isEqualToString:@"register"]) {
        [manager.requestSerializer setValue:APPDELEGATE.userSessionID forHTTPHeaderField:@"SessionID"];
    }
    
    //发送请求
    [manager POST:KROOT_PATH parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)operation.response;
        int code =  [response.allHeaderFields[@"Result-Code"] intValue];
//        NSLog(@"resultCode=%d, json = %@",code, responseObject);
        if(success)
        {
            success(code, responseObject);
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure)
        {
            failure(error);
        }
    }];
}

+ (void)GET:(NSString *)action parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure
{
    //获得管理器
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //发送请求
    [manager GET:KROOT_PATH parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)operation.response;
        int code =  [response.allHeaderFields[@"Result-Code"] intValue];
//        NSLog(@"%d", code);
        if(success)
        {
            success(code, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        {
            if(failure)
                failure(error);
        }
    }];
    
}



+ (void)sessionDownloadWithUrl:(NSString *)urlStr success:(void (^)(NSURL *fileURL))success fail:(void (^)())fail
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    NSString *urlString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        // 指定下载文件保存的路径
        //        NSLog(@"%@ %@", targetPath, response.suggestedFilename);
        // 将下载文件保存在缓存路径中
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
        
        // URLWithString返回的是网络的URL,如果使用本地URL,需要注意
        //        NSURL *fileURL1 = [NSURL URLWithString:path];
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        
        //        NSLog(@"== %@ |||| %@", fileURL1, fileURL);
        if (success) {
            success(fileURL);
        }
        
        return fileURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"%@ %@", filePath, error);
        if (fail) {
            fail();
        }
    }];
    
    [task resume];
}

+(void)downloadFileURL:(NSString *)aUrl savePath:(NSString *)aSavePath fileName:(NSString *)aFileName success:(SuccessBlock)success failure:(FailureBlock)failure{
    
        if(aSavePath==nil)
        {
             NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
            aSavePath = cacheDir;
        }
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //检查本地文件是否已存在
        NSString *fileName = [NSString stringWithFormat:@"%@/%@", aSavePath, aFileName];
        //检查附件是否存在
        if ([fileManager fileExistsAtPath:fileName]) {
//            NSData *data = [NSData dataWithContentsOfFile:fileName];
            if(success)
            {
                success(0, fileName);
            }
            //            [self requestFinished:[NSDictionary dictionaryWithObject:data forKey:@"res"] tag:nil];
        }else{
            //创建附件存储目录
            if (![fileManager fileExistsAtPath:aSavePath]) {
                [fileManager createDirectoryAtPath:aSavePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            //下载附件
            NSURL *url = [[NSURL alloc] initWithString:aUrl];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            operation.inputStream   = [NSInputStream inputStreamWithURL:url];
            operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:fileName append:YES];
            
            //下载进度控制
            /*
             [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
             NSLog(@"is download：%f", (float)totalBytesRead/totalBytesExpectedToRead);
             }];
             */
            
            //已完成下载
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSData *data = [NSData dataWithContentsOfFile:fileName];
                if(success)
                {
                    success(0, fileName);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {                
                //下载失败  
                if(failure)
                    failure(error);
            }];
            [operation start];  
    }
    
}



+(void)uploadFileURL:(NSURL *)aUrl
            parameters:(id)parameters
            addr:(NSString *)rootUrl
            name:(NSString *)name
            fileName:(NSString *)fileName
            mimeType:(NSString *)mimeType
            success:(SuccessBlock)success
            failure:(FailureBlock)failure
{
    //创建请求管理类
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.requestSerializer  = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:APPDELEGATE.UserID forHTTPHeaderField:@"User-Name"];
    //发送请求
    [manager POST:rootUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> totalformData) {
         NSData *data = [NSData dataWithContentsOfFile:[aUrl absoluteString]];
        [totalformData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {        //成功回调
//        NSHTTPURLResponse *response = (NSHTTPURLResponse *)operation.response;
        if(success)
        {
            success(0, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //失败回调
        if(failure)
            failure(error);

    } ];

}


@end
