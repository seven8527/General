//
//  MYSExpertGroupDoctorHomeCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-14.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupDoctorHomeCell.h"
#import "MYSExpertGroupSliderViewController.h"

@implementation MYSExpertGroupDoctorHomeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        MYSExpertGroupSliderViewController *slderVC = [[MYSExpertGroupSliderViewController alloc] init];
//        slderVC.view.frame = CGRectMake(0, -44, slderVC.view.frame.size.width, slderVC.view.frame.size.height);
        [self.contentView addSubview:slderVC.view];
    }

    return self;
}


@end
