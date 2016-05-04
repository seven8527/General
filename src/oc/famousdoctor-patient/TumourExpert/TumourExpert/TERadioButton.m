//
//  TERadioButton.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-23.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TERadioButton.h"

@interface TERadioButton()
- (void)defaultInit;
- (void)otherButtonSelected:(id)sender;
- (void)handleButtonTap:(id)sender;
@end

@implementation TERadioButton

static const NSUInteger kRadioButtonWidth = 18;
static const NSUInteger kRadioButtonHeight = 18;

static NSMutableArray *rb_instances = nil;
static NSMutableDictionary *rb_observers = nil;

#pragma mark - Observer

+ (void)addObserverForGroupId:(NSString *)groupId observer:(id)observer
{
    if(!rb_observers){
        rb_observers = [[NSMutableDictionary alloc] init];
    }
    
    if ([groupId length] > 0 && observer) {
        [rb_observers setObject:observer forKey:groupId];
    }
}

#pragma mark - Manage Instances

+ (void)registerInstance:(TERadioButton *)radioButton
{
    if(!rb_instances){
        rb_instances = [[NSMutableArray alloc] init];
    }
    
    [rb_instances addObject:radioButton];
}

#pragma mark - Class level handler

+ (void)buttonSelected:(TERadioButton *)radioButton
{
    // Notify observers
    if (rb_observers) {
        id observer= [rb_observers objectForKey:radioButton.groupId];
        
        if(observer && [observer respondsToSelector:@selector(radioButtonSelectedAtIndex:inGroup:)]){
            [observer radioButtonSelectedAtIndex:radioButton.index inGroup:radioButton.groupId];
        }
    }
    
    // Unselect the other radio buttons
    if (rb_instances) {
        for (int i = 0; i < [rb_instances count]; i++) {
            TERadioButton *button = [rb_instances objectAtIndex:i];
            if (![button isEqual:radioButton]) {
                [button otherButtonSelected:radioButton];
            }
        }
    }
}

#pragma mark - Object Lifecycle

- (id)initWithGroupId:(NSString*)groupId index:(NSUInteger)index
{
    self = [self init];
    if (self) {
        _groupId = groupId;
        _index = index;
    }
    return  self;
}

- (id)init{
    self = [super init];
    if (self) {
        [self defaultInit];
    }
    return self;
}


#pragma mark - Tap handling

- (void)handleButtonTap:(id)sender
{
    [_button setSelected:YES];
    [TERadioButton buttonSelected:self];
}

- (void)otherButtonSelected:(id)sender
{
    // Called when other radio button instance got selected
    if(_button.selected){
        [_button setSelected:NO];
    }
}

#pragma mark - RadioButton init

- (void)defaultInit{
    // Setup container view
    self.frame = CGRectMake(0, 0, kRadioButtonWidth, kRadioButtonHeight);
    
    // Customize UIButton
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(0, 0,kRadioButtonWidth, kRadioButtonHeight);
    _button.adjustsImageWhenHighlighted = NO;
    
    [_button setImage:[UIImage imageNamed:@"radioButton_unselected"] forState:UIControlStateNormal];
    [_button setImage:[UIImage imageNamed:@"radioButton_selected"] forState:UIControlStateSelected];
    
    [_button addTarget:self action:@selector(handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_button];
    
    [TERadioButton registerInstance:self];
}

@end
