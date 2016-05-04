//
//  TEExpertColumn.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-8.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "TEExpertArticleModel.h"

// 专家专栏
@interface TEExpertColumn : JSONModel
@property (nonatomic, assign) int total;
@property (nonatomic, strong) NSArray<TEExpertArticleModel> *articles; // 文章
@end

