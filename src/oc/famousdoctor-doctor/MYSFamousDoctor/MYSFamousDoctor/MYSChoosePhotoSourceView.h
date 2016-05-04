//
//  MYSChoosePhotoSourceView.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-3.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYSChoosePhotoSourceView;
@protocol MYSChoosePhotoSourceViewDelegate <NSObject>

@optional
- (void)actionSheet:(MYSChoosePhotoSourceView *)actionSheet titleButtonClick:(UIButton *)button;

- (void)actionSheet:(MYSChoosePhotoSourceView *)actionSheet cancelButtonClick:(UIButton *)button;

@end

@interface MYSChoosePhotoSourceView : UIView
+ (MYSChoosePhotoSourceView *)actionSheetWithCancelButtonTitle:(NSString *)cancelTitle  otherButtonTitles:(id)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@property (nonatomic, weak) id<MYSChoosePhotoSourceViewDelegate> delegate;

- (void)showInView:(UIView *)view;

- (void)showInWindow;

- (void)showInViewFromLeft:(UIView *)view;

- (void)showInWindowFromLeft;

- (void)dismiss;
@end
