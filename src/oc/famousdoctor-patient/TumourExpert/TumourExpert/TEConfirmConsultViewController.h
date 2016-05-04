//
//  TEConfirmConsultViewController.h
//  TumourExpert
//
//  Created by 闫文波 on 14-10-9.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEBaseViewController.h"


typedef enum {
    TEConfirmConsultOnline,
    TEConfirmConsultPhone,
    TEConfirmConsultOffLine
} TEConfirmConsultType;

@interface TEConfirmConsultViewController : TEBaseViewController <UITableViewDelegate, UITableViewDataSource,TEChoosePayModeViewControllerDelegate>
@property (nonatomic, strong) NSString *phone; // 电话
@property (nonatomic, strong) NSString *patientName; // 患者
@property (nonatomic, strong) NSString *patientId; // 患者Id
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, strong) NSString *expertName;
@property (nonatomic, assign) int TEConfirmConsultType;
@property (nonatomic, strong) NSString *symptom;
@property (nonatomic, strong) NSString *detailDesc;
@property (nonatomic, strong) NSString *help;
@property (nonatomic, strong) NSMutableArray *selectHealthFiles;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *doctorId;
@property (nonatomic, strong) NSString *proid; //产品ID
@end
