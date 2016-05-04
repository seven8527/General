//
//  MYSSearchDisease.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-3.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "MYSSearchDiseaseModel.h"

@interface MYSSearchDisease : JSONModel
@property (nonatomic, strong) NSMutableArray<MYSSearchDiseaseModel> *diseaseArray;
@property (nonatomic, strong) NSString<Optional> *diseaseTotal;
@end
