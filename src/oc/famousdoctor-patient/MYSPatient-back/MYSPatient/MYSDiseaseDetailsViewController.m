//
//  MYSDiseaseDetailsViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-5.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSDiseaseDetailsViewController.h"
#import "UIColor+Hex.h"
#import <DTCoreText/DTCoreText.h>
#import "HttpTool.h"
#import "MYSDiseaseRecommendAndIntroductionModel.h"
#import "MYSDirectorGroupCell.h"
#import <POHorizontalList/POHorizontalList.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface MYSDiseaseDetailsViewController () <UITableViewDataSource,UITableViewDelegate,DTAttributedTextContentViewDelegate,POHorizontalListDelegate>
@property (nonatomic, weak) UISegmentedControl *segment;
@property (nonatomic, weak) DTAttributedTextView *diseaseDetailsView;
@property (nonatomic, strong) NSMutableArray *doctorArray;
@property (nonatomic, weak) UITableView *recommendDoctorTableView;
@property (nonatomic, weak) UIImageView *sadImageView;
@property (nonatomic, weak) UILabel *sadTextLabel;
@property (nonatomic, weak) POHorizontalList *list;
@property (nonatomic, weak) UIView *expertView;
@property (nonatomic, weak) UIView *instrView;// 介绍
@property (nonatomic, weak) UILabel *diseaseLabel; // 疾病名
@property (nonatomic, strong)MYSDiseaseRecommendAndIntroductionModel *disease;
@end

@implementation MYSDiseaseDetailsViewController


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;

    
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_button_share_"] style:UIBarButtonItemStyleDone target:self action:@selector(share)];
//    rightButton.tintColor = [UIColor colorFromHexRGB:K00A693Color];
//    self.navigationItem.rightBarButtonItem = rightButton;

    
//    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"疾病百科", @"推荐名医", nil]];
//    segment.selectedSegmentIndex = 0;
//    self.segment = segment;
//    [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
//    segment.tintColor = [UIColor colorFromHexRGB:K00907FColor];
//    //    [segment setBackgroundColor:[UIColor colorFromHexRGB:K00A693Color]];
//    NSMutableDictionary *selectedAttributes = [NSMutableDictionary dictionary];
//    selectedAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:14];
//    selectedAttributes[NSForegroundColorAttributeName] = [UIColor colorFromHexRGB:KFFFFFFColor];
//    [segment setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
//    NSMutableDictionary *normalAttributes = [NSMutableDictionary dictionary];
//    normalAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:14];
//    normalAttributes[NSForegroundColorAttributeName] = [UIColor colorFromHexRGB:K00907FColor];
//    [segment setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
//    segment.frame = CGRectMake(9, 64 + 9, [UIScreen mainScreen].bounds.size.width - 18, 28);
//    [self.view addSubview:segment];
//    
//    
//    UITableView *recommendDoctorTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segment.frame) + 10, kScreen_Width, kScreen_Height - CGRectGetMaxY(self.segment.frame) - 10) style:UITableViewStylePlain];
//    recommendDoctorTableView.delegate = self;
//    recommendDoctorTableView.dataSource = self;
//    recommendDoctorTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.recommendDoctorTableView = recommendDoctorTableView;
//    [self.view addSubview:recommendDoctorTableView];
//    
//    UIImageView *sadImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width - 60) / 2, (kScreen_Height - 160) / 2 -60, 60, 60)];
//    sadImageView.image = [UIImage imageNamed:@"search_icon_none_"];
//    self.sadImageView = sadImageView;
//    sadImageView.hidden = YES;
//    [self.view addSubview:sadImageView];
//    
//    UILabel *sadTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sadImageView.frame) + 10, kScreen_Width, 40)];
//    self.sadTextLabel = sadTextLabel;
//    sadTextLabel.hidden = YES;
//    sadTextLabel.textColor = [UIColor lightGrayColor];
//    sadTextLabel.text = @"未搜索到相关信息";
//    sadTextLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:sadTextLabel];
//    [self.recommendDoctorTableView addSubview:sadImageView];
//    [self.recommendDoctorTableView addSubview:sadTextLabel];
    
    UIView *expertView = [[UIView alloc] initWithFrame:CGRectMake(0, 64,self.view.bounds.size.width , 147)];
    self.expertView = expertView;
    // 推荐专家
