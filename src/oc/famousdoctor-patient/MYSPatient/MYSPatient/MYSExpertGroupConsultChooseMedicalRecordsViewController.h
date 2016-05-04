//
//  MYSExpertGroupConsultChooseMedicalRecordsViewController.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-17.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBaseViewController.h"
@class MYSPatientRecordModel;
//@protocol MYSExpertGroupConsultChooseMedicalRecordsViewControllerDelegate <NSObject>
//
//- (void)expertGroupConsultChooseMedicalRecordsDidSelectedMedicalRecordModel:(MYSPatientRecordModel *)medicalRecordModel;
//
//@end

@interface MYSExpertGroupConsultChooseMedicalRecordsViewController : MYSBaseViewController

@property (nonatomic, weak) id <MYSExpertGroupConsultChooseMedicalRecordsViewControllerDelegate> delegate;

@property (nonatomic, strong) MYSExpertGroupPatientModel *patientModel;

@end
