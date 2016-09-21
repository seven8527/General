//
//  CIFilterEffect.m
//  filter
//
//  Created by Owen on 16/4/28.
//  Copyright (c) 2016年 Owen. All rights reserved.
//

#import "CIFilterEffect.h"


//@"CIPhotoEffectChrome";//铬黄
//@"CIPhotoEffectFade"; //褪色
//@"CIPhotoEffectInstant";//怀旧
//@"CIPhotoEffectMono"; //单色
//@"CIPhotoEffectNoir";//黑白
//@"CIPhotoEffectProcess"; //冲印
//@"CIPhotoEffectTonal";//色调
//@"CIPhotoEffectTransfer";//岁月



@implementation CIFilterEffect

- (instancetype)initWithImage:(UIImage *)image filterType:(FILTERTYPE)type
{
   
    if (self = [super init])
    {
        NSString * name  = nil;
        switch (type) {
            case CIPhotoEffectChrome:
                name = @"CIPhotoEffectChrome";
                break;
            case CIPhotoEffectFade:
                name = @"CIPhotoEffectFade";
                break;
            case CIPhotoEffectInstant:
                name = @"CIPhotoEffectInstant";
                break;
            case CIPhotoEffectMono:
                name = @"CIPhotoEffectMono";
                break;
            case CIPhotoEffectNoir:
                name = @"CIPhotoEffectNoir";
                break;
            case CIPhotoEffectProcess:
                name = @"CIPhotoEffectProcess";
                break;
            case CIPhotoEffectTonal:
                name = @"CIPhotoEffectTonal";
                break;
            case CIPhotoEffectTransfer:
                name = @"CIPhotoEffectTransfer";
                break;
            default:
                break;
        }
        
        CIImage *ciImage = [[CIImage alloc] initWithImage:image];
        CIFilter *filter = [CIFilter filterWithName:name keysAndValues:kCIInputImageKey, ciImage, nil];  //创建滤镜
//        [filter setDefaults];
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *outputImage = [filter outputImage]; //渲染并输出CIImage
        CGImageRef cgImage = [context createCGImage:outputImage  fromRect:[outputImage extent]];
        _result = [UIImage imageWithCGImage:cgImage scale:1.0 orientation:image.imageOrientation];
        CGImageRelease(cgImage);
    }
    return self;
}
@end
