//
//  MYSMedicalRecordCollectionHeaderView.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-29.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSMedicalRecordCollectionHeaderView.h"
#import "MYSPersonalMedicalRecordHeaderCell.h"
#import "UIColor+Hex.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MYSFoundationCommon.h"

#define tableviewHeight 65

@interface MYSMedicalRecordCollectionHeaderView () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) UITableView  *patientTableView;
@property (nonatomic, strong) NSIndexPath *selctedIndexPatch;
@end

@implementation MYSMedicalRecordCollectionHeaderView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.selctedIndexPatch = [NSIndexPath indexPathForRow:0 inSection:0];
        
        self.backgroundColor = [UIColor  colorFromHexRGB:KEDEDEDColor];
        
        UITableView *patientTableView = [[UITableView alloc] initWithFrame:CGRectMake((kScreen_Width - tableviewHeight) / 2 - 65, -(kScreen_Width - tableviewHeight) / 2, 65, kScreen_Width) style:UITableViewStylePlain];
        patientTableView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
        patientTableView.dataSource = self;
        patientTableView.delegate = self;
        patientTableView.showsHorizontalScrollIndicator = NO;
        patientTableView.showsVerticalScrollIndicator = NO;
        patientTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        patientTableView.decelerationRate = UIScrollViewDecelerationRateFast;
        patientTableView.scrollsToTop = NO;
        patientTableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        self.patientTableView = patientTableView;
        patientTableView.tableHeaderView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
        [self addSubview:patientTableView];
        
        
        UIButton *userManagerView = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(patientTableView.frame) + 17.5, 0, 50, 60)];
        [userManagerView addTarget:self action:@selector(tapUserManagerView) forControlEvents:UIControlEventTouchUpInside];
        userManagerView.titleLabel.font = [UIFont systemFontOfSize:12];
        userManagerView.titleEdgeInsets = UIEdgeInsetsMake(45, -45, 0, 0);
        userManagerView.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
        [userManagerView setTitle:@"用户管理" forState:UIControlStateNormal];
        [userManagerView setTitleColor:[UIColor colorFromHexRGB:K00907FColor] forState:UIControlStateNormal];
        [userManagerView setImage:[UIImage imageNamed:@"record_button_"] forState:UIControlStateNormal];
        [self addSubview:userManagerView];
        
        
        UIButton *addNewRecordView = [[UIButton alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(patientTableView.frame), 100, 22)];
        [addNewRecordView addTarget:self action:@selector(clickAddNewRecord) forControlEvents:UIControlEventTouchUpInside];
        addNewRecordView.layer.cornerRadius = 11;
        addNewRecordView.clipsToBounds = YES;
        [addNewRecordView setImage:[UIImage imageNamed:@"zoe_button_add_"] forState:UIControlStateNormal];
        self.addNewRecordView = addNewRecordView;
        [self addSubview:addNewRecordView];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personalChoosePatient:) name:@"personalChoosePatient" object:nil];
    }
    return self;
}

