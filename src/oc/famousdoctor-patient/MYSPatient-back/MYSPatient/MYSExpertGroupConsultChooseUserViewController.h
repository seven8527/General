//
//  MYSExpertGroupConsultChooseUserViewController.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-17.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBaseViewController.h"
//#import "MYSExpertGroupPatientModel.h"


//@protocol MYSExpertGroupConsultChooseUserViewControllerDelegate <NSObject>
//
//- (void)expertGroupConsultChooseUserViewControllerDidSelected:(MYSExpertGroupPatientModel *)patientModel;
//
//@end

@interface MYSExpertGroupConsultChooseUserViewController : MYSBaseViewController

@property (nonatomic, weak) id <MYSExpertGroupConsultChooseUserViewControllerDelegate> delegate;

@end
