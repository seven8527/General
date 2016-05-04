//
//  DetailViewController.h
//  BigNews
//
//  Created by owen on 15/8/17.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import "ViewController.h"

@interface DetailViewController : BNBaseViewController <UITableViewDelegate, UITableViewDataSource >

@property (nonatomic, strong) NSString * navTitle;
@property (nonatomic, strong) NSString * root_url;
@property (nonatomic, strong) NSString * path;
@end