- (void)setPatientArray:(NSArray *)patientArray
{
    _patientArray = patientArray;
    
    if(patientArray.count == 0) {
        self.addNewRecordView.hidden = YES;
    } else {
        self.addNewRecordView.hidden = NO;
    }
    
    [self.patientTableView reloadData];
    
    [self tableView:self.patientTableView didSelectRowAtIndexPath:self.selctedIndexPatch];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return self.patientArray.count;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.patientTableView.frame = CGRectMake(0, 0, kScreen_Width - 65, 65);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *personalMedicalRecordHeader = @"personalMedicalRecordHeader";
    MYSPersonalMedicalRecordHeaderCell *personalMedicalRecordHeaderCell = [tableView dequeueReusableCellWithIdentifier:personalMedicalRecordHeader];
    if (personalMedicalRecordHeaderCell == nil) {
        personalMedicalRecordHeaderCell = [[MYSPersonalMedicalRecordHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:personalMedicalRecordHeader];
    }
    personalMedicalRecordHeaderCell.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    personalMedicalRecordHeaderCell.iconImageView.bounds = CGRectMake(0, 0, 31, 31);
    personalMedicalRecordHeaderCell.iconImageView.layer.cornerRadius = 15.5;
    
    [personalMedicalRecordHeaderCell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[self.patientArray[indexPath.row] patientIcon]]placeholderImage:[UIImage imageNamed:[MYSFoundationCommon placeHolderImageWithGender:[self.patientArray[indexPath.row]patientSex] andBirthday:[self.patientArray[indexPath.row] patientBirthday]]]];
    
    personalMedicalRecordHeaderCell.maskView.bounds = CGRectMake(0, 0, 31, 31);
    personalMedicalRecordHeaderCell.maskView.layer.cornerRadius = 15.5;
    personalMedicalRecordHeaderCell.nameLabel.center = CGPointMake(CGRectGetMinY(personalMedicalRecordHeaderCell.iconImageView.frame) +5, 25);
    personalMedicalRecordHeaderCell.nameLabel.bounds = CGRectMake(0, 0, 65, 20);
    personalMedicalRecordHeaderCell.nameLabel.font = [UIFont systemFontOfSize:12];
    personalMedicalRecordHeaderCell.nameLabel.text = [self.patientArray[indexPath.row] patientName];
    
//    if ([indexPath isEqual:self.selctedIndexPatch]) {
//       personalMedicalRecordHeaderCell.iconImageView.bounds = CGRectMake(0, 0, 29, 29);
//         personalMedicalRecordHeaderCell.iconImageView.layer.cornerRadius = 14.5;
//        personalMedicalRecordHeaderCell.nameLabel.center = CGPointMake(CGRectGetMinY(personalMedicalRecordHeaderCell.iconImageView.frame) +5, 25);
//        personalMedicalRecordHeaderCell.nameLabel.bounds = CGRectMake(0, 0, 65, 20);
//        personalMedicalRecordHeaderCell.nameLabel.font = [UIFont systemFontOfSize:13];
//    } else {
//        personalMedicalRecordHeaderCell.iconImageView.bounds = CGRectMake(0, 0, 21, 21);
//        personalMedicalRecordHeaderCell.iconImageView.layer.cornerRadius = 11.5;
//        personalMedicalRecordHeaderCell.nameLabel.center = CGPointMake(CGRectGetMinY(personalMedicalRecordHeaderCell.iconImageView.frame) +5, 25);
//        personalMedicalRecordHeaderCell.nameLabel.bounds = CGRectMake(0, 0, 65, 20);
//        personalMedicalRecordHeaderCell.nameLabel.font = [UIFont systemFontOfSize:10];
//
//    }
    if ([indexPath isEqual:self.selctedIndexPatch]) {
        CGContextRef ref = UIGraphicsGetCurrentContext();
        CGContextSetRGBStrokeColor(ref, 1, 0, 0, 0);
        CGContextSetLineWidth(ref, 2);
        CGContextAddArc(ref, 0, 0, 17, 0,2 * M_PI, 0);
        CGContextDrawPath(ref, kCGPathStroke);
        personalMedicalRecordHeaderCell.iconImageView.layer.borderWidth = 2.0;
        personalMedicalRecordHeaderCell.iconImageView.layer.borderColor = [UIColor colorFromHexRGB:K00907FColor].CGColor;
        personalMedicalRecordHeaderCell.maskView.hidden = YES;
        personalMedicalRecordHeaderCell.nameLabel.textColor = [UIColor blackColor];
    } else {
        personalMedicalRecordHeaderCell.iconImageView.layer.borderWidth = 0.0;
        personalMedicalRecordHeaderCell.maskView.hidden = NO;
        personalMedicalRecordHeaderCell.iconImageView.layer.borderColor =[UIColor colorFromHexRGB:K00907FColor].CGColor;
        personalMedicalRecordHeaderCell.nameLabel.textColor = [UIColor lightGrayColor];

    }
       return personalMedicalRecordHeaderCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.selctedIndexPatch) {
//        MYSPersonalMedicalRecordHeaderCell *selectedCell = (MYSPersonalMedicalRecordHeaderCell *)[tableView cellForRowAtIndexPath:self.selctedIndexPatch];
//        selectedCell.iconImageView.bounds = CGRectMake(0, 0, 21, 21);
//        selectedCell.iconImageView.layer.cornerRadius = 11.5;
//        selectedCell.nameLabel.center = CGPointMake(CGRectGetMinY(selectedCell.iconImageView.frame) +5, 25);
//        selectedCell.nameLabel.bounds = CGRectMake(0, 0, 65, 20);
//        selectedCell.nameLabel.font = [UIFont systemFontOfSize:10];
//    }
//    MYSPersonalMedicalRecordHeaderCell *cell = (MYSPersonalMedicalRecordHeaderCell *)[tableView cellForRowAtIndexPath:indexPath];
//    cell.iconImageView.bounds = CGRectMake(0, 0, 29, 29);
//    cell.iconImageView.layer.cornerRadius = 14.5;
//    cell.nameLabel.center = CGPointMake(CGRectGetMinY(cell.iconImageView.frame) +5, 25);
//    cell.nameLabel.bounds = CGRectMake(0, 0, 65, 20);
//    cell.nameLabel.font = [UIFont systemFontOfSize:13];
    
    if (self.selctedIndexPatch) {
        MYSPersonalMedicalRecordHeaderCell *selectedCell = (MYSPersonalMedicalRecordHeaderCell *)[tableView cellForRowAtIndexPath:self.selctedIndexPatch];
        selectedCell.iconImageView.layer.borderWidth = 0.0;
        selectedCell.iconImageView.layer.borderColor = [UIColor colorFromHexRGB:K00907FColor].CGColor;
        selectedCell.nameLabel.textColor = [UIColor lightGrayColor];
        selectedCell.maskView.hidden = NO;
    }
    MYSPersonalMedicalRecordHeaderCell *cell = (MYSPersonalMedicalRecordHeaderCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.iconImageView.layer.borderWidth = 2.0;
    cell.iconImageView.layer.borderColor = [UIColor colorFromHexRGB:K00907FColor].CGColor;
    cell.nameLabel.textColor = [UIColor blackColor];
    cell.maskView.hidden = YES;
    
    self.selctedIndexPatch = indexPath;
    if ([self.delegate respondsToSelector:@selector(medicalRecordCollectionHeaderViewDidSelectPatientWithModel:)]) {
        if(self.patientArray.count > 0){
            [self.delegate medicalRecordCollectionHeaderViewDidSelectPatientWithModel:self.patientArray[self.selctedIndexPatch.row]];
        } else {
            [self.delegate medicalRecordCollectionHeaderViewDidSelectPatientWithModel:nil];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 14;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
    headerView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    return headerView;
}


- (void)clickAddNewRecord
{
    if (self.patientArray.count > 0) {
        if ([self.delegate respondsToSelector:@selector(medicalRecordCollectionHeaderViewClickAddNewRecord)]) {
            [self.delegate medicalRecordCollectionHeaderViewClickAddNewRecord];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请添加患者资料" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    
}


- (void)tapUserManagerView
{
    if ([self.delegate respondsToSelector:@selector(medicalRecordCollectionHeaderViewClickUserManager)]) {
        [self.delegate medicalRecordCollectionHeaderViewClickUserManager];
    }

}


-(void)personalChoosePatient:(NSNotification *)notification
{
    self.selctedIndexPatch = [NSIndexPath indexPathForRow:[[notification.userInfo objectForKey:@"choosePatientIndex"] integerValue] inSection:0];
    [self.patientTableView reloadData];
    
    [self.patientTableView scrollToRowAtIndexPath:self.selctedIndexPatch atScrollPosition:UITableViewScrollPositionNone animated:NO];
    
    if ([self.delegate respondsToSelector:@selector(medicalRecordCollectionHeaderViewDidSelectPatientWithModel:)]) {
        if(self.patientArray.count > 0){
            [self.delegate medicalRecordCollectionHeaderViewDidSelectPatientWithModel:self.patientArray[self.selctedIndexPatch.row]];
        } else {
            [self.delegate medicalRecordCollectionHeaderViewDidSelectPatientWithModel:nil];
        }
    }
}

@end
