//
//  MYSHealthRecordsWeightRecordViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-26.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSHealthRecordsWeightRecordViewController.h"
#import <TRSDialScrollView/TRSDialScrollView.h>
#import "UUDatePicker.h"
#import "UIColor+Hex.h"

@interface MYSHealthRecordsWeightRecordViewController ()
@property (nonatomic, copy) NSString *weight;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, weak) TRSDialScrollView *heightDialView;
@property (nonatomic, weak) TRSDialScrollView *weightDialView;
@property (nonatomic, weak) UILabel *middleLabel;
@property (nonatomic, weak) UILabel *heartRateValueLabel;
@property (nonatomic, strong) UUDatePicker *datePicker;
@property (nonatomic, copy) NSString *yearMonthDayTime;
@property (nonatomic, copy) NSString *hourMinuteTime;
@end

@implementation MYSHealthRecordsWeightRecordViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self featchCurrentTime];
    
    self.weight = @"--";
    self.height = @"--";
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 500)];
    bottomView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = bottomView;
    
    UILabel *tiPLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 200, 20)];
    tiPLabel.font = [UIFont systemFontOfSize:16];
    tiPLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
    tiPLabel.text = @"身高";
    [bottomView addSubview:tiPLabel];
    
    
    UILabel *middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tiPLabel.frame) + 10, kScreen_Width, 30)];
    middleLabel.textAlignment = NSTextAlignmentCenter;
    self.middleLabel = middleLabel;
    
    
    [bottomView addSubview:middleLabel];
    
#pragma mark 身高
    TRSDialScrollView *heightDialView = [[TRSDialScrollView alloc] initWithFrame:CGRectMake(20, 100, kScreen_Width - 40, 70)];
    [[TRSDialScrollView appearance] setMinorTicksPerMajorTick:10];
    [[TRSDialScrollView appearance] setMinorTickDistance:20];
    
    [[TRSDialScrollView appearance] setBackgroundColor:[UIColor whiteColor]];
    [[TRSDialScrollView appearance] setOverlayColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DialShadding"]]];
    
    // 标度值
    [[TRSDialScrollView appearance] setLabelStrokeColor:[UIColor colorWithRed:0.400 green:0.525 blue:0.643 alpha:1.000]];
    [[TRSDialScrollView appearance] setLabelStrokeWidth:0.1f];
    [[TRSDialScrollView appearance] setLabelFillColor:[UIColor colorFromHexRGB:K747474Color]];
    
    [[TRSDialScrollView appearance] setLabelFont:[UIFont fontWithName:@"Avenir" size:20]];
    
    [[TRSDialScrollView appearance] setMinorTickColor:[UIColor colorFromHexRGB:K747474Color]];
    [[TRSDialScrollView appearance] setMinorTickLength:15.0];
    [[TRSDialScrollView appearance] setMinorTickWidth:1.0];
    
    [[TRSDialScrollView appearance] setMajorTickColor:[UIColor colorFromHexRGB:K333333Color]];
    [[TRSDialScrollView appearance] setMajorTickLength:33.0];
    [[TRSDialScrollView appearance] setMajorTickWidth:1.0];
    
    [[TRSDialScrollView appearance] setShadowColor:[UIColor colorWithRed:0.593 green:0.619 blue:0.643 alpha:1.000]];
    [[TRSDialScrollView appearance] setShadowOffset:CGSizeMake(0, 1)];
    [[TRSDialScrollView appearance] setShadowBlur:0.9f];
    [heightDialView setDialRangeFrom:0 to:300];
    heightDialView.currentValue = 120 +120/4;
    heightDialView.delegate = self;
    heightDialView.minorTicksPerMajorTick = 1;
    self.heightDialView = heightDialView;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((kScreen_Width-40)/2 -1, 0, 1, 50)];
    lineView.backgroundColor = [UIColor redColor];
    [heightDialView addSubview:lineView];
    
    [bottomView addSubview:heightDialView];
    
    // 分割线
    UIView *marginLine = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.heightDialView.frame), kScreen_Width, 1)];
    marginLine.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:marginLine];
    
    
    UILabel *heartRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(marginLine.frame) + 15, 200, 20)];
    heartRateLabel.text = @"体重";
    heartRateLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
    heartRateLabel.font = [UIFont systemFontOfSize:16];
    [bottomView addSubview:heartRateLabel];

    
    UILabel *heartRateValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(heartRateLabel.frame) + 10, kScreen_Width, 30)];
    heartRateValueLabel.textAlignment = NSTextAlignmentCenter;
    self.heartRateValueLabel = heartRateValueLabel;
    [bottomView addSubview:heartRateValueLabel];
    
    
    
#pragma mark  体重
    TRSDialScrollView *weightDialView = [[TRSDialScrollView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(heartRateValueLabel.frame) + 10, kScreen_Width - 40, 70)];
    [weightDialView setDialRangeFrom:0 to:188];
    weightDialView.currentValue = 100;
    weightDialView.minorTicksPerMajorTick = 1;
    weightDialView.delegate = self;
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake((kScreen_Width-40)/2 -1, 0, 1, 50)];
    lineView2.backgroundColor = [UIColor redColor];
    [weightDialView addSubview:lineView2];
    self.weightDialView = weightDialView;
    [bottomView addSubview:weightDialView];
    
    
    UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(weightDialView.frame) + 20, kScreen_Width - 40, 44)];
    commitButton.backgroundColor = [UIColor redColor];
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [bottomView addSubview:commitButton];
    
    [self layoutMiddleLabelValue];
    [self layoutWeightLabelValue];
    // Do any additional setup after loading the view.
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    LOG(@"scrollViewDidEndDecelerating:");
    if ([scrollView.superview isEqual:self.heightDialView]) {
        self.height = [NSString stringWithFormat:@"%ld",(long)self.heightDialView.currentValue];
        [self layoutMiddleLabelValue];
    } else {
        self.weight = [NSString stringWithFormat:@"%ld",(long)self.weightDialView.currentValue];
        [self layoutWeightLabelValue];
    }
}


