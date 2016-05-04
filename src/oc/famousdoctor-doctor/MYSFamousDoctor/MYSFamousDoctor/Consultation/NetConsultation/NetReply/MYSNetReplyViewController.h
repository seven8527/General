//
//  MYSNetReplyViewController.h
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/17.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "BaseViewController.h"

@interface MYSNetReplyViewController : BaseViewController <UITextViewDelegate>
{
    IBOutlet UITextView *contentView;
    
    UIButton *replyBtn;
    
    NSString *mBillNo;
}

- (void)sendValue:(NSString *)billno;

@end
