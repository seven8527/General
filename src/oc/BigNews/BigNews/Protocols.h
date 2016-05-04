//
//  Protocols.h
//  BigNews
//
//  Created by Owen on 15-8-13.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#ifndef BigNews_Protocols_h
#define BigNews_Protocols_h


// tests
@protocol BNViewControllerProtocol <NSObject>

@end


//首页
@protocol BNHomeViewControllerProtocol <NSObject>

@end

//设置
@protocol BNSettingViewControllerProtocol <NSObject>

@end

//热门
@protocol BNHotsViewControllerProtocol <NSObject>

@end


//热门
@protocol BNListOfNewsViewControllerProtocol <NSObject>

@end

//详情
@protocol DetailViewControllerProtocol <NSObject>

@end
// base controller
//@protocol BNBaseViewControllerProtocol <NSObject>
//
//-(void) setTitle;
//@end
#endif