//    UILabel *expertLabel = [[UILabel alloc] init];
//    expertLabel.backgroundColor = [UIColor clearColor];
//    expertLabel.opaque = NO;
//    expertLabel.textColor = [UIColor redColor];
//    expertLabel.frame = CGRectMake(20.0, 11.0, 280.0, 21.0);
//    expertLabel.font = [UIFont boldSystemFontOfSize:17];
//    expertLabel.text = @"推荐专家";
//    [expertView addSubview:expertLabel];
    
    UIButton *expertLabel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 39)];
    expertLabel.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    expertLabel.imageEdgeInsets = UIEdgeInsetsMake(0, -kScreen_Width/(1.5), 0, 0);
    expertLabel.titleEdgeInsets = UIEdgeInsetsMake(0, -kScreen_Width/(1.5) + 20, 0, 0);
    expertLabel.userInteractionEnabled = NO;
    [expertLabel setImage:[UIImage imageNamed:@"consult_icon_reference_"] forState:UIControlStateNormal];
    [expertLabel setTitle:@"推荐专家" forState:UIControlStateNormal];
    [expertLabel setTitleColor:[UIColor colorFromHexRGB:K333333Color] forState:UIControlStateNormal];
    expertLabel.titleLabel.font = [UIFont systemFontOfSize:14];
    [expertView addSubview:expertLabel];


    POHorizontalList *list = [[POHorizontalList alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(expertLabel.frame), kScreen_Width, 108.0) title:nil items:_doctorArray];
    self.list = list;
    [list setDelegate:self];
    [self.view addSubview:expertView];
    [expertView addSubview:list];
    self.expertView.hidden = YES;
    
    UIView *instrView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.expertView.frame) + 10, kScreen_Width, kScreen_Height - CGRectGetMaxY(self.expertView.frame))];
    self.instrView = instrView;
    [self.view addSubview:instrView];
    
    
    UILabel *diseaseLabel = [[UILabel alloc] init];
    diseaseLabel.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    diseaseLabel.opaque = NO;
    diseaseLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
    diseaseLabel.frame = CGRectMake(0, 0, kScreen_Width, 39.0);
    diseaseLabel.font = [UIFont systemFontOfSize:14];
    self.diseaseLabel = diseaseLabel;
    self.diseaseLabel.hidden = YES;
    [instrView addSubview:diseaseLabel];
    
    DTAttributedTextView *diseaseDetailsView= [[DTAttributedTextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.diseaseLabel.frame) + 10, kScreen_Width, kScreen_Height - CGRectGetMaxY(self.expertView.frame) - CGRectGetMinY(self.diseaseLabel.frame) - 10)];
    diseaseDetailsView.showsVerticalScrollIndicator = YES;
    diseaseDetailsView.backgroundColor = [UIColor whiteColor];
    diseaseDetailsView.textDelegate = self;
    diseaseDetailsView.contentInset = UIEdgeInsetsMake(10, 20, 0, 20);
    self.diseaseDetailsView = diseaseDetailsView;
    [instrView addSubview:diseaseDetailsView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (NSMutableArray *)doctorArray
{

    if (_doctorArray == nil) {
        _doctorArray = [NSMutableArray array];
    }
    return _doctorArray;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.doctorArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *expertGroupConcerne = @"expertGroupConcerne";
    MYSDirectorGroupCell *expertGroupConcerneCell = [tableView dequeueReusableCellWithIdentifier:expertGroupConcerne];
    if (expertGroupConcerneCell == nil) {
        expertGroupConcerneCell = [[MYSDirectorGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:expertGroupConcerne];
    }
    expertGroupConcerneCell.concerneLabel.hidden = YES;
    expertGroupConcerneCell.concerneButton.hidden = YES;
    expertGroupConcerneCell.doctorModel = self.doctorArray[indexPath.row];
    
    //    expertGroupConcerneCell.model = @"欢迎";
    return expertGroupConcerneCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController <MYSExpertGroupDoctorHomeViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupDoctorHomeViewControllerProtocol)];
    self.hidesBottomBarWhenPushed = YES;
    viewController.doctorId = [self.doctorArray[indexPath.row] doctorId];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (void)segmentClick:(UISegmentedControl *)segment
{
    [self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:2];
}


- (void)setDiseaseId:(NSString *)diseaseId
{
    _diseaseId = diseaseId;
    
     [self getDiseaseDetailsWtihDiseaeID:diseaseId];
}

#pragma mark  POHorizontalListDelegate

- (void) didSelectItem:(ListItem *)item {
//    self.hidesBottomBarWhenPushed = YES;
    UIViewController <MYSExpertGroupDoctorHomeViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupDoctorHomeViewControllerProtocol)];
    self.hidesBottomBarWhenPushed = YES;
    viewController.doctorType = [self.disease.expertGroupDoctor.doctorArray[item.tag -1] doctorType];
    viewController.doctorId = item.selectedId;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark api

