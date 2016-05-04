//
//  TEExpertArticle.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-4.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "TEExpertArticleModel.h"

// 专家文章
@interface TEExpertArticle : JSONModel
@property (nonatomic, strong) TEExpertArticleModel *article;
@end
