//
//  MYSBaseTableViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-6.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBaseTableViewController.h"
#import "UIColor+Hex.h"

@interface MYSBaseTableViewController ()

@end

@implementation MYSBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航背景
    self.navigationController.navigationBar.backgroundColor = [UIColor colorFromHexRGB:KF6F6F6Color];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeZero;
    // 统一设置标题字体大小、颜色，并去掉文字阴影
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor colorFromHexRGB:K333333Color],
                                                                       NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                                                                       NSShadowAttributeName: shadow}];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (void)loadDataSource {
    // subClasse
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _dataSource;
}

@end
