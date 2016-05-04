//
//  UserEntry.h
//  Login
//
//  Created by Owen on 15-6-4.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import "JSONModel.h"

@interface UserEntry : JSONModel
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *pwd;
@end
