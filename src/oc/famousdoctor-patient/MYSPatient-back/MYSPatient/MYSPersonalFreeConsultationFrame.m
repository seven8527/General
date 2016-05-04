//
//  MYSPersonalFreeConsultationFrame.m
//  MYSPatient
//
//  Created by 闫文波 on 15-3-23.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPersonalFreeConsultationFrame.h"
#import "MYSBriefAskModel.h"
#import "MYSPlusAskModel.h"
#import "MYSFoundationCommon.h"

@implementation MYSPersonalFreeConsultationFrame

- (void)setFreeConsultModel:(MYSFreeConsult *)freeConsultModel
{
    _freeConsultModel = freeConsultModel;
    
    self.patientImageViewF = CGRectMake(12, 12, 20, 20);
    
    // 主问
    MYSBriefAskModel *briefAskModel = freeConsultModel.briefAskModel;
    
    
    NSString *patientInfo = [NSString stringWithFormat:@"%@ %@岁",briefAskModel.patientModel.patientName,[MYSFoundationCommon obtainAgeWith:briefAskModel.patientModel.patientBirthday]];
    
    self.patientInfoLableF = CGRectMake(CGRectGetMaxX(self.patientImageViewF) + 5, 16, [MYSFoundationCommon sizeWithText:patientInfo withFont:[UIFont systemFontOfSize:13]].width + 12, 13);
    
    self.patientSexImageViewF = CGRectMake(CGRectGetMaxX(self.patientInfoLableF) + 10, 16, 14, 14);
    
    self.consultStatusLabelF = CGRectMake(kScreen_Width-80, 16, 55, 20);
    
    self.firstLineF = CGRectMake(10, CGRectGetMaxY(self.patientImageViewF) + 12, kScreen_Width-40, 1);
    if ([MYSFoundationCommon sizeWithText:briefAskModel.question withFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width - 40, MAXFLOAT)].height > 60) {
        self.questionLabelF = CGRectMake(10, CGRectGetMaxY(self.firstLineF) + 10,kScreen_Width - 40,60);
    } else {
        self.questionLabelF = CGRectMake(10, CGRectGetMaxY(self.firstLineF) + 10,kScreen_Width - 40, [MYSFoundationCommon sizeWithText:briefAskModel.question withFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width - 40, MAXFLOAT)].height);
    }
