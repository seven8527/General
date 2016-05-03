//
//  ViewController.m
//  jackQ
//
//  Created by owen on 16/5/3.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:@"http://app.seven.netai.net/myfirst.php?format=json" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSLog(@"JSON: %@", dic);

    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
