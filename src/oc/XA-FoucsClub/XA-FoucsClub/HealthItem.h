//
//  HealthItem.h
//  XA-FoucsClub
//
//  Created by Owen on 15/6/16.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthItem : JSONModel
@property(nonatomic, strong) NSString<Optional> *names;
@property(nonatomic, strong) NSNumber<Optional> *ids;
@end
