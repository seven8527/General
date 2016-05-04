//
//  MYSChoosePhotoSourceView.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-3.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSChoosePhotoSourceView.h"
#import "UIColor+Hex.h"
#define BUTTON_LABEL_TAG 891204

@interface MYSChoosePhotoSourceView ()
+ (UILabel *)buttonLabelWithText:(NSString *)text;
- (void)setActionSheetHeight:(CGFloat)height;
- (void)addButton:(UIButton *)button;
- (void)resizeButtons;
@end

@implementation MYSChoosePhotoSourceView

{
    UIView *_dimmView;
    UIImageView *_sheetBackgroundView;
    NSMutableArray *_buttonArray;
}

@synthesize delegate = _delegate;


+ (MYSChoosePhotoSourceView *)actionSheetWithCancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(id)otherButtonTitles, ...{
    MYSChoosePhotoSourceView *sheetView = [[MYSChoosePhotoSourceView alloc] initWithFrame:CGRectZero];
    if(!sheetView) return nil;
    
    NSUInteger buttonIndex = 0;
    NSInteger titleButtonIndex = 0;
    CGFloat height = 0;
    
    va_list args;
    va_start(args, otherButtonTitles);
    for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*))
    {
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, height, kScreen_Width, 1)];
        lineView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
        [sheetView addSubview:lineView];
        UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [commitButton addTarget:sheetView action:@selector(clickTitleButton:) forControlEvents:UIControlEventTouchUpInside];
        commitButton.tag = titleButtonIndex++;
        commitButton.frame = CGRectMake(0, height, kScreen_Width, 44.0f);
        [commitButton setBackgroundImage:[[UIImage imageNamed:@"YXPActionSheetCancelButton.png"] stretchableImageWithLeftCapWidth:22 topCapHeight:22] forState:UIControlStateNormal];
        UILabel *label = [MYSChoosePhotoSourceView buttonLabelWithText:arg];
        label.textColor = [UIColor colorFromHexRGB:K333333Color];
        [commitButton addSubview:label];
        [sheetView addButton:commitButton];
        height += 44.0f;
    }
    va_end(args);
    
    if (cancelTitle)
    {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, height, kScreen_Width, 1)];
        lineView.backgroundColor = [UIColor colorFromHexRGB:K00A48FColor];
        [sheetView addSubview:lineView];
        
        UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [commitButton addTarget:sheetView action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        commitButton.tag = buttonIndex++;
        commitButton.frame = CGRectMake(0, height, kScreen_Width, 44.0f);
        [commitButton setBackgroundImage:[[UIImage imageNamed:@"YXPActionSheetCancelButton.png"] stretchableImageWithLeftCapWidth:22 topCapHeight:22] forState:UIControlStateNormal];
        UILabel *label = [MYSChoosePhotoSourceView buttonLabelWithText:cancelTitle];
        label.textColor = [UIColor colorFromHexRGB:K00A48FColor];
        [commitButton addSubview:label];
        [sheetView addButton:commitButton];
        height += 44.0f;
    }
    
    [sheetView setActionSheetHeight:height];
    return sheetView;
}

- (id)initWithFrame:(CGRect)frame
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenRect.size;
    self = [super initWithFrame:(CGRect){CGPointZero,screenSize}];
    if (self)
    {
        _buttonArray = [NSMutableArray array];
        
        _dimmView = [[UIView alloc] initWithFrame:(CGRect){CGPointZero,screenSize}];
        _dimmView.backgroundColor = [UIColor colorWithWhite:0.0f/255.0f alpha:0.5f];
        [super addSubview:_dimmView];
        
        _sheetBackgroundView = [[UIImageView alloc] initWithFrame:frame];
        //        UIImage *backgroundImage = [UIImage imageNamed:@"YXPActionSheetBackground.png"];
        //        backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:40 topCapHeight:40];
        _sheetBackgroundView.backgroundColor = [UIColor clearColor];
        _sheetBackgroundView.userInteractionEnabled = YES;
        //        _sheetBackgroundView.image = backgroundImage;
        [super addSubview:_sheetBackgroundView];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 194)];
        backView.backgroundColor = [UIColor whiteColor];
        [_sheetBackgroundView insertSubview:backView atIndex:0];
        
        
    }
    return self;
}

