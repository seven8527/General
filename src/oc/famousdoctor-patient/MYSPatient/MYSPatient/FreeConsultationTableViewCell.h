//
//  FreeConsultationTableViewCell.h
//  MYSPatient
//
//  Created by lyc on 15/5/21.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FreeConsultationTableViewCell : UITableViewCell
{
    IBOutlet UIImageView *headImageView;
    IBOutlet UILabel *nameLabel;
    IBOutlet UITextView *newReplyLabel;
    IBOutlet UILabel *timeLabel;
}

- (void)sendValue:(id)dic;

@end
