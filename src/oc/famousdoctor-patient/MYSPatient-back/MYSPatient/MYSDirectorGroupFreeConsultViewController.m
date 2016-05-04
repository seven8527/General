//
//  MYSDirectorGroupFreeConsultViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-3-19.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSDirectorGroupFreeConsultViewController.h"
#import "UIColor+Hex.h"
#import "LPlaceholderTextView.h"
#import "AppDelegate.h"
#import "MYSFoundationCommon.h"
#import "HttpTool.h"

@interface MYSDirectorGroupFreeConsultViewController () <MYSExpertGroupConsultChooseUserViewControllerDelegate,UITextViewDelegate,UIAlertViewDelegate>
@property (nonatomic, weak) LPlaceholderTextView *contentTextView; // 描述内容
@property (nonatomic, strong) MYSExpertGroupPatientModel *patientModel;
@property (nonatomic, copy) NSString *chooseUser;
@end

@implementation MYSDirectorGroupFreeConsultViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        
        self.view.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.chooseUser = @"请选择用户";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"免费咨询";
    
    self.view.backgroundColor = [UIColor colorFromHexRGB:KF6F6F6Color];
    
    // 返回键
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    // 提问
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [rightButton addTarget:self action:@selector(clickAskButton) forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButton setTitle:@"提问" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorFromHexRGB:K9E9E9EColor] forState:UIControlStateDisabled];
    [rightButton setTitleColor:[UIColor colorFromHexRGB:K00907FColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem.enabled = NO;


    
    // 咨询内容
    LPlaceholderTextView *contentTextView = [LPlaceholderTextView newAutoLayoutView];
    contentTextView.delegate = self;
    contentTextView.placeholderText = @"请详细描述您的症状、疾病和身体情况,我们会为您自动分诊到正确科室并保证您的隐私安全";
    contentTextView.placeholderColor = [UIColor colorFromHexRGB:KABABABColor];
    contentTextView.font = [UIFont systemFontOfSize:13];
    contentTextView.textColor = [UIColor blackColor];
    contentTextView.layer.borderWidth = 0.5f;
//    contentTextView.layer.cornerRadius = 5;
    contentTextView.layer.borderColor = [UIColor colorFromHexRGB:KC2C2C2Color].CGColor;
    contentTextView.frame = CGRectMake(0, 0, kScreen_Width, 182);
    self.contentTextView = contentTextView;
//    [self.view addSubview:contentTextView];
    self.tableView.tableFooterView = contentTextView;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tabelView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor colorFromHexRGB:K575757Color];
    cell.textLabel.text = self.chooseUser;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 39.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController <MYSExpertGroupConsultChooseUserViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupConsultChooseUserViewControllerProtocol)];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)expertGroupConsultChooseUserViewControllerDidSelected:(MYSExpertGroupPatientModel *)patientModel
{
    self.patientModel = patientModel;
    self.chooseUser = [self userDataWithPatientModel:patientModel];
    [self.tableView reloadData];
}

- (NSString *)userDataWithPatientModel:(MYSExpertGroupPatientModel *)patientModel
{
    LOG(@"%@",[MYSFoundationCommon obtainAgeWith:patientModel.patientBirthday]);
    NSString *sex = @"";
    if ([patientModel.patientSex isEqual:@"1"]) {
        sex = @"男";
    } else {
        sex = @"女";
    }
    
    return [NSString stringWithFormat:@"%@(%@,%@岁)",patientModel.patientName,sex,[MYSFoundationCommon obtainAgeWith:patientModel.patientBirthday]];
}

// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 提问
- (void)clickAskButton
{
    [self.contentTextView resignFirstResponder];
    NSString *question = [self.contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([self validateQuestion:question andPatientID:self.patientModel.patientId]) {
        
        [self freeConsultWithQuestion:question andPatientID:self.patientModel.patientId];
    }
}

#pragma mark textViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}
#pragma mark - API

// 调用后台免费咨询接口
- (void)freeConsultWithQuestion:(NSString *)question andPatientID:(NSString *)patientID
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"free_consult"];
    NSDictionary *parameters = @{@"pfid": @"", @"uid": ApplicationDelegate.userId, @"pid": patientID, @"question_title": question,@"cookie": ApplicationDelegate.cookie};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"%@", responseObject);
        int state = [[responseObject valueForKey:@"state"] intValue];
        if (state == 1) {
            hud.labelText = @"提交成功,请去个人中心查看医生回复";
           
            [hud hide:YES afterDelay:2];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewFreeConsult" object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
            
        } else if (state == -406) {
            [hud hide:YES];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"您好，当前您已全部使用每天三次的提问机会，明日可继续向医生提问。谢谢。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alertView.delegate = self;
            [alertView show];
        } else {
            hud.labelText = @"提交失败";
            [hud hide:YES afterDelay:1];
        }
        
    } failure:^(NSError *error) {
        LOG(@"Error: %@", error);
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Validate

// 验证电话和患者
- (BOOL)validateQuestion:(NSString *)question andPatientID:(NSString *)patientID
{
    
    if (patientID == nil || [patientID length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择咨询者" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if (question.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写咨询问题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if (question.length > 500) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写500字以内" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }

    return YES;
}

@end
