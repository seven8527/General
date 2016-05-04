//
//  EXGroupMemberViewController.m
//  Express
//
//  Created by owen on 15/12/1.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "EXGroupMemberViewController.h"
#import "DBHelper.h"
#import "DBDialogueListManager.h"
#import "DBDialogueMemberManager.h"
#import "EXGroupNetManager.h"
#import "EXCreateGroupViewController.h"

@interface EXGroupMemberViewController ()
@property (nonatomic, assign) BOOL isDelON;


@end

@implementation EXGroupMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"群成员"];
    [self setLeftBarImgBtn:nil];
   
    
    
    [self configUI];
    [self initData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) configUI
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.backgroundColor = UIColorFromRGB(KE6E6E6Color);
    [self.view addSubview:_scrollView];
    
}
-(void) initData
{
    [DBHelper inTransaction:^(FMDatabase *db) {
        [DBDialogueMemberManager queryByGroupId:_dialogueListEntity.groupId FMDatabase:db QueryGroupResult:^(NSMutableArray *result) {
            _memberArray = result;
            [self reLoadView];
        }];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self initData];
    
}

-(void) reLoadView
{
    for (UIView* view in [self.view subviews] ) {
        [view removeFromSuperview];
    }
    
    for (int i  = 0 ;  i < _memberArray.count;  i++) {
        float x = i%4 * SCREEN_WIDTH/4  ;
        float y = i/4 * SCREEN_WIDTH/4  +68;
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(x, y, SCREEN_WIDTH/4, SCREEN_WIDTH/4)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 60, 60)];
        [imageView.layer setMasksToBounds:YES];
        [imageView.layer setCornerRadius:30];
        NSString *logoStr =  [KLOGO_ROOT_PATH stringByAppendingString:[[_memberArray objectAtIndex:i] avatar]];
        [imageView setImageWithURL:[NSURL URLWithString:logoStr]];
        [view addSubview:imageView];
        
        
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress:)];
        imageView.tag = i;
        [imageView addGestureRecognizer:singleTap];
        
        BOOL isSelf = [[[_memberArray objectAtIndex:i] userName] isEqualToString:APPDELEGATE.UserID];
        if (_isDelON && !isSelf) {
            UIImageView *imageView_del = [[UIImageView alloc] initWithFrame:CGRectMake(45, 2, 30, 30)];
            [imageView_del.layer setMasksToBounds:YES];
            [imageView_del.layer setCornerRadius:15];
            [imageView_del setImage:[UIImage imageNamed:@"cline_btn"]];
            [view addSubview:imageView_del];

        }
        
        UILabel *nameLb = [[UILabel alloc]initWithFrame:CGRectMake(5, 62, 60, 10)];
        nameLb.text =[[_memberArray objectAtIndex:i] nickName];
        nameLb.font = [UIFont systemFontOfSize:13];
        nameLb.textAlignment = NSTextAlignmentCenter;
        [view addSubview:nameLb];
     
        [self.view addSubview:view];
    }
    if ([APPDELEGATE.UserID isEqualToString:APPDELEGATE.UserID]) {
//    if ([_dialogueListEntity.groupOwer isEqualToString:APPDELEGATE.UserID]) {
        float x = _memberArray.count%4 * SCREEN_WIDTH/4  ;
        float y = _memberArray.count/4 * SCREEN_WIDTH/4  +68;
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(x, y, SCREEN_WIDTH/4, SCREEN_WIDTH/4)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 60, 60)];
        [imageView.layer setMasksToBounds:YES];
        [imageView.layer setCornerRadius:30];
        [imageView setImage:[UIImage imageNamed:@"remove_btn"] ];
        [view addSubview:imageView];
        
        [self.view addSubview:view];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionButtonpress:)];
        imageView.tag = -2;
        [imageView addGestureRecognizer:singleTap];
        
        
        
        float add_x = (_memberArray.count+1)%4 * SCREEN_WIDTH/4 ;
        float add_y = (_memberArray.count+1)/4 * SCREEN_WIDTH/4  +68;
        UIView * add_view = [[UIView alloc]initWithFrame:CGRectMake(add_x, add_y, SCREEN_WIDTH/4, SCREEN_WIDTH/4)];
        
        UIImageView *add_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 60, 60)];
        [add_imageView.layer setMasksToBounds:YES];
        [add_imageView.layer setCornerRadius:30];
        [add_imageView setImage:[UIImage imageNamed:@"add_btn"] ];
        [add_view addSubview:add_imageView];
        
        [self.view addSubview:add_view];
        
        add_imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTapadd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionButtonpress:)];
        add_imageView.tag = -1;
        [add_imageView addGestureRecognizer:singleTapadd];
    }
    else
    {
        float x = _memberArray.count%4 * SCREEN_WIDTH/4  ;
        float y = _memberArray.count/4 * SCREEN_WIDTH/4  +68;
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(x, y, SCREEN_WIDTH/4, SCREEN_WIDTH/4)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 60, 60)];
        [imageView.layer setMasksToBounds:YES];
        [imageView.layer setCornerRadius:30];
        [imageView setImage:[UIImage imageNamed:@"add_btn"] ];
        [view addSubview:imageView];
        
        [self.view addSubview:view];
        
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionButtonpress:)];
        imageView.tag = -1;
        [imageView addGestureRecognizer:singleTap];

    }
}
-(void)buttonpress:(UIGestureRecognizer *)sender
{
    UIView *imageview = [sender view];
    DialogueMemberEntity * memberEntity =  [_memberArray objectAtIndex:imageview.tag];
    BOOL isSelf = [[[_memberArray objectAtIndex:imageview.tag] userName] isEqualToString:APPDELEGATE.UserID];
     if (_isDelON && !isSelf) //删除操作
     {
         [SVProgressHUD showWithStatus:@"正在删除..."];
         
         [EXGroupNetManager removeMembertoGroup:_dialogueListEntity.groupId userID:APPDELEGATE.UserID Member:memberEntity.userName success:^(int resultCode, id responseObject) {
             if (resultCode == 0) {
                 [self delFromDB:memberEntity.userName];
                 
                 [SVProgressHUD showSuccessWithStatus:@"删除成功"];
             }
             else
             {
                  [SVProgressHUD showSuccessWithStatus:@"删除失败"];
             }
             [SVProgressHUD dismiss];
         } failure:^(NSError *error) {
             [SVProgressHUD showSuccessWithStatus:@"删除错误"];
             [SVProgressHUD dismiss];
         }];
     }
    else //预览个人信息
    {
        
    }
}

