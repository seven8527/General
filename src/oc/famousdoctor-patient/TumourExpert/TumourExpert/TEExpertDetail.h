//
//  TEExpertDetail.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-8.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "TEExpertDetailModel.h"
#import "TEExpertArticleModel.h"

@interface TEExpertDetail : JSONModel
@property (nonatomic, strong) TEExpertDetailModel *expertDetail;
@property (nonatomic, strong) NSMutableArray<TEExpertArticleModel> *expertArticles;
@end
