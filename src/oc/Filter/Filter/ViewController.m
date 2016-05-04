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



@end

@implementation ViewController
{
    NSInteger  index ;
    UIImageView * image;
    NSArray * filterNameArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView
{
    filterNameArr = [[NSArray alloc]initWithObjects:@"CIAdditionCompositing", @"CIAffineClamp", @"CIAffineTile", @"CIAffineTransform", @"CIBarsSwipeTransition", @"CIBlendWithAlphaMask", @"CIBlendWithMask", @"CIBloom", @"CIBumpDistortion", @"CIBumpDistortionLinear", @"CICheckerboardGenerator", @"CICircleSplashDistortion", @"CICircularScreen", @"CIColorBlendMode", @"CIColorBurnBlendMode", @"CIColorClamp", @"CIColorControls", @"CIColorCrossPolynomial", @"CIColorCube", @"CIColorCubeWithColorSpace", @"CIColorDodgeBlendMode", @"CIColorInvert", @"CIColorMap", @"CIColorMatrix", @"CIColorMonochrome", @"CIColorPolynomial", @"CIColorPosterize", @"CIConstantColorGenerator", @"CIConvolution3X3", @"CIConvolution5X5", @"CIConvolution9Horizontal", @"CIConvolution9Vertical", @"CICopyMachineTransition", @"CICrop", @"CIDarkenBlendMode", @"CIDifferenceBlendMode", @"CIDisintegrateWithMaskTransition", @"CIDissolveTransition", @"CIDotScreen", @"CIEightfoldReflectedTile", @"CIExclusionBlendMode", @"CIExposureAdjust", @"CIFalseColor", @"CIFlashTransition", @"CIFourfoldReflectedTile", @"CIFourfoldRotatedTile", @"CIFourfoldTranslatedTile", @"CIGammaAdjust", @"CIGaussianBlur", @"CIGaussianGradient", @"CIGlideReflectedTile", @"CIGloom", @"CIHardLightBlendMode", @"CIHatchedScreen", @"CIHighlightShadowAdjust", @"CIHoleDistortion", @"CIHueAdjust", @"CIHueBlendMode", @"CILanczosScaleTransform", @"CILightenBlendMode", @"CILightTunnel", @"CILinearGradient", @"CILinearToSRGBToneCurve", @"CILineScreen", @"CILuminosityBlendMode", @"CIMaskToAlpha", @"CIMaximumComponent", @"CIMaximumCompositing", @"CIMinimumComponent", @"CIMinimumCompositing", @"CIModTransition", @"CIMultiplyBlendMode", @"CIMultiplyCompositing", @"CIOverlayBlendMode", @"CIPhotoEffectChrome", @"CIPhotoEffectFade", @"CIPhotoEffectInstant", @"CIPhotoEffectMono", @"CIPhotoEffectNoir", @"CIPhotoEffectProcess", @"CIPhotoEffectTonal", @"CIPhotoEffectTransfer", @"CIPinchDistortion", @"CIPixellate", @"CIQRCodeGenerator", @"CIRadialGradient", @"CIRandomGenerator", @"CISaturationBlendMode", @"CIScreenBlendMode", @"CISepiaTone", @"CISharpenLuminance", @"CISixfoldReflectedTile", @"CISixfoldRotatedTile", @"CISmoothLinearGradient", @"CISoftLightBlendMode", @"CISourceAtopCompositing", @"CISourceInCompositing", @"CISourceOutCompositing", @"CISourceOverCompositing", @"CISRGBToneCurveToLinear", @"CIStarShineGenerator", @"CIStraightenFilter", @"CIStripesGenerator", @"CISwipeTransition", @"CITemperatureAndTint", @"CIToneCurve", @"CITriangleKaleidoscope", @"CITwelvefoldReflectedTile", @"CITwirlDistortion", @"CIUnsharpMask", @"CIVibrance", @"CIVignette", @"CIVignetteEffect", @"CIVortexDistortion", @"CIWhitePointAdjust", nil];
    
    image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-120)];
    [self.view addSubview:image];
    [image setImage:[UIImage imageNamed:@"img_base"]];
    
    _button = [[UIButton alloc]initWithFrame:CGRectMake( SCREEN_WIDTH/2-25,SCREEN_HEIGHT-100, 80, 40)];
    [_button setTintColor:[UIColor blueColor]];
    [_button setBackgroundColor:[UIColor blueColor]];
    [_button setTitle:@"下一个" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    
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
    
    NSString * filterName ;
    index++;
    if (index <=11) {
        switch (index) {
            case 1:
                filterName = @"CIColorCube";
                break;
            case 2:
                filterName = @"CIPhotoEffectChrome";
                break;
                
            case 3:
                filterName = @"CIPhotoEffectFade";
                break;
                
            case 4:
                filterName = @"CIPhotoEffectInstant";
                break;
                
            case 5:
                filterName = @"CIPhotoEffectMono";
                break;
                
            case 6:
                filterName = @"CIPhotoEffectNoir";
                break;
            case 7:
                filterName = @"CIPhotoEffectProcess";
                break;
            case 8:
                filterName = @"CIPhotoEffectTonal";
                break;
            case 9:
                filterName = @"CISRGBToneCurveToLinear";
                break;
            case 10:
                filterName = @"CIVignetteEffect";
                break;
            case 11:
                filterName = @"CIDotScreen";
                break;
            default:
                break;
        }
//    if (filterNameArr.count >=index) {
//        filterName = [filterNameArr objectAtIndex:index];
//    }
        CIFilterEffect * ciFilterEffect=  [[CIFilterEffect alloc]initWithImage:[UIImage imageNamed:@"img_base"] filterName:filterName ];
        [image setImage:ciFilterEffect.result];
    }
    else{
        index = 0;
        [image setImage:[UIImage imageNamed:@"img_base"]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
