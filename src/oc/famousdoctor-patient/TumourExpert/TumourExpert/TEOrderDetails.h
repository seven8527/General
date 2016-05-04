//
//  TEOrderDetails.h
//  TumourExpert
//
//  Created by 闫文波 on 14-10-14.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "TEOrderDetailsModel.h"

@interface TEOrderDetails : JSONModel
@property (nonatomic, strong) NSString<Optional> *state;
@property (nonatomic, strong) TEOrderDetailsModel *orderDetails;
@property (nonatomic, strong) NSString<Optional> *msg;
@end
