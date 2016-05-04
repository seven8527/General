//
//  MYSHotSearchCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-9.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSHotSearchCell.h"
#import "UIColor+Hex.h"
#import "UtilsMacro.h"
#import "MYSHotOneSearchCell.h"

#define tableViewHeight 44

@implementation MYSHotSearchCell 

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 热门搜索
        UITableView *hotSearchTableView = [[UITableView alloc] initWithFrame:CGRectMake((kScreen_Width - tableViewHeight) / 2, - (kScreen_Width - tableViewHeight) / 2, self.frame.size.height, kScreen_Width) style:UITableViewStylePlain];
        self.hotSearchTableView = hotSearchTableView;
        hotSearchTableView.scrollEnabled = NO;
        self.hotSearchTableView.showsHorizontalScrollIndicator = NO;
        self.hotSearchTableView.showsVerticalScrollIndicator = NO;
        self.hotSearchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.hotSearchTableView.decelerationRate = UIScrollViewDecelerationRateFast;
        self.hotSearchTableView.delegate = self;
        self.hotSearchTableView.dataSource = self;
        self.hotSearchTableView.scrollsToTop = NO;
        self.hotSearchTableView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        [self.contentView addSubview:self.hotSearchTableView];
        
    }
    
    return self;
}

- (void)setHotSearchArray:(NSArray *)hotSearchArray
{
    _hotSearchArray = hotSearchArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return self.hotSearchArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *hotOneSearch = @"hotOneSearch";
    MYSHotOneSearchCell *hotOneSearchCell = [tableView dequeueReusableCellWithIdentifier:hotOneSearch];
    if (hotOneSearchCell == nil) {
        hotOneSearchCell = [[MYSHotOneSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotOneSearch];
        hotOneSearchCell.hotNameLable.textColor = [UIColor colorFromHexRGB:K333333Color];
        hotOneSearchCell.hotNameLable.font = [UIFont systemFontOfSize:13];
        hotOneSearchCell.frame = CGRectMake(0, 0, tableViewHeight, kScreen_Width/4);
        hotOneSearchCell.hotNameLable.transform = CGAffineTransformMakeRotation(-M_PI/2);
        hotOneSearchCell.frame = CGRectMake(0, 0, kScreen_Width/4, 44);
        hotOneSearchCell.hotNameLable.textAlignment = NSTextAlignmentCenter;
    }
    if (indexPath.row == 0) {
        hotOneSearchCell.lineImageView.hidden = YES;
    } else {
        hotOneSearchCell.lineImageView.hidden = NO;
    }
    hotOneSearchCell.hotNameLable.text = @"胃癌阿道夫噶啥打法是否";
 
    return hotOneSearchCell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreen_Width/4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LOG(@"inde");
    
     [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