- (void)layoutMiddleLabelValue
{
    NSArray *firstWordsFont = @[@{self.height: [UIFont fontWithName:@"Helvetica Light" size:36]},
                                @{@"cm": [UIFont systemFontOfSize:14]},];
    
    NSArray *firstWordsColor = @[@{self.height: [UIColor colorFromHexRGB:K398CCCColor]},
                                 @{@"cm": [UIColor colorFromHexRGB:K747474Color]},];
    NSMutableAttributedString *firstValueStr = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < 2; i ++) {
        
        NSString *text = [firstWordsFont[i] allKeys][0];
        NSDictionary *attributes = @{NSForegroundColorAttributeName : [firstWordsColor[i] objectForKey:text], NSFontAttributeName : [firstWordsFont[i] objectForKey:text]};
        NSAttributedString *subString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
        [firstValueStr appendAttributedString:subString];
    }
    self.middleLabel.attributedText = firstValueStr;
}

- (void)layoutWeightLabelValue
{
    
    NSArray *firstWordsFont = @[@{self.weight: [UIFont fontWithName:@"Helvetica Light" size:36]},
                                @{@"kg": [UIFont systemFontOfSize:14]},];
    
    NSArray *firstWordsColor = @[@{self.weight: [UIColor colorFromHexRGB:K398CCCColor]},
                                 @{@"kg": [UIColor colorFromHexRGB:K747474Color]},];
    NSMutableAttributedString *firstValueStr = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < 2; i ++) {
        
        NSString *text = [firstWordsFont[i] allKeys][0];
        NSDictionary *attributes = @{NSForegroundColorAttributeName : [firstWordsColor[i] objectForKey:text], NSFontAttributeName : [firstWordsFont[i] objectForKey:text]};
        NSAttributedString *subString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
        [firstValueStr appendAttributedString:subString];
    }
    self.heartRateValueLabel.attributedText = firstValueStr;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    LOG(@"scrollViewWillBeginDragging:");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)featchCurrentTime
{
    NSDate* now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents *dd = [cal components:unitFlags fromDate:now];
    NSInteger y = [dd year];
    NSInteger m = [dd month];
    NSInteger d = [dd day];
    
    NSInteger hour = [dd hour];
    NSInteger min = [dd minute];
    
    self.yearMonthDayTime = [NSString stringWithFormat:@"%ld年%ld月%ld日",(long)y,(long)m,(long)d];
    self.hourMinuteTime =[NSString stringWithFormat:@"%ld:%ld",(long)hour,(long)min];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"blood";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //        cell.imageView.contentMode = UIViewContentModeCenter;
        //        cell.textLabel.font = [UIFont systemFontOfSize:16];
        //        cell.textLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
        //        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        //        cell.detailTextLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    }
    //    NSArray *tempArray = self.dataSource[indexPath.section];
    //    NSDictionary *tempDict = tempArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"more_icon2"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //    cell.textLabel.text = [tempDict objectForKey:@"title"];
    //    cell.detailTextLabel.text = [tempDict objectForKey:@"detail"];
    //    cell.separatorInset = UIEdgeInsetsMake(0, 51, 0, 10);
    cell.textLabel.text = self.yearMonthDayTime;
    cell.detailTextLabel.text = self.hourMinuteTime;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self setupDataPicker];
}


// 日期选择器
- (void)setupDataPicker
{
    UIView *dataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    dataView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    dataView.tag = 99;
    [self.view addSubview:dataView];
    NSDate *now = [NSDate date];
    UUDatePicker *datePicker = [[UUDatePicker alloc] initWithframe:CGRectMake(0, kScreen_Height, kScreen_Width, 200) PickerStyle:UUDateStyle_YearMonthDayHourMinute didSelected:^(NSString *year, NSString *month, NSString *day, NSString *hour, NSString *minute, NSString *weekDay) {
        self.yearMonthDayTime = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
        self.hourMinuteTime = [NSString stringWithFormat:@"%@:%@",hour,minute];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    self.datePicker = datePicker;
    datePicker.maxLimitDate = now;
    datePicker.ScrollToDate = now;
    
    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.duration = 0.25;
    transition.type = kCATransitionFade;
    [self.view.layer addAnimation:transition forKey:nil];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDatePickerView:)];
    tapGR.numberOfTapsRequired    = 1;
    tapGR.numberOfTouchesRequired = 1;
    [dataView addGestureRecognizer:tapGR];
    [self.view addSubview:datePicker];
    
    _datePicker.frame = CGRectMake(0, kScreen_Height - 300, kScreen_Width, 200);
    _datePicker.tag = 1;
    [self.view addSubview:_datePicker];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.35];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView commitAnimations];
    
}

// 移除日期选择器视图
- (void)removeDatePickerView:(UITapGestureRecognizer *)tap
{
    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.duration = 0.25;
    transition.type = kCATransitionFade;
    [self.view.layer addAnimation:transition forKey:nil];
    [[self.view viewWithTag:99] removeFromSuperview];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.35];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    _datePicker.frame = CGRectMake(0, kScreen_Height, kScreen_Width, 200);
    [UIView commitAnimations];
}

//支持多手势识别
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
