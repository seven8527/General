//
//  ViewController.m
//  Filter
//
//  Created by owen on 16/4/29.
//  Copyright © 2016年 owen. All rights reserved.
//

#import "ViewController.h"
#import "CIFilterEffect.h"
//获取设备屏幕尺寸
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()
{
    NSMutableDictionary *dic;
    UIImageView * frameView ;
}




@end

@implementation ViewController
{
    NSInteger  index ;
    UIImageView * imageView;
    NSArray * filterNameArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self initView];
}

- (void)initView
{
//    filterNameArr = [[NSArray alloc]initWithObjects:@"CIBoxBlur", @"CIAffineClamp", @"CIAffineTile", @"CIAffineTransform", @"CIBarsSwipeTransition", @"CIBlendWithAlphaMask", @"CIBlendWithMask", @"CIBloom", @"CIBumpDistortion", @"CIBumpDistortionLinear", @"CICheckerboardGenerator", @"CICircleSplashDistortion", @"CICircularScreen", @"CIColorBlendMode", @"CIColorBurnBlendMode", @"CIColorClamp", @"CIColorControls", @"CIColorCrossPolynomial", @"CIColorCube", @"CIColorCubeWithColorSpace", @"CIColorDodgeBlendMode", @"CIColorInvert", @"CIColorMap", @"CIColorMatrix", @"CIColorMonochrome", @"CIColorPolynomial", @"CIColorPosterize", @"CIConstantColorGenerator", @"CIConvolution3X3", @"CIConvolution5X5", @"CIConvolution9Horizontal", @"CIConvolution9Vertical", @"CICopyMachineTransition", @"CICrop", @"CIDarkenBlendMode", @"CIDifferenceBlendMode", @"CIDisintegrateWithMaskTransition", @"CIDissolveTransition", @"CIDotScreen", @"CIEightfoldReflectedTile", @"CIExclusionBlendMode", @"CIExposureAdjust", @"CIFalseColor", @"CIFlashTransition", @"CIFourfoldReflectedTile", @"CIFourfoldRotatedTile", @"CIFourfoldTranslatedTile", @"CIGammaAdjust", @"CIGaussianBlur", @"CIGaussianGradient", @"CIGlideReflectedTile", @"CIGloom", @"CIHardLightBlendMode", @"CIHatchedScreen", @"CIHighlightShadowAdjust", @"CIHoleDistortion", @"CIHueAdjust", @"CIHueBlendMode", @"CILanczosScaleTransform", @"CILightenBlendMode", @"CILightTunnel", @"CILinearGradient", @"CILinearToSRGBToneCurve", @"CILineScreen", @"CILuminosityBlendMode", @"CIMaskToAlpha", @"CIMaximumComponent", @"CIMaximumCompositing", @"CIMinimumComponent", @"CIMinimumCompositing", @"CIModTransition", @"CIMultiplyBlendMode", @"CIMultiplyCompositing", @"CIOverlayBlendMode", @"CIPhotoEffectChrome", @"CIPhotoEffectFade", @"CIPhotoEffectInstant", @"CIPhotoEffectMono", @"CIPhotoEffectNoir", @"CIPhotoEffectProcess", @"CIPhotoEffectTonal", @"CIPhotoEffectTransfer", @"CIPinchDistortion", @"CIPixellate", @"CIQRCodeGenerator", @"CIRadialGradient", @"CIRandomGenerator", @"CISaturationBlendMode", @"CIScreenBlendMode", @"CISepiaTone", @"CISharpenLuminance", @"CISixfoldReflectedTile", @"CISixfoldRotatedTile", @"CISmoothLinearGradient", @"CISoftLightBlendMode", @"CISourceAtopCompositing", @"CISourceInCompositing", @"CISourceOutCompositing", @"CISourceOverCompositing", @"CISRGBToneCurveToLinear", @"CIStarShineGenerator", @"CIStraightenFilter", @"CIStripesGenerator", @"CISwipeTransition", @"CITemperatureAndTint", @"CIToneCurve", @"CITriangleKaleidoscope", @"CITwelvefoldReflectedTile", @"CITwirlDistortion", @"CIUnsharpMask", @"CIVibrance", @"CIVignette", @"CIVignetteEffect", @"CIVortexDistortion", @"CIWhitePointAdjust", nil];
    
    
 
    

    
//    [self.view setFrame:CGRectMake(0, 0, [UIImage imageNamed:@"IMG_2615"].size.width+34, [UIImage imageNamed:@"IMG_2615"].size.height+34)];
//    UIImageView * bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    
   imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
   CGRect rect = [self getFrameSizeForImage:[UIImage imageNamed:@"IMG_2615"] inImageView:imageView];
    [imageView setFrame:rect];
    [self.view addSubview:imageView];

    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setImage:[UIImage imageNamed:@"IMG_2615"]];

    
    
    
    
    _button = [[UIButton alloc]initWithFrame:CGRectMake( SCREEN_WIDTH/2-25,SCREEN_HEIGHT-60, 80, 40)];
    [_button setTintColor:[UIColor blueColor]];
    [_button setBackgroundColor:[UIColor blueColor]];
    [_button setTitle:@"下一个" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    index =0;
    
 
    dic =[[NSMutableDictionary alloc]init];
    NSArray *frame01_size = [NSArray arrayWithObjects:[NSNumber numberWithFloat:56.0/3.0],[NSNumber numberWithFloat:56.0/3.0],[NSNumber numberWithFloat:56.0/3.0],[NSNumber numberWithFloat:56.0/3.0],[NSNumber numberWithFloat:4.0/3.0],[NSNumber numberWithFloat:4.0/3.0], nil];
    [dic setValue:frame01_size forKey:@"frame01"];
    
    
    NSArray *frame02_size = [NSArray arrayWithObjects:[NSNumber numberWithFloat:660.0/3.0],[NSNumber numberWithFloat:448.0/3.0],[NSNumber numberWithFloat:80.0/3.0],[NSNumber numberWithFloat:80.0/3.0],[NSNumber numberWithFloat:2.0/3.0],[NSNumber numberWithFloat:2.0/3.0], nil];
    [dic setValue:frame02_size forKey:@"frame02"];
    
    NSArray *frame03_size = [NSArray arrayWithObjects:[NSNumber numberWithFloat:37.0/3.0],[NSNumber numberWithFloat:38.0/3.0],[NSNumber numberWithFloat:53.0/3.0],[NSNumber numberWithFloat:62.0/3.0],[NSNumber numberWithFloat:45.0/3.0],[NSNumber numberWithFloat:45.0/3.0], nil];
    [dic setValue:frame03_size forKey:@"frame03"];
    
    NSArray *frame04_size = [NSArray arrayWithObjects:[NSNumber numberWithFloat:118.0/3.0],[NSNumber numberWithFloat:76.0/3.0],[NSNumber numberWithFloat:61.0/3.0],[NSNumber numberWithFloat:134.0/3.0],[NSNumber numberWithFloat:45.0/3.0],[NSNumber numberWithFloat:45.0/3.0], nil];
    [dic setValue:frame04_size forKey:@"frame04"];
    
    
    NSArray *frame05_size = [NSArray arrayWithObjects:[NSNumber numberWithFloat:103.0/3.0],[NSNumber numberWithFloat:100.0/3.0],[NSNumber numberWithFloat:103.0/3.0],[NSNumber numberWithFloat:100.0/3.0],[NSNumber numberWithFloat:4.0/3.0],[NSNumber numberWithFloat:90.0/3.0], nil];
    [dic setValue:frame05_size forKey:@"frame05"];

    NSArray *frame06_size = [NSArray arrayWithObjects:[NSNumber numberWithFloat:70.0/3.0],[NSNumber numberWithFloat:70.0/3.0],[NSNumber numberWithFloat:70.0/3.0],[NSNumber numberWithFloat:70.0/3.0],[NSNumber numberWithFloat:52.0/3.0],[NSNumber numberWithFloat:52.0/3.0], nil];
    [dic setValue:frame06_size forKey:@"frame06"];
    

    
}

     
     
