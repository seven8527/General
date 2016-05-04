//
//  MYSPersonalChangePhoneNumberViewController.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-2.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBaseTableViewController.h"

@protocol MYSPersonalChangePhoneNumberViewControllerDelegate <NSObject>
- (void)changePhoneNumberViewControllerDidSelected:(NSString *)phoneNumber;
@end

@interface MYSPersonalChangePhoneNumberViewController : MYSBaseTableViewController
@property (nonatomic, weak) id <MYSPersonalChangePhoneNumberViewControllerDelegate> delegate;
@end

