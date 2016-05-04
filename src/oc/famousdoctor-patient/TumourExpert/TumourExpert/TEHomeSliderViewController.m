//
//  TEHomeSliderViewController.m
//  TumourExpert
//
//  Created by 闫文波 on 14-9-30.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEHomeSliderViewController.h"
#import "TERecommendExpertViewController.h"
#import "TEHealthInformationViewController.h"
#import "TEExpertedColumnViewController.h"
#import "UIColor+Hex.h"

@interface TEHomeSliderViewController () <ViewPagerDataSource, ViewPagerDelegate>
@property (nonatomic, strong) TERecommendExpertViewController *recommendExpertVC;
@property (nonatomic, strong) TEHealthInformationViewController *healthInformationVC;
@property (nonatomic, strong) TEExpertedColumnViewController *expertedColumnVC;
@end

@implementation TEHomeSliderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.dataSource = self;
    self.delegate = self;

    
    TERecommendExpertViewController *recommendExpertVC = [[TERecommendExpertViewController alloc] init];
    recommendExpertVC.title = @"推荐专家";
    self.recommendExpertVC = recommendExpertVC;
    
    TEHealthInformationViewController *healthInformationVC = [[TEHealthInformationViewController alloc] init];
    healthInformationVC.title = @"健康资讯";
    self.healthInformationVC = healthInformationVC;
    
    TEExpertedColumnViewController *expertedColumnVC = [[TEExpertedColumnViewController alloc] init];
    expertedColumnVC.title = @"专家专栏";
    self.expertedColumnVC = expertedColumnVC;

    
    [super viewDidLoad];

}


#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 3;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.0];
    if (index == 0) {
        label.text = @"推荐专家";
    } else if(index == 1) {
        label.text = @"健康资讯";
    } else  if (index == 2){
        label.text = @"专家专栏";
    }

    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    UITableViewController *vc  = nil;
    
    switch (index) {
        case 0:
            vc = (UITableViewController *)self.recommendExpertVC;
            break;
        case 1:
            vc = (UITableViewController *)self.healthInformationVC;
            break;
        case 2:
            vc = (UITableViewController *)self.expertedColumnVC;
            break;
        default:
            break;
    }
    return vc;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
            break;
        case ViewPagerOptionTabLocation:
            return 1.0;
            break;
        default:
            break;
    }
    
    return value;
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_line_green"]] colorWithAlphaComponent:0.64];
            break;
        case ViewPagerTabsView:
            return [UIColor colorWithHex:0xfafafa];
            break;
        case ViewPagerContent:
            return [[UIColor whiteColor] colorWithAlphaComponent:0.64];
            break;
        default:
            break;
    }
    
    return color;
}

- (void)setExpers:(NSArray *)expers
{
    _expers = expers;
    
    self.recommendExpertVC.experts = expers;
}

- (void)setHealthInfos:(NSArray *)healthInfos
{
    _healthInfos = healthInfos;
    
    self.healthInformationVC.healthInfos = healthInfos;
}

- (void)setExpertColumns:(NSArray *)expertColumns
{
    _expertColumns = expertColumns;
    
    self.expertedColumnVC.expertColumns = expertColumns;
}

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index
{
    NSLog(@"%d",index);
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",index]  forKey:@"index"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"homeSliderChange" object:nil userInfo:userInfo];
//    if (index == 0) {
//        [self.recommendExpertVC.tableView reloadData];
//    } else if (index == 1) {
//        [self.healthInformationVC.tableView reloadData];
//    } else {
//        [self.expertedColumnVC.tableView reloadData];
//    }
    
}



@end