-(CGRect)getFrameSizeForImage:(UIImage *)image inImageView:(UIImageView *)imageView {
         
         float hfactor = image.size.width / imageView.frame.size.width;
         float vfactor = image.size.height / imageView.frame.size.height;
         
         float factor = fmax(hfactor, vfactor);
         
         // Divide the size by the greater of the vertical or horizontal shrinkage factor
         float newWidth = image.size.width / factor;
         float newHeight = image.size.height / factor;
         
         // Then figure out if you need to offset it to center vertically or horizontally
         float leftOffset = (imageView.frame.size.width - newWidth) / 2;
         float topOffset = (imageView.frame.size.height - newHeight) / 2;
         
    return CGRectMake(leftOffset, topOffset, newWidth, newHeight);
}
     
-(void)btnAction:(id)sender
{
    
    //@"CILinearToSRGBToneCurve",
    //@"CIPhotoEffectChrome",
    //@"CIPhotoEffectFade",
    //@"CIPhotoEffectInstant",
    //@"CIPhotoEffectMono",
    //@"CIPhotoEffectNoir",
    //@"CIPhotoEffectProcess",
    //@"CIPhotoEffectTonal",
    //@"CIPhotoEffectTransfer",
    //@"CISRGBToneCurveToLinear",
    //@"CIVignetteEffect",
    //@"CIPixellate";//马赛克
    //@"CIBoxBlur" //模糊化
    NSArray * frame_size ;
    NSString * frame_name;
    index++;
    if (index <=6) {
        switch (index) {
              
            case 1:
                frame_name = @"frame01";
                break;
            case 2:
                frame_name = @"frame02";
                break;
            case 3:
                frame_name = @"frame03";
                break;
            case 4:
                frame_name = @"frame04";
                break;
            case 5:
                frame_name = @"frame05";
                break;
            case 6:
                frame_name = @"frame06";
                break;
        }
        
        
        //移除边框
        [frameView removeFromSuperview];
        
        frame_size = [dic  objectForKey:frame_name ];
        UIEdgeInsets insets = UIEdgeInsetsMake([frame_size[0] floatValue], [frame_size[1] floatValue], [frame_size[2] floatValue], [frame_size[3] floatValue]);
        UIImage *bubble = [UIImage imageNamed:frame_name];
        frameView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
        [frameView setImage:[bubble resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile]];
        [imageView addSubview:frameView];
        
        //截图
        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, NO, 0.0);
        [imageView drawViewHierarchyInRect:CGRectMake(0, 0, imageView.bounds.size.width, imageView.bounds.size.height) afterScreenUpdates:YES];
        UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(image1,self, nil, nil);
        


    }
    else{
        index = 0;
        [imageView setImage:[UIImage imageNamed:@"IMG_2615"]];
    }
    
    
    return;
