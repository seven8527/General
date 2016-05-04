//
//  MYSHealthRecordsChooseBloodGlucoseStateView.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-26.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYSHealthRecordsChooseBloodGlucoseStateView;
@protocol MYSHealthRecordsChooseBloodGlucoseStateViewDelegate <NSObject>

@optional
- (void)actionSheet:(MYSHealthRecordsChooseBloodGlucoseStateView *)actionSheet bloodGlucoseState:(NSString *)state;
@end


@interface MYSHealthRecordsChooseBloodGlucoseStateView : UIView
+ (MYSHealthRecordsChooseBloodGlucoseStateView *)actionSheetWithCancelButtonTitle:(NSString *)cancelTitle andTitleArray:(NSArray *)titleArray;

@property (nonatomic,assign) id<MYSHealthRecordsChooseBloodGlucoseStateViewDelegate> delegate;

- (void)showInView:(UIView *)view;

- (void)showInWindow;

- (void)showInViewFromLeft:(UIView *)view;

- (void)showInWindowFromLeft;

- (void)dismiss;
@end
