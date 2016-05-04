//
//  TEExpertArticleModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-8.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol TEExpertArticleModel @end

// 专家文章
@interface TEExpertArticleModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *articleId; // 文章Id
@property (nonatomic, strong) NSString<Optional> *title; // 文章标题
@property (nonatomic, strong) NSString<Optional> *author; // 作者
@property (nonatomic, strong) NSString<Optional> *publishTime; // 发布时间
@property (nonatomic, strong) NSString<Optional> *content; // 文章内容
@end
