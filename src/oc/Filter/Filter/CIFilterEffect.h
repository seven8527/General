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


typedef enum{
    CIPhotoEffectChrome = 1,//铬黄
    CIPhotoEffectFade ,//褪色
    CIPhotoEffectInstant,//怀旧
    CIPhotoEffectMono, //单色
    CIPhotoEffectNoir,//黑白
    CIPhotoEffectProcess, //冲印
    CIPhotoEffectTonal,//色调
    CIPhotoEffectTransfer,//岁月
}FILTERTYPE;


@interface CIFilterEffect : NSObject

@property (nonatomic, strong) UIImage *result;

- (instancetype)initWithImage:(UIImage *)image filterType:(FILTERTYPE)type;

@end
