//
//  MYSSearchSliderViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-3-18.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSSearchSliderViewController.h"

#import "UIColor+Hex.h"

@interface MYSSearchSliderViewController () <XLScrollViewerDelegate,MYSDoctorSearchViewControllerDelegate,MYSDiseaseSearchViewControllerDelegate>
@end

@implementation MYSSearchSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MYSDoctorSearchViewController *doctorSearchVC = [[MYSDoctorSearchViewController alloc] initWithStyle:UITableViewStylePlain];
    self.doctorSearchVC = doctorSearchVC;
    
    MYSDiseaseSearchViewController *diseaseSearchVC = [[MYSDiseaseSearchViewController alloc] initWithStyle:UITableViewStylePlain];
    self.diseaseSearchVC = diseaseSearchVC;
}

- (void)setSearch:(MYSSearch *)search
{
    _search = search;
    
   
    
    CGRect frame =CGRectMake(0, 0, self.view.frame.size.width, kScreen_Height - 100);//如果没有导航栏，则去掉64
    
   
    
    
    //    UITableView *thirdView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStylePlain];
    //    thirdView.backgroundColor = [UIColor purpleColor];
    
    //对应填写两个数组
    NSArray *views =@[self.doctorSearchVC.view,self.diseaseSearchVC.view];
    NSArray *names =@[@"医生",@"疾病"];
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
        if (search.diseaseArray.count > 0 && search.doctorArray.count == 0) {
            self.scroll.selectedIndex = 1;
            [self.scroll addAll];
        } else {
            self.scroll.selectedIndex = 0;
            [self.scroll addAll];
    
        }
    self.doctorSearchVC.doctorTotal = search.doctorTotal;
    self.doctorSearchVC.doctorArray = search.doctorArray;
    
    self.diseaseSearchVC.diseaseArray = search.diseaseArray;
    self.diseaseSearchVC.diseaseTotal = search.diseaseTotal;


    //加入控制器视图
    [self.view addSubview:self.scroll];

}

- (void)setKeyWord:(NSString *)keyWord
{
    _keyWord = keyWord;
    self.doctorSearchVC.searchText = keyWord;
    self.diseaseSearchVC.searchText = keyWord;

}

@end
