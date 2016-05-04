//
//  MYSHealthRecordsBloodGlucoseChooseTimeStateView.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-26.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSHealthRecordsBloodGlucoseChooseTimeStateView.h"
#import "MYSRightImageButton.h"

@interface MYSHealthRecordsBloodGlucoseChooseTimeStateView ()
@property (nonatomic, weak) MYSRightImageButton *stateButton;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, copy) NSString *currentState;
@end

@implementation MYSHealthRecordsBloodGlucoseChooseTimeStateView

+ (instancetype)healthRecordsBloodGlucoseChooseTimeStateViewStateWithImage:(NSString *)image andTitleArray:(NSArray *)titleArray andFrame:(CGRect)frame
{
    MYSHealthRecordsBloodGlucoseChooseTimeStateView *chooseTimeStateView = [[MYSHealthRecordsBloodGlucoseChooseTimeStateView alloc] initWithFrame:frame];
    chooseTimeStateView.currentState = @"空腹";
    chooseTimeStateView.isShow = NO;
    chooseTimeStateView.backgroundColor = [UIColor yellowColor];
    if(!chooseTimeStateView) return nil;
    chooseTimeStateView.titleArray  = titleArray;
    [chooseTimeStateView setupViewsWithFrame:frame];
    return chooseTimeStateView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (NSMutableArray *)buttonArray
{
    if (_buttonArray == nil) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}


- (void)setupViewsWithFrame:(CGRect)frame
{
    MYSRightImageButton *stateButton = [[MYSRightImageButton alloc] initWithFrame:CGRectMake((kScreen_Width - 100)/2, 0, 100, 15)];
    stateButton.titleLabel.textAlignment = NSTextAlignmentRight;
    self.stateButton = stateButton;
    [stateButton setTitle:self.currentState forState:UIControlStateNormal];
    [stateButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [stateButton addTarget:self action:@selector(clickStateButton) forControlEvents:UIControlEventTouchUpInside];
    stateButton.rightImageWidth = 15;
    
    [self addSubview:stateButton];
    
    
    for (int i = 0;  i < self.titleArray.count; i ++) {
        CGFloat width =  frame.size.width/self.titleArray.count;
        
        UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(width *i, CGRectGetMaxY(stateButton.frame) + 10, width, 15)];
        titleButton.hidden = YES;
        titleButton.tag = i;
        [titleButton setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [titleButton addTarget:self action:@selector(clickTitleButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:titleButton];
        
        [self.buttonArray addObject:titleButton];
    }
}


- (void)clickStateButton
{
    for (int i = 0;  i < self.buttonArray.count; i ++) {
        UIButton *titleButton = self.buttonArray[i];
        titleButton.hidden = NO;
    }
}

- (void)clickTitleButton:(UIButton *)titleButton
{
    for (int i = 0;  i < self.buttonArray.count; i ++) {
        UIButton *titleButton = self.buttonArray[i];
        titleButton.hidden = YES;
    }
    
    self.currentState = titleButton.titleLabel.text;
    [self.stateButton setTitle:self.currentState forState:UIControlStateNormal];
}
@end