//    FILTERTYPE filterName ;
//    index++;
//    if (index <=9) {
//        switch (index) {
//    
//            case 2:
//                filterName = CIPhotoEffectChrome;//铬黄
//                break;
//            case 3:
//            {
//                filterName = CIPhotoEffectFade; //褪色
//                UIGraphicsBeginImageContextWithOptions(CGSizeMake([UIImage imageNamed:@"IMG_2615"].size.width, [UIImage imageNamed:@"IMG_2615"].size.height),NO, 0.0);
//                [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//                UIImage *image1=UIGraphicsGetImageFromCurrentImageContext();
//                UIGraphicsEndImageContext();
//                UIImageWriteToSavedPhotosAlbum(image1,self, nil, nil);
//            }
//                break;
//            case 4:
//                filterName = CIPhotoEffectInstant;//怀旧
//                break;
//                
//            case 5:
//                filterName = CIPhotoEffectMono; //单色
//                break;
//                
//            case 6:
//                filterName = CIPhotoEffectNoir;//黑白
//                break;
//            case 7:
//                filterName = CIPhotoEffectProcess; //冲印
//                break;
//            case 8:
//                filterName = CIPhotoEffectTonal;//色调
//                index = 0;
//                break;
//            case 9:
//                filterName = CIPhotoEffectTransfer;//岁月
//                break;
////            case 10:
////                filterName = @"CIVignetteEffect";
//                break;
////            case 11:
////                filterName = @"CIDotScreen";
//                break;
//            default:
//                break;
//        }
////    if (filterNameArr.count >=index) {
////        filterName = [filterNameArr objectAtIndex:index];
////    }
//        CIFilterEffect * ciFilterEffect=  [[CIFilterEffect alloc]initWithImage:[UIImage imageNamed:@"IMG_2615"] filterType:filterName ];
//        [image setImage:ciFilterEffect.result];
//    }
//    else{
//        index = 0;
//        [image setImage:[UIImage imageNamed:@"IMG_2615"]];
//    }
    
}
//- (BOOL)prefersStatusBarHidden
//{
//    // iOS7后,[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
//    return YES;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
