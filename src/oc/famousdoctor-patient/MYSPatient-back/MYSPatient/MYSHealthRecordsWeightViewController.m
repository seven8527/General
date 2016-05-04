//
//  MYSHealthRecordsWeightViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-26.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSHealthRecordsWeightViewController.h"
#import "UIColor+Hex.h"
#import "MYSHealthRecordsWeightChartViewController.h"
#import "MYSHealthRecordsWeightRecordViewController.h"

@interface MYSHealthRecordsWeightViewController ()
@property (nonatomic, strong) MYSHealthRecordsWeightRecordViewController *recordVC;
@property (nonatomic, strong) MYSHealthRecordsWeightChartViewController *chartVC;
@property (nonatomic, weak) UISegmentedControl *segment;
@end

@implementation MYSHealthRecordsWeightViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //    [self findDepartment];
    
    
    self.title = @"体重";
    
    self.view.backgroundColor = [UIColor colorFromHexRGB:KF6F6F6Color];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [rightButton addTarget:self action:@selector(clickRightBarBurron) forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButton setTitle:@"列表" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorFromHexRGB:K9E9E9EColor] forState:UIControlStateNormal];
     [rightButton setTitleColor:[UIColor colorFromHexRGB:K00907FColor] forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"记录", @"趋势", nil]];
    segment.selectedSegmentIndex = 0;
    self.segment = segment;
    [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    segment.tintColor = [UIColor colorFromHexRGB:K00907FColor];
    NSMutableDictionary *selectedAttributes = [NSMutableDictionary dictionary];
    selectedAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    selectedAttributes[NSForegroundColorAttributeName] = [UIColor colorFromHexRGB:KFFFFFFColor];
    [segment setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    NSMutableDictionary *normalAttributes = [NSMutableDictionary dictionary];
    normalAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    normalAttributes[NSForegroundColorAttributeName] = [UIColor colorFromHexRGB:K00907FColor];
    [segment setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
    segment.frame = CGRectMake(9, 64 + 7, [UIScreen mainScreen].bounds.size.width - 18, 29);
    [self.view addSubview:segment];
    
    MYSHealthRecordsWeightChartViewController *chartVC  = [[MYSHealthRecordsWeightChartViewController alloc] init];
    chartVC.view.frame = CGRectMake(0, CGRectGetMaxY(segment.frame) + 7, kScreen_Width, kScreen_Height - CGRectGetMaxY(segment.frame) - 7);
    [self.view addSubview:chartVC.view];
    self.chartVC = chartVC;
    
    
    MYSHealthRecordsWeightRecordViewController *recordVC = [[MYSHealthRecordsWeightRecordViewController alloc] init];
    recordVC.view.frame = CGRectMake(0, CGRectGetMaxY(segment.frame) + 7, kScreen_Width, kScreen_Height - CGRectGetMaxY(segment.frame) - 7);
    [self.view addSubview:recordVC.view];
    self.recordVC = recordVC;
    
}

- (void)segmentClick:(UISegmentedControl *)segment
{
    if (segment.selectedSegmentIndex == 0) {
        self.chartVC.view.hidden = YES;
        self.recordVC.view.hidden = NO;
    } else {
        self.recordVC.view.hidden = YES;
        self.chartVC.view.hidden = NO;
    }
}

// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}


// 列表
- (void)clickRightBarBurron
{
    UIViewController <MYSHealthRecordsWeightListViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSHealthRecordsWeightListViewControllerProtocol)];
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
