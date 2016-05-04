//
//  MYSHealthRecordsBloodGlucoseRecordViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-25.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSHealthRecordsBloodGlucoseRecordViewController.h"
#import <TRSDialScrollView/TRSDialScrollView.h>
#import "UUDatePicker.h"
#import "UIColor+Hex.h"
#import "MYSHealthRecordsChooseBloodGlucoseStateView.h"

@interface MYSHealthRecordsBloodGlucoseRecordViewController () <MYSHealthRecordsChooseBloodGlucoseStateViewDelegate>
@property (nonatomic, copy) NSString *glucose;
@property (nonatomic, weak) TRSDialScrollView *glucoseDialView;
@property (nonatomic, weak) UILabel *middleLabel;
@property (nonatomic, weak) UILabel *heartRateValueLabel;
@property (nonatomic, strong) UUDatePicker *datePicker;
@property (nonatomic, copy) NSString *yearMonthDayTime;
@property (nonatomic, copy) NSString *hourMinuteTime;
@property (nonatomic, copy) NSString *bloodGlucoseState;
@end

@implementation MYSHealthRecordsBloodGlucoseRecordViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self featchCurrentTime];
    self.glucose = @"--";
    
    self.bloodGlucoseState = @"空腹";
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 200)];
    bottomView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = bottomView;
    
    
    UILabel *middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, kScreen_Width, 30)];
    middleLabel.textAlignment = NSTextAlignmentCenter;
    self.middleLabel = middleLabel;
    
    
    [bottomView addSubview:middleLabel];
    
#pragma mark 血糖
    TRSDialScrollView *glucoseDialView = [[TRSDialScrollView alloc] initWithFrame:CGRectMake(20, 100, kScreen_Width - 40, 70)];
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
    [glucoseDialView setDialRangeFrom:0 to:200];
    glucoseDialView.currentValue = 120 +120/4;
    glucoseDialView.delegate = self;
    glucoseDialView.minorTicksPerMajorTick = 10;
    self.glucoseDialView = glucoseDialView;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((kScreen_Width-40)/2 -1, 0, 1, 50)];
    lineView.backgroundColor = [UIColor redColor];
    [glucoseDialView addSubview:lineView];

    [bottomView addSubview:glucoseDialView];

    
    [self layoutMiddleLabelValue];

    
    UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(glucoseDialView.frame) + 60, kScreen_Width - 40, 44)];
    commitButton.backgroundColor = [UIColor redColor];
    [commitButton setTitle:@"记录一下" forState:UIControlStateNormal];
    [bottomView addSubview:commitButton];

}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.glucose = [NSString stringWithFormat:@"%ld",(long)self.glucoseDialView.currentValue];
    [self layoutMiddleLabelValue];
}


- (void)layoutMiddleLabelValue
{
    
    // 设置显示数值  由于设置比例是10  所以需在此处设置选中的数值
    NSMutableString *text = [NSMutableString stringWithFormat:@"%@",self.glucose];
    if (![text isEqualToString:@"--"]) {
        if (text.length > 1) {
            [text insertString:@"." atIndex:text.length - 1];
        }else {
            [text insertString:@"0." atIndex:0];
        }
    }
   
    
    NSArray *firstWordsFont = @[@{text: [UIFont systemFontOfSize:24]},
                                @{@"mmol/L": [UIFont systemFontOfSize:13]},];
    
    NSArray *firstWordsColor = @[@{text: [UIColor greenColor]},
                                 @{@"mmol/L": [UIColor lightGrayColor]},];
    NSMutableAttributedString *firstValueStr = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < 2; i ++) {
        
        NSString *text = [firstWordsFont[i] allKeys][0];
        NSDictionary *attributes = @{NSForegroundColorAttributeName : [firstWordsColor[i] objectForKey:text], NSFontAttributeName : [firstWordsFont[i] objectForKey:text]};
        NSAttributedString *subString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
        [firstValueStr appendAttributedString:subString];
    }
    self.middleLabel.attributedText = firstValueStr;
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
    
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"blood";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
        cell.detailTextLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
    }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if(indexPath.row == 0) {
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
        cell.imageView.image = [UIImage imageNamed:@"more_icon2"];
        cell.textLabel.text = self.yearMonthDayTime;
        cell.detailTextLabel.text = self.hourMinuteTime;
    } else {
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.imageView.image = [UIImage imageNamed:@"more_icon3"];
        cell.textLabel.text = @"状态";
        cell.detailTextLabel.text = self.bloodGlucoseState;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        [self setupDataPicker];
    } else {
        NSArray *titleArray = [NSArray arrayWithObjects:@"空腹",@"餐后1h",@"餐后2h", nil];
        MYSHealthRecordsChooseBloodGlucoseStateView *payTypeView = [MYSHealthRecordsChooseBloodGlucoseStateView actionSheetWithCancelButtonTitle:@"取消"andTitleArray:titleArray];
        payTypeView.delegate = self;
        [payTypeView showInView:self.view];
    }
    
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

#pragma mark MYSHealthRecordsChooseBloodGlucoseStateViewDelegate
- (void)actionSheet:(MYSHealthRecordsChooseBloodGlucoseStateView *)actionSheet bloodGlucoseState:(NSString *)state;
{
    LOG(@"%@",state);

    self.bloodGlucoseState = state;
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

@end
