//
//  EXDialogueViewController.m
//  Express
//
//  Created by owen on 15/11/3.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "EXDialogueViewController.h"
#import "EXHttpHelper.h"
#import "DialogueListEntity.h"
#import "DBDialogueListManager.h"
#import "EXDialogueTableViewCell.h"
#import "DBFriendManager.h"
#import "DBHelper.h"
#import "Utils.h"
#import "EXDialogueDetailViewController.h"
#import "EXCreateGroupViewController.h"


@interface EXDialogueViewController ()

@end

@implementation EXDialogueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"对话"];
    [self setRightBarImgBtn:@"dialogue_group"];
    [self configUI];
//    [self initData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadList:) name:KNOTIFI_MESSAGE_UPDATE_DIALOGUE_LIST object:nil];
//    [self getAllGroup];
    
}
-(void)rightBtnAction:(id)sender
{
    EXCreateGroupViewController * createGroupCtl = [[EXCreateGroupViewController alloc]init];
    createGroupCtl.delegate = self;
    createGroupCtl.isCreate = YES;
    [self.navigationController pushViewController:createGroupCtl animated:YES ];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    [self initData];
}


-(void)getAllGroup
{
    NSDictionary *dict = @{@"userName":APPDELEGATE.userName, @"obtainType":@"all"};
    [EXHttpHelper POST:KACTION_GROUP_LIST deviceType:KDEVICE_TYPE_WT parameters:dict success:^(int resultCode, id responseObject) {
        switch (resultCode) {
            case 0: //成功
            {
                 NSMutableArray  *groupList = [DialogueListEntity arrayOfModelsFromDictionaries:[responseObject objectForKey:@"groupList"]];
                [DBHelper inTransaction:^(FMDatabase *db) {
                    [DBDialogueListManager insertArray:groupList FMDatabase:db GroupType:Group InsertArrayResult:^(Boolean result) {
                        NSLog(@"%@", result?@"YES":@"NO");
//                        if (result) {
//                            [DBDialogueListManager queryBySelect_sql:all FMDatabase:db QueryBySelectResult:
//                             ^(NSMutableArray *result) {
//                                 NSLog(@"xxxxx=--->>>%@", result);
//                             }];
//                        }
                    }];
                }];
                
               
            }
                break;
                
            default:
            {
                NSLog(@"未知错误, 服务器返回异常");
            }
                break;
        }

    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}


-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:view];
    
    [self.view addSubview:_tableView];
    
    __weak EXDialogueViewController *weakSelf = self; //防止循环引用
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf initData];
    }];
    
}

/**
 *  从数据库 查询数据初始化
 */
