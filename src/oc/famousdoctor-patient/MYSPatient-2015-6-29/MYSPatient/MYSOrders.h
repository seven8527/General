//
//  MYSOrders.h
//  MYSPatient
//
//  Created by 闫文波 on 15-3-5.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "MYSOrderModel.h"

@interface MYSOrders : JSONModel
@property (nonatomic, strong) NSArray<MYSOrderModel>* orders;
@end
