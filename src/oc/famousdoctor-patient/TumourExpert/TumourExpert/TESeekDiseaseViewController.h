//
//  TESeekDiseaseViewController.h
//  TumourExpert
//
//  Created by 闫文波 on 14-9-28.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEBaseViewController.h"

@protocol TESeekDiseaseViewControllerDelegate <NSObject>
- (void)didSelectedDiseaseId:(NSString *)diseaseId diseaseName:(NSString *)diseaseName;
@end

@interface TESeekDiseaseViewController : TEBaseViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) id <TESeekDiseaseViewControllerDelegate> delegate;
@end
