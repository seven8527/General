//
//  EXDialogueGroupSettingViewController.m
//  Express
//
//  Created by owen on 15/11/27.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "EXDialogueGroupSettingViewController.h"
#import "EXDialogueGroupSettingTableViewCell.h"
#import "DBHelper.h"
#import "DialogueListEntity.h"
#import "DBDialogueListManager.h"
#import "QRCodeGenerator.h"
#import "EXGroupCardViewController.h"
#import "DBMessageManager.h"
#import "Utils.h"
#import "EXGroupMemberViewController.h"
#import "EXGroupNetManager.h"
#import "DBDialogueMemberManager.h"

@interface EXDialogueGroupSettingViewController ()

@property (nonatomic, strong) DialogueListEntity *dialogueListEntity;

@end

@implementation EXDialogueGroupSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"群设置"];
    [self setLeftBarImgBtn:nil];
   
    [self configUI];
//    [self initData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self initData];
    
}

-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    
}
#pragma  mark ----- 更改处-----
-(void) initData
{
    [DBHelper inTransaction:^(FMDatabase *db) {
        [DBDialogueListManager  queryByID:_groupId FMDatabase:db QueryResult:^(DialogueListEntity *result) {
            _dialogueListEntity = result;
            _owerId = _dialogueListEntity.groupOwer;

            //调试开关
//            _owerId = APPDELEGATE.UserID;
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
            view.backgroundColor = [UIColor clearColor];
            UIButton * quit = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 10, 150, 35)];
            [quit setTitleColor:UIColorFromRGB(KFFFFFFColor) forState:UIControlStateNormal];
            [quit setBackgroundColor:UIColorFromRGB(KF5895CColor)];
            [quit.layer setMasksToBounds:YES];
            [quit.layer setCornerRadius:8.0];
            quit.titleLabel.font = [UIFont systemFontOfSize:17];
            [quit setTitle:@"退出该群" forState:UIControlStateNormal];
            quit.tag = 0;
            [quit addTarget:self action:@selector(actionPress:) forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:quit];
            
            
            if ([_owerId isEqualToString:APPDELEGATE.UserID]) {
                UIButton * destory = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 55, 150, 35)];
                [destory setTitleColor:UIColorFromRGB(KFFFFFFColor) forState:UIControlStateNormal];
                [destory setBackgroundColor:UIColorFromRGB(KE6554aColor)];
                [destory.layer setMasksToBounds:YES];
                [destory.layer setCornerRadius:8.0];
                destory.titleLabel.font = [UIFont systemFontOfSize:17];
                [destory setTitle:@"解散该群" forState:UIControlStateNormal];
                destory.tag = 1;
                [destory addTarget:self action:@selector(actionPress:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:destory];
            }
            [_tableView setTableFooterView:view];
             [_tableView reloadData];
        }];
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_owerId isEqualToString:APPDELEGATE.UserID]) { //是否群主
        return 7;
    }
    else{
        return  6;
    }
}

