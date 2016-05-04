//
//  MYSPatientQuestionsDetailViewController.h
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/17.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "BaseViewController.h"

@interface MYSPatientQuestionsDetailViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *mTableView;
    
    IBOutlet UIView *inputView;
    IBOutlet UITextView *textView;
    IBOutlet UIButton *replyBtn;
    
    IBOutlet UIView *tipsView;
    
    NSMutableArray *mData;
    
    NSString *questionID;
    // 是否回复过最后一条信息
    BOOL isReply;
}

- (void)sendValue:(NSString *)ID;

@end
