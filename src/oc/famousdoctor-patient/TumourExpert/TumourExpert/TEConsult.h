//
//  TEConsult.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-6.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "TEConsultModel.h"

@interface TEConsult : JSONModel
@property (nonatomic, assign) int total;
@property (nonatomic, strong) NSArray<TEConsultModel> *consults;
@end
