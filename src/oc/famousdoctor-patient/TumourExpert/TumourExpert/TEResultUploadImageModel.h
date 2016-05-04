//
//  TEResultUploadImageModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-7-23.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

// 上传图片返回的接口
@interface TEResultUploadImageModel : JSONModel
@property (nonatomic, strong) NSString *state; // 服务器返回的状态码
@property (nonatomic, strong) NSString *img_url; // 图片地址
@property (nonatomic, strong) NSString *newurl;

@end
