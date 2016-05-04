//
//  MYSMyReplyDetailViewController.h
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/15.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "BaseViewController.h"
#import "SZTextView.h"

@interface MYSMyReplyDetailViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
{
    IBOutlet UITableView *mTableView;
    UIView *inputView;
    SZTextView *textView;
    UIButton *replyBtn;
    
    NSMutableArray *mData;
    
    NSString *myReplyID;
    // 是否回复过最后一条信息
    BOOL isReply;
    
    // 存放医生头像Url
    NSString *docName;
    // 存放医生头像Url
    NSString *docPicUrl;
    
    NSString *replyID;
}

- (void)sendValue:(NSString *)ID;

@end
