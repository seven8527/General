//
//  MYSPersonalSliderViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-29.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPersonalSliderViewController.h"
#import "UIColor+Hex.h"
#import "MYSMyOrderViewController.h"
#import "MYSMedicalRecordsViewController.h"
#import "MYSFreeConsultationsViewController.h"

@interface MYSPersonalSliderViewController () <XLScrollViewerDelegate>
@property (nonatomic, strong) MYSMyOrderViewController *myOrderVC;
@property (nonatomic, strong) MYSMedicalRecordsViewController *medicalRecordsVC;
@property (nonatomic, strong) MYSFreeConsultationsViewController *freeConsultationsVC;
@end

@implementation MYSPersonalSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame =CGRectMake(0, 0, self.view.frame.size.width, kScreen_Height - 64);//如果没有导航栏，则去掉64
    
    MYSMyOrderViewController *myOrderVC = [[MYSMyOrderViewController alloc] init];
    self.myOrderVC = myOrderVC;
    
    MYSMedicalRecordsViewController *medicalRecordsVC = [[MYSMedicalRecordsViewController alloc] init];
    self.medicalRecordsVC = medicalRecordsVC;
    
    
    MYSFreeConsultationsViewController *freeConsultationsVC = [[MYSFreeConsultationsViewController alloc] init];
    self.freeConsultationsVC = freeConsultationsVC;
    
    
    //对应填写两个数组
    NSArray *views =@[myOrderVC.view,medicalRecordsVC.view,freeConsultationsVC.view];
    NSArray *names =@[@"我的订单",@"就诊记录",@"免费咨询"];
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
    self.scroll.xl_topHeight =44;
    self.scroll.xl_isSliderCorner =NO;
    self.scroll.delegate = self;
    self.scroll.xl_bottomLineWidth = 91;
    self.scroll.selectedIndex = 0;
    //加入控制器视图
    [self.view addSubview:self.scroll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (void)scrollViewerScrolledToPage:(int)page
//{
//    
//}

//- (void)setModel:(id)model
//{
//    _model = model;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
