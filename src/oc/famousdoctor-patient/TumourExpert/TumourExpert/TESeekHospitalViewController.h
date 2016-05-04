//
//  TESeekHospitalViewController.h
//  TumourExpert
//
//  Created by 闫文波 on 14-9-28.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEBaseViewController.h"

@protocol TESeekHospitalViewControllerDelegate <NSObject>
- (void)didSelectedHospitalId:(NSString *)hospitalId hospitalName:(NSString *)hospitalName;
@end

@interface TESeekHospitalViewController : TEBaseViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) id <TESeekHospitalViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *province;
@end
