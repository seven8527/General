//
//  InfoJSONModel.h
//  XA-FoucsClub
//
//  Created by Owen on 15/6/17.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import "JSONModel.h"

@interface InfoJSONModel : JSONModel
//id                               long                           问题ID
//title                            string                         问题标题
//count                         int                              浏览次数
//scount                       int                              搜索次数
//askclass                     long                           问题分类的id
//classname                  string                         问题分类名称

@property (nonatomic, strong) NSNumber<Optional> * id;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong)  NSNumber<Optional> * count;
@property (nonatomic, strong)  NSNumber<Optional> * scount;
@property (nonatomic, strong)  NSNumber<Optional> * askclass;
@property (nonatomic, strong)  NSString<Optional> * classname;
@property (nonatomic, strong)  NSString<Optional> * content;

@end