-(void)delFromDB:(NSString *) uid
{
    [DBHelper inTransaction:^(FMDatabase *db) {
       [DBDialogueMemberManager deleteByID:uid FMDatabase:db WithGroupId:_dialogueListEntity.groupId DelResult:^(Boolean result) {
           [DBDialogueMemberManager queryByGroupId:_dialogueListEntity.groupId FMDatabase:db QueryGroupResult:^(NSMutableArray *result) {
               _memberArray = result;
               [self reLoadView];
           }];
       }];
    }];
}


-(void)actionButtonpress:(UIGestureRecognizer *)sender
{
    UIView *view = [sender view];
    if (view.tag == -1) {
        NSMutableArray * unavailableFriarray = [[NSMutableArray alloc]init];
        for (DialogueMemberEntity * friEntity in _memberArray) {
            [unavailableFriarray addObject:friEntity.userName];
        }
        EXCreateGroupViewController * createGroupCtl = [[EXCreateGroupViewController alloc]init];
        createGroupCtl.isCreate = NO;
        createGroupCtl.unavailableFriDic =unavailableFriarray;
        createGroupCtl.groupid = _dialogueListEntity.groupId;
        createGroupCtl.dialogueListEntity = _dialogueListEntity;
        [self.navigationController pushViewController:createGroupCtl animated:YES];
    }
    else
    {
        _isDelON = !_isDelON;
        [self reLoadView];
    }
    
}

@end
