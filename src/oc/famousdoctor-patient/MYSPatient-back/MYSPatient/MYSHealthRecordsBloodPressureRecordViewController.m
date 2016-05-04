//
//  MYSHealthRecordsBloodPressureRecordViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-12.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSHealthRecordsBloodPressureRecordViewController.h"
#import <TRSDialScrollView/TRSDialScrollView.h>
#import "UUDatePicker.h"



@interface MYSHealthRecordsBloodPressureRecordViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, copy) NSString *highBlood;
@property (nonatomic, copy) NSString *lowBlood;
@property (nonatomic, copy) NSString *heartRate;
@property (nonatomic, weak) TRSDialScrollView *highDialView;
@property (nonatomic, weak) TRSDialScrollView *lowDialView;
@property (nonatomic, weak) TRSDialScrollView *heartRateDialView;
@property (nonatomic, weak) UILabel *middleLabel;
@property (nonatomic, weak) UILabel *heartRateValueLabel;
@property (nonatomic, strong) UUDatePicker *datePicker;
@property (nonatomic, copy) NSString *yearMonthDayTime;
@property (nonatomic, copy) NSString *hourMinuteTime;
@end

@implementation MYSHealthRecordsBloodPressureRecordViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.highBlood = @"120";
    self.lowBlood = @"80";
    self.heartRate = @"80";
    
    [self featchCurrentTime];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 500)];
    bottomView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = bottomView;
    
    UILabel *tiPLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 20)];
    tiPLabel.font = [UIFont systemFontOfSize:18];
    tiPLabel.textColor = [UIColor blackColor];
    tiPLabel.text = @"高压/低压";
    [bottomView addSubview:tiPLabel];
    
    
    UILabel *middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tiPLabel.frame) + 10, kScreen_Width, 30)];
    middleLabel.textAlignment = NSTextAlignmentCenter;
    self.middleLabel = middleLabel;
   

    [bottomView addSubview:middleLabel];
    
#pragma mark 高压
    TRSDialScrollView *highDialView = [[TRSDialScrollView alloc] initWithFrame:CGRectMake(20, 100, kScreen_Width - 40, 70)];
    [[TRSDialScrollView appearance] setMinorTicksPerMajorTick:10];
    [[TRSDialScrollView appearance] setMinorTickDistance:20];
    
    [[TRSDialScrollView appearance] setBackgroundColor:[UIColor whiteColor]];
    [[TRSDialScrollView appearance] setOverlayColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DialShadding"]]];
    
    [[TRSDialScrollView appearance] setLabelStrokeColor:[UIColor colorWithRed:0.400 green:0.525 blue:0.643 alpha:1.000]];
    [[TRSDialScrollView appearance] setLabelStrokeWidth:0.1f];
    [[TRSDialScrollView appearance] setLabelFillColor:[UIColor colorWithRed:0.098 green:0.220 blue:0.396 alpha:1.000]];
    
    [[TRSDialScrollView appearance] setLabelFont:[UIFont fontWithName:@"Avenir" size:20]];
    
    [[TRSDialScrollView appearance] setMinorTickColor:[UIColor colorWithRed:0.800 green:0.553 blue:0.318 alpha:1.000]];
    [[TRSDialScrollView appearance] setMinorTickLength:15.0];
    [[TRSDialScrollView appearance] setMinorTickWidth:1.0];
    
    [[TRSDialScrollView appearance] setMajorTickColor:[UIColor colorWithRed:0.098 green:0.220 blue:0.396 alpha:1.000]];
    [[TRSDialScrollView appearance] setMajorTickLength:33.0];
    [[TRSDialScrollView appearance] setMajorTickWidth:2.0];
    
    [[TRSDialScrollView appearance] setShadowColor:[UIColor colorWithRed:0.593 green:0.619 blue:0.643 alpha:1.000]];
    [[TRSDialScrollView appearance] setShadowOffset:CGSizeMake(0, 1)];
    [[TRSDialScrollView appearance] setShadowBlur:0.9f];
    [highDialView setDialRangeFrom:0 to:200];
    highDialView.currentValue = 120 +120/4;
    highDialView.delegate = self;
    highDialView.minorTicksPercentage = 1;
    self.highDialView = highDialView;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((kScreen_Width-40)/2 -1, 0, 1, 50)];
    lineView.backgroundColor = [UIColor redColor];
    [highDialView addSubview:lineView];

    [bottomView addSubview:highDialView];
    
    
