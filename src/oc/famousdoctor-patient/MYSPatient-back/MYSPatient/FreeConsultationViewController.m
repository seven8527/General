//
//  FreeConsultationViewController.m
//  MYSPatient
//
//  免费咨询
//
//  Created by lyc on 15/5/21.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "FreeConsultationViewController.h"
#import "UIColor+Hex.h"
#import "UtilsMacro.h"
#import "MYSFoundationCommon.h"
#import "UIImage+Corner.h"
#import "FreeConsultationTableViewCell.h"
#import "MYSDirectorGroupCell.h"
#import "FreeConsultationViewController+Request.h"

@interface FreeConsultationViewController ()

@end

@implementation FreeConsultationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"主任医师团";
    
    [self setFreeBtn];
    [self navgLeftBtn];
    
    // 初始化默认选中第一个（咨询头条）
    selectIndex = 0;
    
    // 初始化页码
    newReplayPageNum = 0;
    doctorPageNum = 0;
    
    // 资讯头条数据存储数组
    newReplayArr = [[NSMutableArray alloc] init];
    // 健康饮食数据存储数组
    doctorArr = [[NSMutableArray alloc] init];
    
    mTableView.delegate = self;
    mTableView.dataSource = self;
    
    [self sendNewReplayRequest];
    
    // 1.注册cell
    [mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    // 2.集成刷新控件
    [self setupRefresh];
}

- (void)navgLeftBtn
{
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setFreeBtn
{
    [freeBtn setTitleColor:[UIColor colorFromHexRGB:KFFFFFFColor] forState:UIControlStateNormal];
    UIImage *normalImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:K00A693Color] withButton:freeBtn];
    [freeBtn setBackgroundImage:normalImage forState:UIControlStateNormal];
    
    UIImage *highlightImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:K00907FColor] withButton:freeBtn];
    [freeBtn setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    freeBtn.layer.cornerRadius = 5;
    freeBtn.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [mTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [mTableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

- (void)headerRereshing
{
    if (0 == selectIndex)
    {   // 0:最新回复
        newReplayPageNum = 0;
        [self sendNewReplayRequest];
    } else {
        // 1:活跃医生
        doctorPageNum = 0;
        [self sendDoctorRequest];
    }
}

- (void)footerRereshing
{
    if (0 == selectIndex)
    {   // 0:最新回复
        [self sendNewReplayRequest];
    } else {
        // 1:活跃医生
        [self sendDoctorRequest];
    }
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == selectIndex)
    {   // 0:最新回复
        return [newReplayArr count];
    } else {
        // 1:活跃医生
        return [doctorArr count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == selectIndex)
    {   // 0:最新回复
        return 110;
    } else {
        // 1:活跃医生
        return 88;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == selectIndex)
    {
        NSLog(@"%ld", (long)indexPath.row);
        NSString *cellName = @"FreeConsultationTableViewCell";
        FreeConsultationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (nil == cell)
        {
            [tableView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellReuseIdentifier:cellName];
            cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        }
        [cell sendValue:[newReplayArr objectAtIndex:indexPath.row]];        
        return cell;
    } else {
        static NSString *expertGroupConcerne = @"expertGroupConcerne";
        MYSDirectorGroupCell *expertGroupConcerneCell = [tableView dequeueReusableCellWithIdentifier:expertGroupConcerne];
        if (expertGroupConcerneCell == nil) {
            expertGroupConcerneCell = [[MYSDirectorGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:expertGroupConcerne];
        }
        MYSExpertGroupDoctorModel *expertGroupDoctorModel = [doctorArr objectAtIndex:indexPath.row];
        expertGroupConcerneCell.expertGroupDoctorModel = expertGroupDoctorModel;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 87, kScreen_Width, 1)];
        [lineView setBackgroundColor:[UIColor colorFromHexRGB:KC6C6C6Color]];
        [expertGroupConcerneCell addSubview:lineView];
        
        UIImageView *arrowR = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - 15 - 13, (88 - 13) / 2, 13, 13)];
        arrowR.image = [UIImage imageNamed:@"free_arrow_R"];
        [expertGroupConcerneCell addSubview:arrowR];
        
        return expertGroupConcerneCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == selectIndex)
    {
        UIViewController <MYSExpertGroupDoctorHomeViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupDoctorHomeViewControllerProtocol)];
        //        self.hidesBottomBarWhenPushed = YES;
        MYSExpertGroupDoctorModel *expertGroupDoctorModel = [doctorArr objectAtIndex:indexPath.row];
        viewController.doctorType = expertGroupDoctorModel.doctorType;
        viewController.doctorId = expertGroupDoctorModel.doctorId;
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

/**
 *  Tab按钮点击事件
 */
- (IBAction)tabBarBtnClick:(id)sender
{
    selectIndex = ((UIButton *)sender).tag - 40000;
    if (0 == selectIndex)
    {   // 0:最新回复
        [newReplayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [newReplayBtn setBackgroundImage:[UIImage imageNamed:@"free_tabL_select"] forState:UIControlStateNormal];
        [doctorBtn setTitleColor:[UIColor colorFromHexRGB:k00947DColor] forState:UIControlStateNormal];
        [doctorBtn setBackgroundImage:[UIImage imageNamed:@"free_tabR_unselect"] forState:UIControlStateNormal];
        
        [mTableView reloadData];
        if ([newReplayArr count] == 0)
        {   // 界面没有数据的时候切换时会加载界面，有数据的场合不会重新加载
            [self sendNewReplayRequest];
        }
    }
    if (1 == selectIndex)
    {   // 1:活跃医生
        [newReplayBtn setTitleColor:[UIColor colorFromHexRGB:k00947DColor] forState:UIControlStateNormal];
        [newReplayBtn setBackgroundImage:[UIImage imageNamed:@"free_tabL_unselect"] forState:UIControlStateNormal];
        [doctorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [doctorBtn setBackgroundImage:[UIImage imageNamed:@"free_tabR_select"] forState:UIControlStateNormal];
        
        [mTableView reloadData];
        if ([doctorArr count] == 0)
        {   // 界面没有数据的时候切换时会加载界面，有数据的场合不会重新加载
            [self sendDoctorRequest];
        }
    }
}

- (IBAction)clickConsultButton:(id)sender
{
    UIViewController <MYSDirectorGroupFreeConsultViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSDirectorGroupFreeConsultViewControllerProtocol)];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

@end