- (void)getDiseaseDetailsWtihDiseaeID:(NSString *)diseaseID
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL stringByAppendingString:@"index.php/user-attention/disease-detail"];
    NSDictionary *parameters = @{@"did": diseaseID};
    [HttpTool get:URLString params:parameters success:^(id responseObject) {
        LOG(@"Success: %@", responseObject);
        MYSDiseaseRecommendAndIntroductionModel *disease = [[MYSDiseaseRecommendAndIntroductionModel alloc] initWithDictionary:responseObject error:nil];
        self.disease = disease;
        self.title = [[disease diseaseIntroductionModel] title];
        self.diseaseLabel.hidden = NO;
        self.diseaseLabel.text = [NSString stringWithFormat:@"     %@介绍",[[disease diseaseIntroductionModel] title]];
        MYSDiseaseIntroductionModel *diseaseIntroductionModel = disease.diseaseIntroductionModel;
        NSValue *maxImageSize = [NSValue valueWithCGSize:CGSizeMake(kScreen_Width - 40, kScreen_Width - 40)];
        
        NSMutableString *content = [NSMutableString string];
        if ([diseaseIntroductionModel.synopsis length] > 0) { // 简介
            [content appendString:diseaseIntroductionModel.synopsis];
        }
        if ([diseaseIntroductionModel.pathogenesis length] > 0) { // 病因
            [content appendString:diseaseIntroductionModel.pathogenesis];
        }
        if ([diseaseIntroductionModel.clinicalFeature length] > 0) { // 临床表现
            [content appendString:diseaseIntroductionModel.clinicalFeature];
        }
        if ([diseaseIntroductionModel.cure length] > 0) { // 治疗
            [content appendString:diseaseIntroductionModel.cure];
        }

        self.diseaseDetailsView.attributedString = [[NSAttributedString alloc] initWithHTMLData:[content dataUsingEncoding:NSUTF8StringEncoding] options:@{DTDefaultFontSize: @"14", DTMaxImageSize: maxImageSize} documentAttributes:nil];
        
//        self.doctorArray = disease.expertGroupDoctor.doctorArray;
        for (MYSExpertGroupDoctorModel *expert in disease.expertGroupDoctor.doctorArray) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:expert.headPortrait] placeholderImage:[UIImage imageNamed:@"favicon_doctor_man.png"]];
            ListItem *item = [[ListItem alloc] initWithFrame:CGRectZero imageView:imageView text:expert.doctorName selectedId:expert.doctorId];
            [self.doctorArray addObject:item];
        }
        if (self.doctorArray.count == 0) {
            self.sadTextLabel.hidden = NO;
            self.sadImageView.hidden = NO;
            self.expertView.hidden = YES;
            self.instrView.frame = CGRectMake(0, 64, kScreen_Width, kScreen_Height);
            self.diseaseDetailsView.frame = CGRectMake(0, CGRectGetMaxY(self.diseaseLabel.frame) + 10, kScreen_Width, kScreen_Height - CGRectGetMinY(self.diseaseLabel.frame) - 10 - 103);
        } else {
            self.sadImageView.hidden = YES;
            self.sadTextLabel.hidden = YES;
            self.expertView.hidden  = NO;
            self.instrView.frame = CGRectMake(0, CGRectGetMaxY(self.expertView.frame) + 10, kScreen_Width, kScreen_Height - CGRectGetMaxY(self.expertView.frame) + 64);
            self.diseaseDetailsView.frame = CGRectMake(0, CGRectGetMaxY(self.diseaseLabel.frame) + 10, kScreen_Width, kScreen_Height - CGRectGetMaxY(self.expertView.frame) - CGRectGetMinY(self.diseaseLabel.frame) - 10 - 50);
        }
        self.list.items = _doctorArray;
//        [self.recommendDoctorTableView reloadData];
        
        [hud hide:YES];
    } failure:^(NSError *error) {
        LOG(@"Error: %@", error);
        [hud hide:YES];
    }];
}


@end