#warning 问题显示逻辑
    if(briefAskModel.answerModel) {// 如果存在主答
        if(freeConsultModel.plusAskArray.count > 0) {// 存在追问
            // 追问
            MYSPlusAskModel *plusAskModel = [freeConsultModel.plusAskArray firstObject];
            if([plusAskModel.isReply isEqualToString:@"1"]) {// 查看追问是否回复
                self.doctorNameLabelF = CGRectMake(12, CGRectGetMaxY(self.questionLabelF) + 13, [MYSFoundationCommon sizeWithText:briefAskModel.doctorModel.doctorName withFont:[UIFont systemFontOfSize:13]].width, 13);
                self.doctorInfoLabelF = CGRectMake(CGRectGetMaxX(self.doctorNameLabelF) + 12, CGRectGetMinY(self.doctorNameLabelF), [MYSFoundationCommon sizeWithText:[NSString stringWithFormat:@"%@%@",briefAskModel.doctorModel.doctorDepatrment,briefAskModel.doctorModel.doctorClinical] withFont:[UIFont systemFontOfSize:13]].width + 12, 13);
                
                if( [MYSFoundationCommon sizeWithText:plusAskModel.answerModel.content withFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width - 58, MAXFLOAT)].height > 60){
                    self.replyLabelF = CGRectMake(9, 9,kScreen_Width - 58 , 60);
                    self.replyImageViewF = CGRectMake(10, CGRectGetMaxY(self.doctorNameLabelF) + 10, kScreen_Width - 40, 60 + 19);
                } else {
                    self.replyLabelF = CGRectMake(9, 9,kScreen_Width - 58 , [MYSFoundationCommon sizeWithText:plusAskModel.answerModel.content withFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width - 58, MAXFLOAT)].height);
                    self.replyImageViewF = CGRectMake(10, CGRectGetMaxY(self.doctorNameLabelF) + 10, kScreen_Width - 40, [MYSFoundationCommon sizeWithText:plusAskModel.answerModel.content withFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width - 58, MAXFLOAT)].height + 19);
                }
                self.timePicViewF = CGRectMake(12, CGRectGetMaxY(self.replyImageViewF) + 27, 14, 14);
                self.timeLabelF = CGRectMake(CGRectGetMaxX(self.timePicViewF) + 2, CGRectGetMaxY(self.replyImageViewF) + 27, 120, 14);
                self.replyButtonF = CGRectMake(kScreen_Width-95, CGRectGetMaxY(self.replyImageViewF) + 24, 55, 20);
            } else {
                self.doctorNameLabelF = CGRectMake(12, CGRectGetMaxY(self.questionLabelF), 0, 0);
                self.doctorInfoLabelF = CGRectMake(CGRectGetMaxX(self.doctorNameLabelF) + 12, CGRectGetMinY(self.doctorNameLabelF), 0, 0);
                self.replyImageViewF = CGRectMake(10, CGRectGetMaxY(self.doctorNameLabelF), 0, 0);
                self.replyLabelF = CGRectMake(9, 9, 0, 0);
                self.timePicViewF = CGRectMake(12, CGRectGetMaxY(self.replyImageViewF) + 27, 14, 14);
                self.timeLabelF = CGRectMake(CGRectGetMaxX(self.timePicViewF) + 2, CGRectGetMaxY(self.replyImageViewF) + 27, 120, 14);
                self.replyButtonF = CGRectMake(kScreen_Width-95, CGRectGetMaxY(self.replyImageViewF) + 24, 0, 0);
            }
        } else { // 没有追问 即只有主答
            self.doctorNameLabelF = CGRectMake(12, CGRectGetMaxY(self.questionLabelF) + 13, [MYSFoundationCommon sizeWithText:briefAskModel.doctorModel.doctorName withFont:[UIFont systemFontOfSize:13]].width, 13);
            self.doctorInfoLabelF = CGRectMake(CGRectGetMaxX(self.doctorNameLabelF) + 12, CGRectGetMinY(self.doctorNameLabelF), [MYSFoundationCommon sizeWithText:[NSString stringWithFormat:@"%@%@",briefAskModel.doctorModel.doctorDepatrment,briefAskModel.doctorModel.doctorClinical] withFont:[UIFont systemFontOfSize:13]].width + 12, 13);
            if( [MYSFoundationCommon sizeWithText:briefAskModel.answerModel.content withFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width - 58, MAXFLOAT)].height > 60){
                self.replyLabelF = CGRectMake(9, 9,kScreen_Width - 58 , 60);
                self.replyImageViewF = CGRectMake(10, CGRectGetMaxY(self.doctorNameLabelF) + 10, kScreen_Width - 40, 60 + 19);

            } else {
                self.replyLabelF = CGRectMake(9, 9,kScreen_Width - 58 , [MYSFoundationCommon sizeWithText:briefAskModel.answerModel.content withFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width - 58, MAXFLOAT)].height);
                self.replyImageViewF = CGRectMake(10, CGRectGetMaxY(self.doctorNameLabelF) + 10, kScreen_Width - 40, [MYSFoundationCommon sizeWithText:briefAskModel.answerModel.content withFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width - 58, MAXFLOAT)].height + 19);


            }
            self.timePicViewF = CGRectMake(12, CGRectGetMaxY(self.replyImageViewF) + 27, 14, 14);
            self.timeLabelF = CGRectMake(CGRectGetMaxX(self.timePicViewF) + 2, CGRectGetMaxY(self.replyImageViewF) + 27, 120, 14);
            self.replyButtonF = CGRectMake(kScreen_Width-95, CGRectGetMaxY(self.replyImageViewF) + 24, 55, 20);
        }
    } else { // 没有主答
        self.doctorNameLabelF = CGRectMake(12, CGRectGetMaxY(self.questionLabelF), 0, 0);
        self.doctorInfoLabelF = CGRectMake(CGRectGetMaxX(self.doctorNameLabelF) + 12, CGRectGetMinY(self.doctorNameLabelF), 0, 0);
        self.replyImageViewF = CGRectMake(10, CGRectGetMaxY(self.doctorNameLabelF), 0, 0);
        self.replyLabelF = CGRectMake(9, 9, 0, 0);
        self.timePicViewF = CGRectMake(12, CGRectGetMaxY(self.replyImageViewF) + 27, 14, 14);
        self.timeLabelF = CGRectMake(CGRectGetMaxX(self.timePicViewF) + 2, CGRectGetMaxY(self.replyImageViewF) + 27, 120, 14);
        self.replyButtonF = CGRectMake(kScreen_Width-95, CGRectGetMaxY(self.replyImageViewF) + 24, 0, 0);
    }
    self.secondLineF = CGRectMake(10, CGRectGetMinY(self.timePicViewF)-16, kScreen_Width-40, 1);
    self.CellHeight = CGRectGetMaxY(self.timePicViewF) + 17;
}
@end
