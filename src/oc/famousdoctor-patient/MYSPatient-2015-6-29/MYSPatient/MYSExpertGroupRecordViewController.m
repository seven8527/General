//
//  MYSExpertGroupRecordViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-13.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupRecordViewController.h"
#import "MYSExpertGroupRecordCell.h"
#import "MYSExpertGroupRecordModel.h"

@interface MYSExpertGroupRecordViewController ()
@property (nonatomic, strong) NSMutableArray *contentArray;
@end

@implementation MYSExpertGroupRecordViewController

- (NSMutableArray *)contentArray
{
    if (_contentArray == nil) {
        _contentArray = [NSMutableArray array];
    }
    return _contentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getSource];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *record= @"record";
    MYSExpertGroupRecordCell *recordCell = [tableView dequeueReusableCellWithIdentifier:record];
    if (recordCell == nil) {
        recordCell = [[MYSExpertGroupRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:record];
    }
    recordCell.separatorInset = UIEdgeInsetsMake(0, 37, 0, 0);
    recordCell.recordFrame = self.contentArray[indexPath.row];
    return recordCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"abc" forKey:@"expertGroupRecord"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"expertGroupRecord" object:nil userInfo:userInfo];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYSExpertGroupRecordFrame *frame = self.contentArray[indexPath.row];
    
    return frame.cellHeight;
}


- (void)getSource
{
    MYSExpertGroupRecordModel *model = [[MYSExpertGroupRecordModel alloc] init];
    
    for ( int i = 0 ; i < 10; i++) {
         MYSExpertGroupRecordFrame *frame = [[MYSExpertGroupRecordFrame alloc] init];
        frame.recordModel = model;
        [self.contentArray addObject:frame];
    }
    [self.tableView reloadData];
}


float lastContentOffset;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    LOG(@"开始拖动");
    lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (lastContentOffset > scrollView.contentOffset.y) {
        LOG(@"12向下滚动");
        if(self.tableView.contentOffset.y > 0) {
            
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollDown" object:nil];
        }
    } else {
        LOG(@"12向上滚动");
        if(self.tableView.contentOffset.y > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollUp" object:nil];
        }
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (lastContentOffset < scrollView.contentOffset.y) {
        LOG(@"向上滚动");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollUp" object:nil];
    }else{
        LOG(@"向下滚动");
        if(self.tableView.contentOffset.y > 0) {
            
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollDown" object:nil];
        }
    }
}

@end