// overwrite
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    int heightForRow = 40;
    if ([_owerId isEqualToString:APPDELEGATE.UserID]) { //是否群主
        switch (indexPath.row) {
            case 0:
                heightForRow += 20 +15;
                break;
            case 1: //群名称编辑
                heightForRow += 15;
                break;
            case 3:
                heightForRow += 15;
                break;
            case 4:
                heightForRow += 15;
                break;
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row) {
            case 0:
                heightForRow += 20 +15;
                break;
//            case 1: //群名称编辑
//                heightForRow += 15;
//                break;
            case 2:
                heightForRow += 15;
                break;
            case 3:
                heightForRow += 15;
                break;
            default:
                break;
        }
    }
    
    return  heightForRow;
}
// overwrite
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *groupSettingId = @"GroupSetting";
    EXDialogueGroupSettingTableViewCell *dialogueGroupSettingTableViewCell = [tableView dequeueReusableCellWithIdentifier:groupSettingId];
    if (dialogueGroupSettingTableViewCell == nil) {
        dialogueGroupSettingTableViewCell = [[EXDialogueGroupSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:groupSettingId];
    }
    dialogueGroupSettingTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
  
    dialogueGroupSettingTableViewCell = [self getView:dialogueGroupSettingTableViewCell indexPath:indexPath];
    [dialogueGroupSettingTableViewCell.switchBtn addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
//    dialogueGroupSettingTableViewCell.switchBtn.tag = indexPath.row;
    
    return  dialogueGroupSettingTableViewCell;
}


-(EXDialogueGroupSettingTableViewCell *) getView:(EXDialogueGroupSettingTableViewCell *)dialogueGroupSettingTableViewCell indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0) {
        [dialogueGroupSettingTableViewCell.title autoSetDimensionsToSize:CGSizeMake(100, 40)];
        [dialogueGroupSettingTableViewCell.title autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [dialogueGroupSettingTableViewCell.title autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
        
        [dialogueGroupSettingTableViewCell.arrayImageView autoSetDimensionsToSize:CGSizeMake(10 ,  19)];
        [dialogueGroupSettingTableViewCell.arrayImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
        [dialogueGroupSettingTableViewCell.arrayImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        
        [dialogueGroupSettingTableViewCell.bottomView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH ,  15)];
        [dialogueGroupSettingTableViewCell.bottomView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:dialogueGroupSettingTableViewCell.title withOffset:10];
        [dialogueGroupSettingTableViewCell.bottomView autoPinEdgeToSuperviewEdge:ALEdgeRight ];
        
    }
    else
    {
        [dialogueGroupSettingTableViewCell.title autoSetDimensionsToSize:CGSizeMake(100, 40)];
        [dialogueGroupSettingTableViewCell.title autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [dialogueGroupSettingTableViewCell.title autoPinEdgeToSuperviewEdge:ALEdgeTop];
        
        [dialogueGroupSettingTableViewCell.arrayImageView autoSetDimensionsToSize:CGSizeMake(10 ,  19)];
        [dialogueGroupSettingTableViewCell.arrayImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
        [dialogueGroupSettingTableViewCell.arrayImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        
        [dialogueGroupSettingTableViewCell.switchBtn autoSetDimensionsToSize:CGSizeMake(60, 30)];
        [dialogueGroupSettingTableViewCell.switchBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [dialogueGroupSettingTableViewCell.switchBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
        
        //        [dialogueGroupSettingTableViewCell.bottomView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH ,  15)];
        [dialogueGroupSettingTableViewCell.bottomView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:dialogueGroupSettingTableViewCell.title];
        [dialogueGroupSettingTableViewCell.bottomView autoPinEdgeToSuperviewEdge:ALEdgeRight ];
    }
    if ([_owerId isEqualToString:APPDELEGATE.UserID]) { //是否群主
        switch (indexPath.row) {
            case 0:
            {
                [dialogueGroupSettingTableViewCell.bottomView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH ,  15)];
                dialogueGroupSettingTableViewCell.switchBtn.hidden= YES;
                dialogueGroupSettingTableViewCell.title.text  = @"群成员";
                for (UIView * view in  dialogueGroupSettingTableViewCell.subviews) {
                    if (view.tag == 100) {
                        [view removeFromSuperview];
                    };
                }
                for (int i = 0;  i < _dialogueListEntity.groupMemberList.count; i++) {
                    if (i < 5) {
                        UIImageView * logoview  = [[UIImageView alloc] initWithFrame:CGRectMake(i*42+80, 10, 40, 40)];
                        logoview.layer.masksToBounds = YES;
                        logoview.layer.cornerRadius = 20.0f;
                        logoview.tag = 100;
                        
                        NSString *image_url  = [NSString stringWithFormat:@"%@%@",KLOGO_ROOT_PATH, [[_dialogueListEntity.groupMemberList objectAtIndex:i] avatar]];
                        [logoview setImageWithURL:[NSURL URLWithString:image_url]];
                        [dialogueGroupSettingTableViewCell addSubview:logoview];
                    }
                }
            }
                break;
            case 1:
            {
                dialogueGroupSettingTableViewCell.switchBtn.hidden= YES;
                dialogueGroupSettingTableViewCell.title.text  = @"群名称";
                [dialogueGroupSettingTableViewCell.bottomView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH ,  15)];
                
                UILabel * groupName  = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 200, 20)];
                groupName.font = [UIFont boldSystemFontOfSize:16];
                groupName.tag = 2;
//                groupName.textColor = UIColorFromRGB(KC8C8C8Color);
                for (UIView * view in  dialogueGroupSettingTableViewCell.subviews) {
                    if (view.tag == 2) {
                        [view removeFromSuperview];
                    };
                }
                NSString *nameStr = [[NSString alloc]init];
                if ([Utils isBlankString:_dialogueListEntity.groupName]) {
                    for (DialogueMemberEntity * memberEntity in _dialogueListEntity.groupMemberList) {
                        nameStr = [nameStr stringByAppendingString:memberEntity.nickName];
                    }
                    groupName.text = nameStr;
                }
                else
                {
                     groupName.text = _dialogueListEntity.groupName;
                }

                [dialogueGroupSettingTableViewCell addSubview:groupName];
                
                
            }
                break;
            case 2:
            {
                dialogueGroupSettingTableViewCell.arrayImageView.hidden= YES;
                dialogueGroupSettingTableViewCell.title.text  = @"聊天置顶";
                [dialogueGroupSettingTableViewCell.bottomView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH ,  1)];
                dialogueGroupSettingTableViewCell.switchBtn.on = [_dialogueListEntity.isShowTop boolValue];
                dialogueGroupSettingTableViewCell.switchBtn.tag = 0;
                
            }
                break;
            case 3:
            {
                [dialogueGroupSettingTableViewCell.bottomView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH ,  15)];
                dialogueGroupSettingTableViewCell.arrayImageView.hidden= YES;
                dialogueGroupSettingTableViewCell.title.text  = @"新消息通知";
                //                dialogueGroupSettingTableViewCell.bottomView.hidden = YES;
                  dialogueGroupSettingTableViewCell.switchBtn.on = [_dialogueListEntity.isMsgNotification boolValue];
                dialogueGroupSettingTableViewCell.switchBtn.tag = 1;
            }
                break;
            case 4:
            {
                [dialogueGroupSettingTableViewCell.bottomView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH ,  15)];
                dialogueGroupSettingTableViewCell.arrayImageView.hidden= YES;
                dialogueGroupSettingTableViewCell.title.text  = @"显示群成员";
                dialogueGroupSettingTableViewCell.switchBtn.on = [_dialogueListEntity.isShowMember boolValue];
                dialogueGroupSettingTableViewCell.switchBtn.tag = 2;
            }
                break;
            case 5:
            {
                dialogueGroupSettingTableViewCell.title.text  = @"清空聊天消息";
                [dialogueGroupSettingTableViewCell.bottomView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH ,  1)];
                dialogueGroupSettingTableViewCell.switchBtn.hidden = YES;
            }
                break;
            case 6:
            {
                dialogueGroupSettingTableViewCell.title.text  = @"群名片";
                [dialogueGroupSettingTableViewCell.bottomView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH ,  1)];
                dialogueGroupSettingTableViewCell.switchBtn.hidden = YES;
                
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(80, 1, 38, 38)];
                UIImage *image = [QRCodeGenerator qrImageForString:_groupId imageSize:38];
                [imageView setImage:image];
                imageView.tag = 6;
                //                groupName.textColor = UIColorFromRGB(KC8C8C8Color);
                for (UIView * view in  dialogueGroupSettingTableViewCell.subviews) {
                    if (view.tag == 6) {
                        [view removeFromSuperview];
                    };
                }

                [dialogueGroupSettingTableViewCell addSubview:imageView];
                
            }
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row) {
            case 0:
            {
                [dialogueGroupSettingTableViewCell.bottomView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH ,  15)];
                dialogueGroupSettingTableViewCell.switchBtn.hidden= YES;
                dialogueGroupSettingTableViewCell.title.text  = @"群成员";
                for (UIView * view in  dialogueGroupSettingTableViewCell.subviews) {
                    if (view.tag == 100) {
                        [view removeFromSuperview];
                    };
                }
                for (int i = 0;  i < _dialogueListEntity.groupMemberList.count; i++) {
                    if (i < 5) {
                        UIImageView * logoview  = [[UIImageView alloc] initWithFrame:CGRectMake(i*42+80, 10, 40, 40)];
                        logoview.layer.masksToBounds = YES;
                        logoview.layer.cornerRadius = 20.0f;
                        logoview.tag = 100;
                       
                        NSString *image_url  = [NSString stringWithFormat:@"%@%@",KLOGO_ROOT_PATH, [[_dialogueListEntity.groupMemberList objectAtIndex:i] avatar]];
                        [logoview setImageWithURL:[NSURL URLWithString:image_url]];
                        [dialogueGroupSettingTableViewCell addSubview:logoview];
                    }
                }
            }
                break;
            case 1:
            {
                dialogueGroupSettingTableViewCell.arrayImageView.hidden= YES;
                dialogueGroupSettingTableViewCell.title.text  = @"聊天置顶";
                [dialogueGroupSettingTableViewCell.bottomView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH ,  1)];
                dialogueGroupSettingTableViewCell.switchBtn.on = [_dialogueListEntity.isShowTop boolValue];
                dialogueGroupSettingTableViewCell.switchBtn.tag = 0;
            }
                break;
            case 2:
            {
                [dialogueGroupSettingTableViewCell.bottomView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH ,  15)];
                dialogueGroupSettingTableViewCell.arrayImageView.hidden= YES;
                dialogueGroupSettingTableViewCell.title.text  = @"新消息通知";
                //                dialogueGroupSettingTableViewCell.bottomView.hidden = YES;
                dialogueGroupSettingTableViewCell.switchBtn.on = [_dialogueListEntity.isMsgNotification boolValue];
                dialogueGroupSettingTableViewCell.switchBtn.tag = 1;
            }
                break;
            case 3:
            {
                [dialogueGroupSettingTableViewCell.bottomView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH ,  15)];
                dialogueGroupSettingTableViewCell.arrayImageView.hidden= YES;
                dialogueGroupSettingTableViewCell.title.text  = @"显示群成员";
                dialogueGroupSettingTableViewCell.switchBtn.on = [_dialogueListEntity.isShowMember boolValue];
                dialogueGroupSettingTableViewCell.switchBtn.tag = 2;
            }
                break;
            case 4:
            {
                dialogueGroupSettingTableViewCell.title.text  = @"清空聊天消息";
                [dialogueGroupSettingTableViewCell.bottomView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH ,  1)];
                dialogueGroupSettingTableViewCell.switchBtn.hidden = YES;
            }
                break;
            case 5:
            {
                dialogueGroupSettingTableViewCell.title.text  = @"群名片";
                [dialogueGroupSettingTableViewCell.bottomView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH ,  1)];
                dialogueGroupSettingTableViewCell.switchBtn.hidden = YES;
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 1, 38, 38)];
                UIImage *image = [QRCodeGenerator qrImageForString:_groupId imageSize:38];
                [imageView setImage:image];
                
                imageView.tag = 6;
                //                groupName.textColor = UIColorFromRGB(KC8C8C8Color);
                for (UIView * view in  dialogueGroupSettingTableViewCell.subviews) {
                    if (view.tag == 6) {
                        [view removeFromSuperview];
                    };
                }
                [dialogueGroupSettingTableViewCell addSubview:imageView];
            }
                break;
            default:
                break;
        }
        
        
    }
    
    return dialogueGroupSettingTableViewCell;
}
//点击条目
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int basecode = 1;
    if ([_owerId isEqualToString:APPDELEGATE.UserID]) {
        basecode = 0;
    }
    
    
    if (indexPath.row ==0) {
        //管理群成员
        EXGroupMemberViewController *groupMemberCtl = [[EXGroupMemberViewController alloc]init];
        groupMemberCtl.dialogueListEntity = _dialogueListEntity;
        [self.navigationController pushViewController:groupMemberCtl animated:YES];

    }
    else
    {
        switch (indexPath.row + basecode) {
            case 1:
            {
                //修改群名称
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"更改群名称"
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定",nil];
                [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
               
                alert.tag = 0;
                [alert show];
            }
                break;
            case 2: // 聊天置顶
            {
                
            }
                break;
            case 3: // 新消息提醒
            {
                
            }
                break;
            case 4: // 显示群成员
            {
                
            }
                break;
            case 5: //清理消息
            {
                //初始化AlertView
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否清空聊天记录？"
                                                               message:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                     otherButtonTitles:@"确定",nil];
                //显示AlertView
                alert.tag = 1;
                [alert show];
            }
                break;
            case 6: // 群名片
            {
                EXGroupCardViewController * groupCardCtl = [[EXGroupCardViewController alloc]init];
                groupCardCtl.groupId = _groupId;
                [self.navigationController pushViewController:groupCardCtl animated:YES];
                
            }
                break;
                
            default:
                break;
        }

    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( alertView.tag == 1) {
        if (buttonIndex ==1) {
          
            [SVProgressHUD showWithStatus: @"正在删除.."];
            
            [DBHelper inTransaction:^(FMDatabase *db) {
                [DBMessageManager deleteByGroupId:_groupId FMDatabase:db DelResult:^(Boolean result) {
                    [SVProgressHUD  dismiss];
                }];
            }];
        }
    }
    else if (alertView.tag == 0)
    {
        if (buttonIndex ==1) {
            UITextField * text = [alertView textFieldAtIndex:0];
            if ([Utils isBlankString:text.text]) {
                ALERT(@"请输入群名称");
                return ;
            }
          
            [SVProgressHUD showWithStatus:@"正在更改群名称"];
            
            [EXGroupNetManager configGroupName:_groupId userID:APPDELEGATE.UserID groupName:text.text success:^(int resultCode, id responseObject) {
                if (resultCode == 0) {
                    [DBHelper inTransaction:^(FMDatabase *db) {
                        _dialogueListEntity.groupName = text.text;
                        [DBDialogueListManager updateByID:_groupId FMDatabase:db DialogueListEntity:_dialogueListEntity UpdateResult:^(Boolean result) {
                            [DBDialogueListManager  queryByID:_groupId FMDatabase:db QueryResult:^(DialogueListEntity *result) {
                                _dialogueListEntity = result;
                                _owerId = _dialogueListEntity.groupOwer;
                                [_tableView reloadData];
                            }];
                        }];
                    }];
                }
                else
                {
                    WDLog(@"更改群名称失败");
                }
                [SVProgressHUD dismiss];
            } failure:^(NSError *error) {
                WDLog(@"更改群名称失败");
            }];
        }
    }
   
  
}


