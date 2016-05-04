//
//  Utils.h
//  MYSPatient
//
//  Created by lyc on 15/5/15.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (void)showMessage:(NSString *)message;

+ (BOOL)checkCellPhoneNum:(NSString *)phone;

+ (BOOL)checkObjNoNull:(id)obj;

+ (BOOL)checkIsNull:(id)obj;

+ (id)checkObjIsNull:(id)obj;

@end
