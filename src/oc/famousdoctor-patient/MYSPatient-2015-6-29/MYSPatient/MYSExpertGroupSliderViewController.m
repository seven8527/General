//
//  MYSExpertGroupSliderViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-13.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupSliderViewController.h"
#import "UIColor+Hex.h"
#import "UtilsMacro.h"


@interface MYSExpertGroupSliderViewController ()
@end

@implementation MYSExpertGroupSliderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
//    CGRect frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64 - 44);//如果没有导航栏，则去掉64
    CGRect frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64);//如果没有导航栏，则去掉64
    MYSExpertGroupExpertiseViewController *expertiseVC = [[MYSExpertGroupExpertiseViewController alloc] init];
    expertiseVC.title = @"专长";
    self.expertiseVC = expertiseVC;
    
    MYSExpertGroupDynamicViewController *dynamicVC = [[MYSExpertGroupDynamicViewController alloc] init];
    dynamicVC.title = @"动态";
    self.dynamicVC = dynamicVC;
    
    MYSExpertGroupRecordViewController *recordVC = [[MYSExpertGroupRecordViewController alloc] init];
    recordVC.title = @"案例";
    self.recordVC = recordVC;

    //对应填写两个数组
    NSArray *views =@[expertiseVC.view,dynamicVC.view,recordVC.view];
    NSArray *names =@[@"专长",@"动态",@"案例"];
    //创建使用
    self.scroll =[XLScrollViewer scrollWithFrame:frame withViews:views withButtonNames:names withThreeAnimation:111];//三中动画都选择
    //自定义各种属性。。打开查看
//    self.scroll.xl_topBackImage =[UIImage imageNamed:@"10.jpg"];
    self.scroll.xl_topBackColor =[UIColor colorFromHexRGB:KF6F6F6Color];
    self.scroll.xl_sliderColor =[UIColor colorFromHexRGB:K00907FColor];
    self.scroll.xl_buttonColorNormal =[UIColor colorFromHexRGB:K747474Color];
    self.scroll.xl_buttonColorSelected =[UIColor colorFromHexRGB:K00907FColor];
    self.scroll.xl_buttonFont =15;
    self.scroll.xl_buttonToSlider =20;
    self.scroll.xl_sliderHeight =2;
    self.scroll.xl_topHeight =0.01;
    self.scroll.xl_isSliderCorner =YES;
    
    //加入控制器视图
    [self.view addSubview:self.scroll];

 
}

- (void)setModel:(id)model
{
    _model = model;
    
    self.expertiseVC.model = model;
    
    
    self.dynamicVC.model =model;
}
@end
