//
//  CIFilterEffect.h
//  filter
//
//  Created by Owen on 16/4/28.
//  Copyright (c) 2016年 Owen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//https://developer.apple.com/library/ios/documentation/GraphicsImaging/Reference/CoreImageFilterReference/#//apple_ref/doc/filter/ci/CIMaskedVariableBlu
@interface CIFilterEffect : NSObject

@property (nonatomic, strong) UIImage *result;

- (instancetype)initWithImage:(UIImage *)image filterName:(NSString *)name;

@end
