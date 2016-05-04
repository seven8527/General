//
//  MYSUploadImageResultModel.h
//  MYSPatient
//
//  Created by 闫文波 on 15-3-10.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
// 上传图片返回的接口
@interface MYSUploadImageResultModel : JSONModel
@property (nonatomic, strong) NSString *state; // 服务器返回的状态码
@property (nonatomic, strong) NSString *img_url; // 图片地址
@property (nonatomic, strong) NSString *newurl;
@end
