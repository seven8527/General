//
//  User.m
//  XA-FoucsClub
//
//  Created by Owen on 15/6/12.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import "User.h"

@implementation User



- (id)copyWithZone:(NSZone *)zone
{
    User *user = [[self class]init];
    user.uid = self.uid;
    user.name = self.name;
    user.pwd = self.pwd;
    user.userPic = self.userPic;
    user.phoneNum = self.phoneNum;
    user.carNum = self.carNum;
    user.carVin = self.carVin;
    user.email= self.email;
    return  user;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
    
     self.uid =[coder decodeObjectForKey:@"_uid"] ;
        self.name=[coder decodeObjectForKey:@"_name"];
        self.pwd=[coder decodeObjectForKey:@"_pwd"];
        self.userPic=[coder decodeObjectForKey:@"_userPic"];
        self.phoneNum=[coder decodeObjectForKey:@"_phoneNum"];
         self.carNum=[coder decodeObjectForKey:@"_carNum"];
        self.carVin=[coder decodeObjectForKey:@"_carVin"];
         self.email=[coder decodeObjectForKey:@"_email"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)coder
{
    
    [coder encodeObject:_uid forKey:@"_uid"];
        [coder encodeObject:_name forKey:@"_name"];
        [coder encodeObject:_pwd forKey:@"_pwd"];
        [coder encodeObject:_userPic forKey:@"_userPic"];
        [coder encodeObject:_phoneNum forKey:@"_phoneNum"];
        [coder encodeObject:_carNum forKey:@"_carNum"];
        [coder encodeObject:_carVin forKey:@"_carVin"];
        [coder encodeObject:_email forKey:@"_email"];
}


@end
