//
//  EXCreateGroupViewController.m
//  Express
//
//  Created by owen on 15/11/27.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "EXCreateGroupViewController.h"
#import "DBHelper.h"
#import "DBFriendManager.h"
#import "EXHttpHelper.h"
#import "EXCreateGroupTableViewCell.h"
#import "FriendEntity.h"
#import "EXGroupNetManager.h"
#import "EXDialogueDetailViewController.h"
#import "DBDialogueMemberManager.h"

@interface EXCreateGroupViewController ()

@end

@implementation EXCreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_isCreate) {
        [self setTitle:@"创建群聊"];
    }
    else
    {
        [self setTitle:@"添加好友"];
    }

    [self setLeftBarImgBtn:nil];
    [self configUI];
    [self initData];
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
    
}

/**
 *  从数据库 查询数据初始化
 */
-(void)initData
{
    if (_unavailableFriDic == nil) {
        _unavailableFriDic = [[NSMutableArray alloc]init];
    }
    
    if (_selectedFriDic == nil) {
        _selectedFriDic = [[NSMutableArray alloc]init];
    }
    else{
        //更改按钮状态
        if (_selectedFriDic.count >0) {
            [self setRightBarTextBtn:[NSString stringWithFormat:@"确定(%lu)", (unsigned long)_selectedFriDic.count]];
        }
        else
        {
            [self setRightBarTextBtn:@""];
        }

    }
    
    [DBHelper inTransaction:^(FMDatabase *db) {
        [DBFriendManager queryAll:IsFriend FMDatabase:db QueryAllResult:^(NSMutableArray *result) {
            self.friendsDic = result;
            [_tableView reloadData];
//            [_tableView.header endRefreshing];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [_friendsDic count];
}

// overwrite
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
// overwrite
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *FirendId = @"FirendId";
    EXCreateGroupTableViewCell *friendTableViewCell = [tableView dequeueReusableCellWithIdentifier:FirendId];
    if (friendTableViewCell == nil) {
        friendTableViewCell = [[EXCreateGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirendId];
    }
    FriendEntity *bean =[_friendsDic objectAtIndex:[indexPath row]];
    friendTableViewCell.name.text  = bean.nickName;
    NSString * image_url = [NSString stringWithFormat:@"%@%@",KLOGO_ROOT_PATH, bean.avatar];
    [friendTableViewCell.imgLogo setImageWithURL:[NSURL URLWithString:image_url]];
    friendTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if(_isCreate)
    {
        [friendTableViewCell.checkBtn addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
        friendTableViewCell.checkBtn.tag = [indexPath row];
    }
    else
    {
        if ([_unavailableFriDic containsObject:bean.focusUserName]) {
            friendTableViewCell.checkBtn.enabled = NO;
        }
        else
        {
            [friendTableViewCell.checkBtn addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
            friendTableViewCell.checkBtn.tag = [indexPath row];
            friendTableViewCell.checkBtn.enabled = YES;

        }
    }
    if ([_selectedFriDic indexOfObject:bean.focusUserName] != NSNotFound)
    {
        friendTableViewCell.checkBtn.selected = YES;
    }
    else
    {
        friendTableViewCell.checkBtn.selected = NO;
    }
    
    
    return  friendTableViewCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    EXCreateGroupTableViewCell *friendTableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    [self checkboxClick:friendTableViewCell.checkBtn];
  
    
}
-(void)checkboxClick:(UIButton *)btn
{
    if (btn.isEnabled == YES) {
        int index = btn.tag;
        btn.selected = !btn.selected;
        FriendEntity * bean = [_friendsDic objectAtIndex:index];
        if (btn.isSelected) {
            [_selectedFriDic addObject:bean.focusUserName];
        }
        else
        {
            [_selectedFriDic removeObject:bean.focusUserName];
        }
        //更改按钮状态
        if (_selectedFriDic.count >0) {
            [self setRightBarTextBtn:[NSString stringWithFormat:@"确定(%lu)", (unsigned long)_selectedFriDic.count]];
        }
        else
        {
            [self setRightBarTextBtn:@""];
        }
 
    }
    else
    {
        ALERT(@"该好友已经是群成员了");
    }
    
}


-(void)rightBtnAction:(id)sender
{
//    if (_selectedFriDic.count >0) {
//         [_delegate selectedFriDic:_selectedFriDic];
//         [self.navigationController popViewControllerAnimated:YES];
//     }
   
    if (_isCreate) {
       [SVProgressHUD showWithStatus:@"正在创建群"];  
        __block EXCreateGroupViewController *weakSelf = self;
        [EXGroupNetManager createGroup:APPDELEGATE.UserID groupList:_selectedFriDic success:^(int resultCode, id responseObject) {
            if (resultCode == 0) {
                
                [weakSelf getGroupInfo:[responseObject objectForKey:@"ok"]];
            }
        } failure:^(NSError *error) {
            WDLog(@"创建群失败");
            [SVProgressHUD dismiss];
        }];
    }
    else
    {
//        WDLog(@"此处需要进行添加成员操作");
       [SVProgressHUD showWithStatus:@"正在添加成员"];
       
        [EXGroupNetManager addFriendstoGroup:_groupid userID:APPDELEGATE.UserID friendList:_selectedFriDic success:^(int resultCode, id responseObject) {
            [self getGroupInfo:_groupid];
//            [_hud show:NO];

        } failure:^(NSError *error) {
          WDLog(@"添加成员失败");
          [SVProgressHUD  dismiss];
        }];
    }
}

-(void)getGroupInfo:(NSString *) groupid{
     [EXGroupNetManager getGroupInfoList:groupid userID:APPDELEGATE.UserID success:^(int resultCode, id responseObject) {
         if (resultCode == 0) {
             DialogueListEntity*  dialogueListEntity = [[DialogueListEntity alloc]initWithDictionary:responseObject error:nil];
             dialogueListEntity.groupId = groupid;
             [self saveGroupInfoToDB:dialogueListEntity];
            
         }
     } failure:^(NSError *error) {
           WDLog(@"获取群信息失败");
            [SVProgressHUD dismiss];
     }];
}

-(void) saveGroupInfoToDB:(DialogueListEntity*) dialogueListEntity
{

   [DBHelper inTransaction:^(FMDatabase *db) {
       if (_isCreate) {
           [DBDialogueListManager insert:dialogueListEntity FMDatabase:db GroupType:Group InsertResult:^(Boolean result) {
               if (result) {
                   EXDialogueDetailViewController * dialogueDetailCtl = [[EXDialogueDetailViewController alloc]init];
                   dialogueDetailCtl.groupId = dialogueListEntity.groupId;
                   dialogueDetailCtl.groupType = [NSNumber numberWithBool:YES];
                   NSMutableArray * array =[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
                   //删除最后一个，也就是自己
                   [array removeObjectAtIndex:array.count-1];
                   //添加要跳转的controller
                   [array addObject:dialogueDetailCtl];
                   [self.navigationController setViewControllers:array animated:YES];
               }
               [SVProgressHUD dismiss];
           }];

       }
       else
       {
           _dialogueListEntity.groupMemberList = dialogueListEntity.groupMemberList;
           _dialogueListEntity.groupMemberCount = dialogueListEntity.groupMemberCount;
           
           [DBDialogueListManager updateByID:_groupid FMDatabase:db DialogueListEntity:_dialogueListEntity UpdateResult:^(Boolean result) {
               [DBDialogueMemberManager insertArray:dialogueListEntity.groupMemberList FMDatabase:db WithGroupId:dialogueListEntity.groupId InsertResult:^(Boolean result) {
                   [SVProgressHUD dismiss];
                   //               WDLog(@"数据更新状态 ：%d", result);
                   [self.navigationController popViewControllerAnimated:YES];

               }];
         }];
           
       }
   }];
}




@end
