//
//  HealthInformationTableViewCell.h
//  MYSPatient
//
//  Created by lyc on 15/5/19.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthInformationTableViewCell : UITableViewCell
{
    IBOutlet UIImageView *infoImageView;
    IBOutlet UITextView *infoTitleLabel;
    IBOutlet UILabel *infoTimeLabel;
    IBOutlet UILabel *infoCountLabel;
}

- (void)sendValue:(id)dic;

@end
