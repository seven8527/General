//
//  RegisterDelegate.h
//  Login
//
//  Created by Owen on 15/6/10.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#ifndef Login_RegisterDelegate_h
#define Login_RegisterDelegate_h

@class RegisterViewController;

@protocol registerDelegate <NSObject>

@required
-(void)registed:(RegisterViewController*)sender;

@end

#endif