//点击开关
-(void)switchChanged:(UIButton*)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    switch (switchButton.tag) {
        case 0: // 消息置顶
        {
            _dialogueListEntity.isShowTop = [NSNumber numberWithBool:isButtonOn];
            _dialogueListEntity.showTopSetTime = [Utils getCurrentTime];
            
        }
            break;
        case 1: // 新消息通知
        {
            _dialogueListEntity.isMsgNotification = [NSNumber numberWithBool:isButtonOn];
           
        }
            break;
        case 2: //显示群成员
        {
             _dialogueListEntity.isShowMember = [NSNumber numberWithBool:isButtonOn];
        }
            break;
        default:
            break;
    }
    
    [DBHelper inTransaction:^(FMDatabase *db) {
        [DBDialogueListManager updateByID:_groupId FMDatabase:db DialogueListEntity:_dialogueListEntity UpdateResult:^(Boolean result) {
//            WDLog(@"%d", result);
        }];
    }];
}


-(void)actionPress:(UIButton*)sender
{
  
    
    if (sender.tag == 0) { //退出群
       [SVProgressHUD showWithStatus:@"正在退出群"];
        [EXGroupNetManager quitGroup:_groupId userID:APPDELEGATE.UserID success:^(int resultCode, id responseObject) {
            if (resultCode ==0) {
                 [self delFromDb];
            }
            else
            {
               WDLog(@"退出群网络交互出错 Code = %d", resultCode);
              [SVProgressHUD  dismiss];
            }
              
        } failure:^(NSError *error) {
            WDLog(@"退出群网络交互出错");
            [SVProgressHUD  dismiss];
        }];
    }
    else //解散群
    {
        [SVProgressHUD showWithStatus:@"正在解散群"];
        [EXGroupNetManager destroyGroup:_groupId userID:APPDELEGATE.UserID success:^(int resultCode, id responseObject) {
            if (resultCode ==0) {
                [self delFromDb];
            }
            else
            {
                 WDLog(@"解散群网络交互出错 Code = %d", resultCode);
               [SVProgressHUD dismiss];
            }
            
        } failure:^(NSError *error) {
            WDLog(@"解散群网络 交互出错");
            [SVProgressHUD dismiss];

        }];
   }
    
}

-(void)delFromDb
{
    [DBHelper inTransaction:^(FMDatabase *db) {
        [DBDialogueListManager deleteByGroupId:_groupId FMDatabase:db DelResult:^(Boolean result) {
            if (result) {
                [DBDialogueMemberManager deleteByGroupId:_groupId FMDatabase:db DelResult:^(Boolean result) {
                    if (result) {
                        [DBMessageManager deleteByGroupId:_groupId FMDatabase:db DelResult:^(Boolean result) {
                            if (result) {
                                NSLog(@"删除群相关内容ok");
                               [SVProgressHUD  dismiss];
                              
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            }
                            else
                            {
                                NSLog(@"删除群消息 error");
                                [SVProgressHUD  dismiss];
                            }
                        }];
                    }
                    else
                    {
                        NSLog(@"删除群成员 error");
                       [SVProgressHUD  dismiss];
                    }
                }];
            }
            else
            {
                NSLog(@"删除群列表 error");
                [SVProgressHUD  dismiss];
            }
        }];
      }];
}


@end
