//
//  TEChoosePayModeViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-18.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEChoosePayModeViewController.h"
#import "TEUITools.h"

@interface TEChoosePayModeViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *payModes;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation TEChoosePayModeViewController

#pragma mark - UIViewController lifecycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}

- (void) viewDidLoad
{
    _payModes = [NSMutableArray arrayWithObjects:@"支付宝", @"网银转账", @"银行汇款", nil];
    
    self.currentIndex = -1;
    
    [self configUI];
    
    [self layoutUI];
}

#pragma mark - UI

// UI设置
- (void)configUI
{
    self.title = @"选择支付方式";
}

// UI布局
- (void)layoutUI
{
    // Create a UITableView
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
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
    return [self.payModes count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    if (indexPath.row == self.currentIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    cell.textLabel.text = [self.payModes objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        if (indexPath.row == self.currentIndex) {
            return;
        }
        NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
        UITableViewCell *newCell = [aTableView cellForRowAtIndexPath:indexPath];
        if (newCell.accessoryType == UITableViewCellAccessoryNone) {
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        UITableViewCell *oldCell = [aTableView cellForRowAtIndexPath:oldIndexPath];
        if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
            oldCell.accessoryType = UITableViewCellAccessoryNone;
        }
        self.currentIndex = indexPath.row;
        
        [self.delegate didSelectedPayModeId:indexPath.row payModeName:[self.payModes objectAtIndex:indexPath.row]];
        [self.navigationController popViewControllerAnimated:NO];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

@end
