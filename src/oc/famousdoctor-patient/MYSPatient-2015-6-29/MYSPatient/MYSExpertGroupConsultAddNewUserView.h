//
//  MYSExpertGroupConsultAddNewUserView.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-26.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYSExpertGroupConsultAddNewUserView;
@protocol MYSExpertGroupConsultAddNewUserViewDelegate <NSObject>

@optional
- (void)actionSheet:(MYSExpertGroupConsultAddNewUserView *)actionSheet cameraButtonTouched:(UIButton *)button;

- (void)actionSheet:(MYSExpertGroupConsultAddNewUserView *)actionSheet commitButtonTouchedWithName:(NSString *)name IDCard:(NSString *)IDCard height:(NSString *)height weight:(NSString *)weight iconStr:(NSString *)iconStr;

@end

@interface MYSExpertGroupConsultAddNewUserView : UIView

+ (MYSExpertGroupConsultAddNewUserView *)actionSheetWithCommitButtonTitle:(NSString *)commitTitle cameraButtonImage:(UIImage *)image otherTextFiledPlaceHolderTitles:(id)otherTextFiledPlaceholderTitles, ... NS_REQUIRES_NIL_TERMINATION;

@property (nonatomic, weak) UIButton *picButton;

@property (nonatomic, weak) id<MYSExpertGroupConsultAddNewUserViewDelegate> delegate;

- (void)showInView:(UIView *)view;

- (void)showInWindow;

- (void)showInViewFromLeft:(UIView *)view;

- (void)showInWindowFromLeft;

- (void)dismiss;

- (void)keyBoardDismiss;

@end
