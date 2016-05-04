//
//  TEOrder.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-7.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "TEOrderModel.h"

@interface TEOrder : JSONModel
@property (nonatomic, assign) int total;
@property (nonatomic, strong) NSString<Optional> *state;
@property (nonatomic, strong) NSArray<TEOrderModel> *orders;
@end
