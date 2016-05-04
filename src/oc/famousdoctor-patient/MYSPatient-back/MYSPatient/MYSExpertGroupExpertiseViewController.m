//
//  MYSExpertGroupExpertiseViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-13.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupExpertiseViewController.h"
#import "UIColor+Hex.h"
#import "MYSFoundationCommon.h"
#import "MYSDoctorHome.h"
#import "MYSDoctorHomeIntroducesModel.h"
#import <DTCoreText/DTCoreText.h>

#define mainMargin 14

@interface MYSExpertGroupExpertiseViewController () <UIScrollViewDelegate,DTAttributedTextContentViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UITableView *mainTableView;
@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, weak) UILabel *promptForteLabel; // 擅长
@property (nonatomic, weak) UILabel *promptIntroduceLabel; // 个人简介
@property (nonatomic, weak) UILabel *forteLabel; // 擅长疾病
//@property (nonatomic, weak) DTAttributedTextView *introduceView; // 个人简介内容
@end

@implementation MYSExpertGroupExpertiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self layoutUI];
    
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(mainMargin, 0, kScreen_Width -2 *mainMargin, kScreen_Height-88-44-64+self.consultHeight)];
    self.mainTableView = mainTableView;
    mainTableView.showsVerticalScrollIndicator = NO;
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
}

- (void)layoutUIWithModel:(id)model
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Height, 100)];
    self.headerView = headerView;
    
    
    // 擅长疾病
    UILabel *promptForteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, mainMargin, 100, 21)];
    promptForteLabel.text = @"擅长:";
    promptForteLabel.font = [UIFont systemFontOfSize:14];
    promptForteLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    promptForteLabel.backgroundColor = [UIColor clearColor];
    self.promptForteLabel = promptForteLabel;
    [headerView addSubview:promptForteLabel];
    
    CGSize forteSize = [MYSFoundationCommon sizeWithText:[model territory] withFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width - mainMargin * 2, MAXFLOAT)];
    UILabel *forteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.promptForteLabel.frame) + 5, forteSize.width, forteSize.height)];
    forteLabel.text = [model territory];
    [forteLabel setLineBreakMode:NSLineBreakByWordWrapping];
    forteLabel.font = [UIFont systemFontOfSize:14];
    [forteLabel setNumberOfLines:0];
    [forteLabel setBackgroundColor:[UIColor clearColor]];
    self.forteLabel = forteLabel;
    [headerView addSubview:forteLabel];
    

    
   
    // 专家简介
    UILabel *promptIntroduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.forteLabel.frame) + mainMargin/2, 100, 21)];
    promptIntroduceLabel.text = @"个人简介:";
    promptIntroduceLabel.font = [UIFont systemFontOfSize:14];
    promptIntroduceLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    promptIntroduceLabel.backgroundColor = [UIColor clearColor];
    self.promptIntroduceLabel = promptIntroduceLabel;
    [headerView addSubview:promptIntroduceLabel];
    headerView.frame = CGRectMake(0, 0, kScreen_Width, CGRectGetMaxY(promptIntroduceLabel.frame));
    self.mainTableView.tableHeaderView = headerView;
    
    
//    DTAttributedTextView *promptIntroduceView = [[DTAttributedTextView alloc] init];
    


}


- (void)setModel:(id)model
{
    _model = model;
    
    MYSDoctorHomeIntroducesModel *introductesModel = [model introducesModel];
    
    [self layoutUIWithModel:introductesModel];
    [self.mainTableView reloadData];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DTAttributedTextCell *attributedCell = [[DTAttributedTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    attributedCell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSValue *maxImageSize = [NSValue valueWithCGSize:CGSizeMake(kScreen_Width - mainMargin, kScreen_Width - 40)];
    attributedCell.attributedTextContextView.shouldDrawImages = YES;
    attributedCell.attributedTextContextView.shouldDrawLinks = YES;
    attributedCell.attributedTextContextView.shouldLayoutCustomSubviews = YES;
    [attributedCell setHTMLString:[[self.model introducesModel] introduce] options:@{DTDefaultFontSize: @"14", DTMaxImageSize: maxImageSize}];
    
    return attributedCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DTAttributedTextCell *attributedCell = (DTAttributedTextCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [attributedCell requiredRowHeightInTableView:tableView];
}

//
//float lastContentOffset;
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    LOG(@"开始拖动");
//    lastContentOffset = scrollView.contentOffset.y;
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (lastContentOffset > scrollView.contentOffset.y) {
//        LOG(@"12向下滚动");
//        if(self.mainTableView.contentOffset.y > 0) {
//            
//        } else {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollDown" object:nil];
//        }
//    } else {
//        LOG(@"12向上滚动");
//        if(self.mainTableView.contentOffset.y > 0) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollUp" object:nil];
//        }
//    }
//}
//
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//    if (lastContentOffset < scrollView.contentOffset.y) {
//        NSLog(@"向上滚动");
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollUp" object:nil];
//    }else{
//        NSLog(@"向下滚动");
//        if(self.mainTableView.contentOffset.y > 0) {
//            
//        } else {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollDown" object:nil];
//        }
//    }
//}


@end
