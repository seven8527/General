//
//  Answer.h
//  XA-FoucsClub
//
//  Created by Owen on 15/6/16.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import "JSONModel.h"

@interface Answer : JSONModel
//id                               long                           答案ID
//topcount                    int                             答案置顶数（暂且没有）
//message                     string/text                 答案内容

@property (nonatomic, assign)NSNumber<Optional> *id;
@property (nonatomic, assign)NSNumber<Optional> *topcount;
@property (nonatomic, assign)NSString<Optional> *message;
@end