#pragma mark  低压
    TRSDialScrollView *lowDialView = [[TRSDialScrollView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(highDialView.frame) + 10, kScreen_Width - 40, 70)];
    [lowDialView setDialRangeFrom:0 to:200];
    lowDialView.currentValue = 80 + 80/4;
    lowDialView.minorTicksPercentage = 1;
    lowDialView.delegate = self;
    self.lowDialView = lowDialView;
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake((kScreen_Width-40)/2 -1, 0, 1, 50)];
    lineView1.backgroundColor = [UIColor redColor];

    [lowDialView addSubview:lineView1];
    
    [bottomView addSubview:lowDialView];

    UIView *marginLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lowDialView.frame), kScreen_Width, 1)];
    marginLine.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:marginLine];
    
    
    UILabel *heartRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(marginLine.frame) + 10, 200, 20)];
    heartRateLabel.text = @"心率";
    heartRateLabel.textColor = [UIColor blackColor];
    heartRateLabel.font = [UIFont systemFontOfSize:18];
    [bottomView addSubview:heartRateLabel];
    
    
    UILabel *heartRateValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(heartRateLabel.frame) + 10, kScreen_Width, 30)];
    heartRateValueLabel.textAlignment = NSTextAlignmentCenter;
    self.heartRateValueLabel = heartRateValueLabel;
    [bottomView addSubview:heartRateValueLabel];
    
   
    
#pragma mark  心率
    TRSDialScrollView *heartRateDialView = [[TRSDialScrollView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(heartRateValueLabel.frame) + 10, kScreen_Width - 40, 70)];
    [heartRateDialView setDialRangeFrom:0 to:200];
    heartRateDialView.currentValue = 100;
    heartRateDialView.minorTicksPercentage = 1;
    heartRateDialView.delegate = self;
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake((kScreen_Width-40)/2 -1, 0, 1, 50)];
    lineView2.backgroundColor = [UIColor redColor];
    [heartRateDialView addSubview:lineView2];
    self.heartRateDialView = heartRateDialView;
    [bottomView addSubview:heartRateDialView];
    
    
    UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(heartRateDialView.frame) + 20, kScreen_Width - 40, 44)];
    commitButton.backgroundColor = [UIColor redColor];
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [bottomView addSubview:commitButton];
    
    [self layoutMiddleLabelValue];
    [self layoutHeartRateLabelValue];
    // Do any additional setup after loading the view.
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    LOG(@"scrollViewDidEndDecelerating:");
    if ([scrollView.superview isEqual:self.highDialView]) {
         self.highBlood = [NSString stringWithFormat:@"%ld",(long)self.highDialView.currentValue];
        [self layoutMiddleLabelValue];
    } else if ([scrollView.superview isEqual:self.lowDialView]){
        self.lowBlood = [NSString stringWithFormat:@"%ld",(long)self.lowDialView.currentValue];
        [self layoutMiddleLabelValue];
    } else {
        self.heartRate = [NSString stringWithFormat:@"%ld",(long)self.heartRateDialView.currentValue];
        [self layoutHeartRateLabelValue];
    }
    
}


- (void)layoutMiddleLabelValue
{
    NSString *text = [NSString stringWithFormat:@"%@/%@",self.highBlood,self.lowBlood];
    NSArray *firstWordsFont = @[@{text: [UIFont systemFontOfSize:23]},
                                @{@"mmHg": [UIFont systemFontOfSize:15]},];
    
    NSArray *firstWordsColor = @[@{text: [UIColor greenColor]},
                                 @{@"mmHg": [UIColor lightGrayColor]},];
    NSMutableAttributedString *firstValueStr = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < 2; i ++) {
        
        NSString *text = [firstWordsFont[i] allKeys][0];
        NSDictionary *attributes = @{NSForegroundColorAttributeName : [firstWordsColor[i] objectForKey:text], NSFontAttributeName : [firstWordsFont[i] objectForKey:text]};
        NSAttributedString *subString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
        [firstValueStr appendAttributedString:subString];
    }
    self.middleLabel.attributedText = firstValueStr;
}

- (void)layoutHeartRateLabelValue
{
  
    NSArray *firstWordsFont = @[@{self.heartRate: [UIFont systemFontOfSize:23]},
                                @{@"次/分钟": [UIFont systemFontOfSize:15]},];
    
    NSArray *firstWordsColor = @[@{self.heartRate: [UIColor greenColor]},
                                 @{@"次/分钟": [UIColor lightGrayColor]},];
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
        self.yearMonthDayTime = [NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
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
