//
//  MYSFoundationCommon.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-7.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYSFoundationCommon : NSObject
+ (UIImage *)buttonImageFromColor:(UIColor *)color withButton:(UIView *)view;
// 生成图片
+ (UIImage *)imageFromColor:(UIColor *)color withRect:(CGRect)contentRect;
////+ (CGFloat) heightWithFont:(UIFont *)font;

+ (CGSize)sizeWithText:(NSString *)content withFont:(UIFont *)font;

+ (CGSize)sizeWithText:(NSString *)content withFont:(UIFont *) font constrainedToSize:(CGSize)size;

+ (CGFloat)expandCellHeightWithText:(NSString *)text withFont:(UIFont *)font constrainedToSize:(CGSize)size unExpandHeight:(CGFloat)unExpandHeght withOpenStatus:(BOOL)isOpen topHeight:(CGFloat)topHeight andBottomHeight:(CGFloat)bottomHeight andBottomMargin:(CGFloat)bottomMargin;

+ (NSString *)placeHolderImageWithGender:(NSString *)gender andBirthday:(NSString *)birthday;

// 根据生日获得年龄
+ (NSString *)obtainAgeWith:(NSString *)birthday;
@end
