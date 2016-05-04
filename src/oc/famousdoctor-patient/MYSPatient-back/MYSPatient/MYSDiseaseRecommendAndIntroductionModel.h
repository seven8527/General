//
//  MYSDiseaseRecommendAndIntroductionModel.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-5.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "MYSDiseaseIntroductionModel.h"
#import "MYSExpertGroupDoctor.h"

@interface MYSDiseaseRecommendAndIntroductionModel : JSONModel
@property (nonatomic, strong) MYSDiseaseIntroductionModel<Optional> *diseaseIntroductionModel;
@property (nonatomic, strong) MYSExpertGroupDoctor<Optional> *expertGroupDoctor;
@property (nonatomic, strong) NSString<Optional> *picpath;
@end
