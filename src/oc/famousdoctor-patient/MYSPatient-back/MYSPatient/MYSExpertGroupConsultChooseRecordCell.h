//
//  MYSExpertGroupConsultChooseRecordCell.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-20.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSExpertGroupConsultChooseRecordCell : UITableViewCell
@property (nonatomic, weak) UILabel *tipLabel;
@property (nonatomic, strong) NSArray *testArray;
@property (nonatomic, weak) UIImageView *disclosureIndicator;

@property (nonatomic, weak) UILabel *firstLabel;
@property (nonatomic, weak) UILabel *secondLabel;
@end
