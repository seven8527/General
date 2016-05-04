//
//  MYSPersonalOrderDetails.h
//  MYSPatient
//
//  Created by 闫文波 on 15-3-5.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "MYSPersonalOrderDetailsModel.h"

@interface MYSPersonalOrderDetails : JSONModel
@property (nonatomic, strong) NSString<Optional> *state;
@property (nonatomic, strong) MYSPersonalOrderDetailsModel *orderDetails;
@property (nonatomic, strong) NSString<Optional> *msg;
@end
