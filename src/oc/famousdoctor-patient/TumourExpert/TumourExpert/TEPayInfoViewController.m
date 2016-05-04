//
//  TEPayInfoViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-13.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPayInfoViewController.h"
#import "TEAppDelegate.h"
#import "TEStoreManager.h"
#import "TEUITools.h"
#import "TEFoundationCommon.h"
#import "TERegisterCell.h"
#import "UIColor+Hex.h"
#import "NSString+CalculateTextSize.h"

#define MESSAGE  @"提示：在进行网银转账或银行汇款，请您再备注、附言、付款用途（不同银行提示有所不同）填写咨询号与客户姓名。\n"


@interface TEPayInfoViewController ()
@property (strong, nonatomic) NSArray *dataSource;
@end

@implementation TEPayInfoViewController

#pragma mark - DataSource

- (void)loadDataSource {
    self.dataSource = [[TEStoreManager sharedStoreManager] getPayInfoConfigureArray];
}

#pragma mark - UIViewController lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadDataSource];
    
    [self configUI];
}


// UI设置
- (void)configUI
{
    self.title = @"付款信息";
    
    // 表尾
    CGSize boundingSize = CGSizeMake(300, CGFLOAT_MAX);
    CGSize messageSize = [MESSAGE boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:14]];
    UILabel *instructionLabel = [[UILabel alloc] init];
    instructionLabel.frame = CGRectMake(16, 20, messageSize.width, messageSize.height);
    instructionLabel.font = [UIFont boldSystemFontOfSize:14];
    instructionLabel.textColor = [UIColor colorWithHex:0x6b6b6b];
    instructionLabel.numberOfLines = 0;
    instructionLabel.text = MESSAGE;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, messageSize.height + 30)];
    [footerView addSubview:instructionLabel];
    self.tableView.tableFooterView = footerView;
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArray = self.dataSource[section];
    
    return sectionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 50;
            break;
        case 1:
            return 30;
            break;
        default:
            return 4;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [self.dataSource[indexPath.section][indexPath.row] valueForKey:@"title"];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.detailTextLabel.text = @"北京华康云医健康科技有限公司";
                break;
            case 1:
                cell.detailTextLabel.text = @"110061073018010097709";
                break;
            case 2:
                cell.detailTextLabel.text = @"交通银行酒仙桥支行";
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                if ([self.payStatue isEqualToString:@"0"]) {
                    cell.detailTextLabel.text = @"未付款";
                } else if ([self.payStatue isEqualToString:@"1"]){
                    cell.detailTextLabel.text = @"已付款";
                }
                break;
            case 1:
                cell.detailTextLabel.text = self.payTime;
                break;
            case 2:
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",self.payPrice];
                break;
            default:
                break;
        }
        
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [NSString stringWithFormat:@"付款方式：%@", self.payModeName];
    }
    
    return @"";
}


@end
