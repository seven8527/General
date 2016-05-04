//
//  TETriageViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-18.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TETriageViewController.h"
#import "TEUITools.h"
#import "TEAssistant.h"
#import "TEHttpTools.h"

@interface TETriageViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *assistants;
@end

@implementation TETriageViewController

#pragma mark - UIViewController lifecycle

- (void) viewDidLoad
{
    _assistants = [NSMutableArray array];
    
    [self layoutUI];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_assistants removeAllObjects];
            [self fetchAssistant];
        });
    };
    
    [reach startNotifier];
}

#pragma mark - UI

// UI布局
- (void)layoutUI
{
    // Create a UITableView
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [TEUITools hiddenTableExtraCellLine:self.tableView];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return [self.assistants count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    TEAssistantModel *assistantModel = [self.assistants objectAtIndex:indexPath.row];
    cell.textLabel.text = assistantModel.assistantName;
    cell.imageView.image = [UIImage imageNamed:@"icon_triage_doctor.png"];

    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.hidesBottomBarWhenPushed = YES;
    UIViewController <TETriageChatViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TETriageChatViewControllerProtocol)];
    TEAssistantModel *assistantModel = [self.assistants objectAtIndex:indexPath.row];
    viewController.title = assistantModel.assistantName;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - API methods

// 获取医生助手列表
- (void)fetchAssistant
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"assistant"];
    [TEHttpTools post:URLString params:nil success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        
        TEAssistant *assistant = [[TEAssistant alloc] initWithDictionary:responseObject error:nil];
        [_assistants addObjectsFromArray:assistant.assistants];
        
        [self.tableView reloadData];
        
        [hud hide:YES];

    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
        [hud hide:YES];
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//
//        TEAssistant *assistant = [[TEAssistant alloc] initWithDictionary:responseObject error:nil];
//        [_assistants addObjectsFromArray:assistant.assistants];
//        
//        [self.tableView reloadData];
//        
//        [hud hide:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        [hud hide:YES];
//    }];
}

@end
