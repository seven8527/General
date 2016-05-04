//
//  MYSPersonalConsults.h
//  MYSPatient
//
//  Created by 吴玉龙 on 15-3-24.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "MYSFreeConsult.h"

@interface MYSPersonalConsults : JSONModel
@property (nonatomic, strong) NSArray<MYSFreeConsult> *consults;
@property (nonatomic, copy) NSString *total;
@end