- (void)addSubview:(UIView *)view
{
    [_sheetBackgroundView addSubview:view];
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    
    _sheetBackgroundView.transform = CGAffineTransformIdentity;
    
    CGFloat height = _sheetBackgroundView.frame.size.height;
    CGFloat superViewHeight = view.frame.size.height;
    
    _dimmView.alpha = 0;
    _sheetBackgroundView.frame = CGRectMake(0, superViewHeight, view.frame.size.width, height);
    //    [self resizeButtons];
    [UIView animateWithDuration:0.2 animations:^{
        _dimmView.alpha = 1;
        _sheetBackgroundView.frame = CGRectMake(0, superViewHeight - height, view.frame.size.width, height);
    }];
}

- (void)showInWindow
{
    [self showInView:[[[UIApplication sharedApplication] delegate] window]];
}

- (void)showInViewFromLeft:(UIView *)view
{
    [view addSubview:self];
    
    CGFloat height = _sheetBackgroundView.frame.size.height;
    CGFloat superViewHeight = view.frame.size.height;
    
    _dimmView.alpha = 0;
    
    CGRect originFrame = CGRectMake(-height / 2 - superViewHeight / 2,
                                    superViewHeight / 2 - height / 2,
                                    superViewHeight,
                                    height);
    _sheetBackgroundView.frame = originFrame;
    _sheetBackgroundView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    
    [self resizeButtons];
    [UIView animateWithDuration:0.2 animations:^{
        _dimmView.alpha = 1;
        _sheetBackgroundView.center = CGPointMake(height / 2, _sheetBackgroundView.center.y);
    }];
}

- (void)showInWindowFromLeft
{
    [self showInViewFromLeft:[[[UIApplication sharedApplication] delegate] window]];
}


- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        _dimmView.alpha = 0;
        if (CGAffineTransformEqualToTransform(_sheetBackgroundView.transform, CGAffineTransformMakeRotation(M_PI_2)))
        {
            CGFloat height = _sheetBackgroundView.frame.size.height;
            CGFloat superViewHeight = self.superview.frame.size.height;
            CGRect originFrame = CGRectMake(-height / 2 - superViewHeight / 2,
                                            superViewHeight / 2 - height / 2,
                                            superViewHeight,
                                            height);
            _sheetBackgroundView.frame = originFrame;
        }
        else
        {
            CGRect frame = _sheetBackgroundView.frame;
            frame.origin.y = self.superview.frame.size.height;
            _sheetBackgroundView.frame = frame;
        }
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Private Methods

+ (UILabel *)buttonLabelWithText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 45)];
    label.text = text;
    label.font = [UIFont systemFontOfSize:19.0f];
    label.textColor = [UIColor whiteColor];
    //    label.shadowColor = [UIColor colorWithRed:44.0f/255.0f green:46.0f/255.0f blue:48.0f/255.0f alpha:1.0f];
    //    label.shadowOffset = CGSizeMake(0, -1.0f);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.tag = BUTTON_LABEL_TAG;
    return label;
}

- (void)resizeButtons
{
    CGFloat frameWidth = _sheetBackgroundView.frame.size.width;
    if (CGAffineTransformEqualToTransform(_sheetBackgroundView.transform, CGAffineTransformMakeRotation(M_PI_2)))
    {
        frameWidth =_sheetBackgroundView.frame.size.height;
    }
    for (UIView *eachButton in _buttonArray)
    {
        CGRect buttonFrame = eachButton.frame;
        buttonFrame.origin.x = 22;
        buttonFrame.size.width = frameWidth - 44;
        eachButton.frame = buttonFrame;
        
        UIView *label = [eachButton viewWithTag:BUTTON_LABEL_TAG];
        label.frame = CGRectMake(10, 0, eachButton.frame.size.width - 20, eachButton.frame.size.height);
    }
}

- (void)setActionSheetHeight:(CGFloat)height
{
    _sheetBackgroundView.frame = CGRectMake(0, 0, 0, height);
}

- (void)addButton:(UIButton *)button
{
    [_buttonArray addObject:button];
    //    [button addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [_sheetBackgroundView addSubview:button];
}



- (void)clickTitleButton:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:titleButtonClick:)]) {
        [self.delegate actionSheet:self titleButtonClick:button];
    }
    [self dismiss];
}


- (void)clickCancelButton:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:cancelButtonClick:)]) {
        [self.delegate actionSheet:self cancelButtonClick:button];
    }
    
    [self dismiss];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if(point.y < _sheetBackgroundView.frame.origin.y)
    {
        [self dismiss];
    }
    
    if ( point.y < _sheetBackgroundView.frame.origin.y + 30 && point.y > _sheetBackgroundView.frame.origin.y ) {
        
        if(point.x > kScreen_Width/2 + 30 | point.x < kScreen_Width/2 - 30){
            [self dismiss];
        }
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    return YES;
}

@end
