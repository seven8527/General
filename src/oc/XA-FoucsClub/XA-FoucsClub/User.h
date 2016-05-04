//
//  User.h
//  XA-FoucsClub
//
//  Created by Owen on 15/6/12.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject  <NSCopying>
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *pwd;
@property (nonatomic, strong) NSString *userPic;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) NSString *carNum;
@property (nonatomic, strong) NSString *carVin;

@end