-(void)initData
{
    [DBHelper inTransaction:^(FMDatabase *db) {
        [DBDialogueListManager queryBySelect:newMsg FMDatabase:db QueryBySelectResult:^(NSMutableArray *result) {
        //    [DBFriendManager queryAll:All QueryAllResult:^(NSMutableArray *result) {
//            NSLog(@"%@", result);
            
            NSSortDescriptor*sorter=[[NSSortDescriptor alloc]initWithKey:@"lastMessageTime" ascending:NO];
            NSMutableArray *sortDescriptors=[[NSMutableArray alloc]initWithObjects:&sorter count:1];
            NSArray *sortArray=[result sortedArrayUsingDescriptors:sortDescriptors];
            
            self.dialogueDict =  [sortArray mutableCopy];
            [_tableView reloadData];
            [_tableView.header endRefreshing];
        }];
    }];
}
-(void)reloadList:(NSNotification*)aNotification
{
    FMDatabase *db = [aNotification object];
    [DBDialogueListManager queryBySelect:newMsg FMDatabase:db QueryBySelectResult:^(NSMutableArray *result) {
//            NSLog(@"xxxxxxxxx-------%@", result);
        
        NSSortDescriptor*sorter=[[NSSortDescriptor alloc]initWithKey:@"lastMessageTime" ascending:NO];
        NSMutableArray *sortDescriptors=[[NSMutableArray alloc]initWithObjects:&sorter count:1];
        NSArray *sortArray=[result sortedArrayUsingDescriptors:sortDescriptors];
        
        self.dialogueDict =  [sortArray mutableCopy];
        [_tableView reloadData];
        [_tableView.header endRefreshing];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [_dialogueDict count];
}

// overwrite
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
// overwrite
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *FirendId = @"DialogueListId";
    EXDialogueTableViewCell *dialogueTableViewCell = [tableView dequeueReusableCellWithIdentifier:FirendId];
    if (dialogueTableViewCell == nil) {
        dialogueTableViewCell = [[EXDialogueTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirendId];
    }
    DialogueListEntity *bean =[_dialogueDict objectAtIndex:[indexPath row]];
    dialogueTableViewCell.name.text  = bean.groupName;
    NSString *nameStr = [[NSString alloc]init];
    if ([bean.groupType boolValue])
    {
        if ([Utils isBlankString:bean.groupName]) {
            for (DialogueMemberEntity * memberEntity in bean.groupMemberList) {
                nameStr = [nameStr stringByAppendingString:memberEntity.nickName];
            }
            dialogueTableViewCell.name.text =nameStr;
        }
    }
    
    if ([bean.groupType isEqual:[NSNumber numberWithInt:p2p]]) {
        [DBHelper inTransaction:^(FMDatabase *db) {
            [DBFriendManager queryByID:bean.groupId FMDatabase:db QueryResult:^(FriendEntity *result) {
                NSString *image_url = [NSString stringWithFormat:@"%@%@",KLOGO_ROOT_PATH, result.avatar];
                [dialogueTableViewCell.imgLogo setImageWithURL:[NSURL URLWithString:image_url]];
                dialogueTableViewCell.name.text  = result.nickName;
            }];
        }];       
        [dialogueTableViewCell.imgLogo setHidden:NO];
        [dialogueTableViewCell.group2_imgLogo setHidden:YES];
        [dialogueTableViewCell.group3_imgLogo setHidden:YES];
        [dialogueTableViewCell.group4_imgLogo setHidden:YES];
        [dialogueTableViewCell.group5_imgLogo setHidden:YES];
    }
    else
    {
        if(bean.groupMemberList.count ==1)
        {
            [dialogueTableViewCell.imgLogo setHidden:NO];
            [dialogueTableViewCell.group2_imgLogo setHidden:YES];
            [dialogueTableViewCell.group3_imgLogo setHidden:YES];
            [dialogueTableViewCell.group4_imgLogo setHidden:YES];
            [dialogueTableViewCell.group5_imgLogo setHidden:YES];
            NSString *image_url1  = [NSString stringWithFormat:@"%@%@",KLOGO_ROOT_PATH, [bean.groupMemberList[0] avatar]];
            [dialogueTableViewCell.imgLogo setImageWithURL:[NSURL URLWithString:image_url1]];
            
        }

        if(bean.groupMemberList.count ==2)
        {
            [dialogueTableViewCell.imgLogo setHidden:YES];
            [dialogueTableViewCell.group2_imgLogo setHidden:NO];
            [dialogueTableViewCell.group3_imgLogo setHidden:YES];
            [dialogueTableViewCell.group4_imgLogo setHidden:YES];
            [dialogueTableViewCell.group5_imgLogo setHidden:YES];
            NSString *image_url1  = [NSString stringWithFormat:@"%@%@",KLOGO_ROOT_PATH, [bean.groupMemberList[0] avatar]];
            NSString *image_url2  = [NSString stringWithFormat:@"%@%@",KLOGO_ROOT_PATH, [bean.groupMemberList[1] avatar]];
            [dialogueTableViewCell.imgCell1 setImageWithURL:[NSURL URLWithString:image_url1]];
            [dialogueTableViewCell.imgCell2 setImageWithURL:[NSURL URLWithString:image_url2]];
        }
        else if (bean.groupMemberList.count ==3)
        {
            [dialogueTableViewCell.imgLogo setHidden:YES];
            [dialogueTableViewCell.group2_imgLogo setHidden:YES];
            [dialogueTableViewCell.group3_imgLogo setHidden:NO];
            [dialogueTableViewCell.group4_imgLogo setHidden:YES];
            [dialogueTableViewCell.group5_imgLogo setHidden:YES];
            NSString *image_url1  = [NSString stringWithFormat:@"%@%@",KLOGO_ROOT_PATH, [bean.groupMemberList[0] avatar]];
            [dialogueTableViewCell.imgCell3_1 setImageWithURL:[NSURL URLWithString:image_url1]];
            NSString *image_url2  = [NSString stringWithFormat:@"%@%@",KLOGO_ROOT_PATH, [bean.groupMemberList[1] avatar]];
            [dialogueTableViewCell.imgCell3_2 setImageWithURL:[NSURL URLWithString:image_url2]];
            NSString *image_url3  = [NSString stringWithFormat:@"%@%@",KLOGO_ROOT_PATH, [bean.groupMemberList[2] avatar]];
            [dialogueTableViewCell.imgCell3_3 setImageWithURL:[NSURL URLWithString:image_url3]];

        }
        else if (bean.groupMemberList.count ==4)
        {
            [dialogueTableViewCell.imgLogo setHidden:YES];
            [dialogueTableViewCell.group2_imgLogo setHidden:YES];
            [dialogueTableViewCell.group3_imgLogo setHidden:YES];
            [dialogueTableViewCell.group4_imgLogo setHidden:NO];
            [dialogueTableViewCell.group5_imgLogo setHidden:YES];
            NSString *image_url1  = [NSString stringWithFormat:@"%@%@",KLOGO_ROOT_PATH, [bean.groupMemberList[0] avatar]];
            [dialogueTableViewCell.imgCell4_1 setImageWithURL:[NSURL URLWithString:image_url1]];
            NSString *image_url2  = [NSString stringWithFormat:@"%@%@",KLOGO_ROOT_PATH, [bean.groupMemberList[1] avatar]];
            [dialogueTableViewCell.imgCell4_2 setImageWithURL:[NSURL URLWithString:image_url2]];
            NSString *image_url3  = [NSString stringWithFormat:@"%@%@",KLOGO_ROOT_PATH, [bean.groupMemberList[2] avatar]];
            [dialogueTableViewCell.imgCell4_3 setImageWithURL:[NSURL URLWithString:image_url3]];
            NSString *image_url4  = [NSString stringWithFormat:@"%@%@",KLOGO_ROOT_PATH, [bean.groupMemberList[3] avatar]];
            [dialogueTableViewCell.imgCell4_4 setImageWithURL:[NSURL URLWithString:image_url4]];
        }
        else if (bean.groupMemberList.count > 4)
        {
            [dialogueTableViewCell.imgLogo setHidden:YES];
            [dialogueTableViewCell.group2_imgLogo setHidden:YES];
            [dialogueTableViewCell.group3_imgLogo setHidden:YES];
            [dialogueTableViewCell.group4_imgLogo setHidden:NO];
            [dialogueTableViewCell.group5_imgLogo setHidden:NO];
            NSString *image_url1  = [NSString stringWithFormat:@"%@%@",KLOGO_ROOT_PATH, [bean.groupMemberList[0] avatar]];
            [dialogueTableViewCell.imgCell5_1 setImageWithURL:[NSURL URLWithString:image_url1]];
            NSString *image_url2  = [NSString stringWithFormat:@"%@%@",KLOGO_ROOT_PATH, [bean.groupMemberList[1] avatar]];
            [dialogueTableViewCell.imgCell5_2 setImageWithURL:[NSURL URLWithString:image_url2]];
            NSString *image_url3  = [NSString stringWithFormat:@"%@%@",KLOGO_ROOT_PATH, [bean.groupMemberList[2] avatar]];
            [dialogueTableViewCell.imgCell5_3 setImageWithURL:[NSURL URLWithString:image_url3]];
            NSString *image_url4  = [NSString stringWithFormat:@"%@%@",KLOGO_ROOT_PATH, [bean.groupMemberList[3] avatar]];
            [dialogueTableViewCell.imgCell5_4 setImageWithURL:[NSURL URLWithString:image_url4]];
            NSString *image_url5  = [NSString stringWithFormat:@"%@%@",KLOGO_ROOT_PATH, [bean.groupMemberList[4] avatar]];
            [dialogueTableViewCell.imgCell5_5 setImageWithURL:[NSURL URLWithString:image_url5]];
        }
    }

     dialogueTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ( bean.hasNewMessage) {
        [dialogueTableViewCell.count setHidden:NO];
        
        if ([bean.NewmessageCount integerValue]>99) {
            dialogueTableViewCell.count.font  = [UIFont boldSystemFontOfSize:8];
            dialogueTableViewCell.count.text =@"99+";
          
        }
        else if([bean.NewmessageCount integerValue]>0)
        {
            dialogueTableViewCell.count.font  = [UIFont boldSystemFontOfSize:10];
            dialogueTableViewCell.count.text =[NSString stringWithFormat:@"%@",bean.NewmessageCount];
        }
        else
        {
            [dialogueTableViewCell.count setHidden:YES];
        }
    }
    else
    {
        [dialogueTableViewCell.count setHidden:YES];
    }
    dialogueTableViewCell.content.text = bean.lastMessage;
    dialogueTableViewCell.time.text = [Utils format:bean.lastMessageTime];
    return  dialogueTableViewCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        EXDialogueDetailViewController  *detailListCtl = [[EXDialogueDetailViewController alloc]init];
        DialogueListEntity *bean =[_dialogueDict objectAtIndex:[indexPath row]];
        detailListCtl.groupId = bean.groupId ;
        detailListCtl.groupType = bean.groupType ;
        [self.navigationController pushViewController:detailListCtl animated:YES];
        //更新数据库， 设置角标和新消息状态
        [DBHelper inTransaction:^(FMDatabase *db) {
            bean.hasNewMessage = [NSNumber numberWithBool:NO];
            bean.NewmessageCount = [NSNumber numberWithInt:0];
            [DBDialogueListManager updateByID:bean.groupId FMDatabase:db DialogueListEntity:bean UpdateResult:^(Boolean result) {
                if (result) {
                    [APPDELEGATE notifi_updateDialogueList:db]; // 发消息更新ui
                    NSLog(@"消息更新成功");
                }
                else
                {
                    WDLog(@"消息更新失败");
                }
            }];
        }];
    
}

#pragma mark === 实现 EXCreateGroupViewController 的协议 ===
-(void) selectedFriDic:(NSMutableArray *)dic
{
    //创建群组
    WDLog(@"返回创建数组%@",dic);
}
@end
