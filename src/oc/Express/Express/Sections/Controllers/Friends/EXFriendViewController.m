//
//  FriendViewController.m
//  Express
//
//  Created by owen on 15/11/3.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "EXFriendViewController.h"
#import "DBFriendManager.h"
#import "EXHttpHelper.h"
#import "DBFriendManager.h"
#import "EXFriendTableViewCell.h"
#import "DBHelper.h"
#import "EXDialogueDetailViewController.h"
#import "DBDialogueListManager.h"


@interface EXFriendViewController ()

@end

@implementation EXFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"好友"];
    [self configUI];
    [self initData];
    [self getAllFriends];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAllFriends) name:@"loginSuccess" object:nil];
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
    
    __weak EXFriendViewController *weakSelf = self; //防止循环引用
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getAllFriends];
    }];
    
}

/**
 *  从数据库 查询数据初始化
 */
-(void)initData
{
    
//    [DBFriendManager queryAll:IsFriend QueryAllResult:^(NSMutableArray *result) {
////    [DBFriendManager queryAll:All QueryAllResult:^(NSMutableArray *result) {
//        NSLog(@"%@", result);
//        self.friendsDict = result;
//        [_tableView reloadData];
//        [_tableView.header endRefreshing];
//    }];
    [DBHelper inTransaction:^(FMDatabase *db) {
        [DBFriendManager queryAll:IsFriend FMDatabase:db QueryAllResult:^(NSMutableArray *result) {
            //    [DBFriendManager queryAll:All QueryAllResult:^(NSMutableArray *result) {
//            NSLog(@"%@", result);
            self.friendsDict = result;
            [_tableView reloadData];
            [_tableView.header endRefreshing];
        }];
    }];
}
/**
 *   获取好友列表
 */
-(void) getAllFriends
{
//    NSLog(@"开始拉取好友");
    NSDictionary *parameters = @{@"userName":APPDELEGATE.userName, @"focusType":@"all"};
    [EXHttpHelper POST:KACTION_FRIENDS_LIST deviceType:KDEVICE_TYPE_WT parameters:parameters success:^(int resultCode, id responseObject) {
        
            switch (resultCode) {
            case 0: //成功
            {
                APPDELEGATE.gender = [responseObject objectForKey:@"gender"];
                APPDELEGATE.saveConfig;
                NSMutableArray   *friendsList = [FriendEntity arrayOfModelsFromDictionaries:[responseObject objectForKey:@"focusList"]];
//                [ DBFriendManager insertArray:friendsList InsertArrayResult:^(Boolean result) {
//                    NSLog(@"输入插入状态 = %@", result?@"YES":@"NO"); //插入或者更新的结果
//                }];
                if (friendsList == nil) {
                    return ;
                }
                [DBHelper inTransaction:^(FMDatabase *db) {                    
                    [ DBFriendManager insertArray:friendsList FMDatabase:db InsertArrayResult:^(Boolean result) {
                            NSLog(@"输入插入状态 = %@", result?@"YES":@"NO"); //插入或者更新的结果
                            [DBFriendManager queryAll:IsFriend FMDatabase:db QueryAllResult:^(NSMutableArray *result) {
                                //    [DBFriendManager queryAll:All QueryAllResult:^(NSMutableArray *result) {
//                                NSLog(@"%@", result);
                                self.friendsDict = result;
                                [_tableView reloadData];
                                [_tableView.header endRefreshing];
                            }];
                    }];
                }];
                
               
             }
                break;
            
            default:
                {
                    [_tableView.header endRefreshing];
                    NSLog(@"未知错误, 服务器返回异常");
                }
                break;
        }

    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [_friendsDict count];
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
    EXFriendTableViewCell *friendTableViewCell = [tableView dequeueReusableCellWithIdentifier:FirendId];
    if (friendTableViewCell == nil) {
        friendTableViewCell = [[EXFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirendId];
    }
    FriendEntity *bean =[_friendsDict objectAtIndex:[indexPath row]];
    friendTableViewCell.name.text  = bean.nickName;
    NSString * image_url = [NSString stringWithFormat:@"%@%@",KLOGO_ROOT_PATH, bean.avatar];
    [friendTableViewCell.imgLogo setImageWithURL:[NSURL URLWithString:image_url]];
    friendTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return  friendTableViewCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EXDialogueDetailViewController  *detailListCtl = [[EXDialogueDetailViewController alloc]init];
    FriendEntity *bean =[_friendsDict objectAtIndex:[indexPath row]];
    
    detailListCtl.groupId = bean.focusUserName;
    detailListCtl.groupType = [NSNumber numberWithBool:NO];
    [self.navigationController pushViewController:detailListCtl animated:YES];
  //更新数据库， 设置角标和新消息状态
    [DBHelper inTransaction:^(FMDatabase *db) {
         [DBDialogueListManager queryByID:bean.focusUserName FMDatabase:db QueryResult:^(DialogueListEntity *result) {
             DialogueListEntity *dialogueListbean =result;
             if (dialogueListbean.groupId != nil)
             {
                         dialogueListbean.hasNewMessage = [NSNumber numberWithBool:NO];
                         dialogueListbean.NewmessageCount = [NSNumber numberWithInt:0];
                         [DBDialogueListManager updateByID:dialogueListbean.groupId FMDatabase:db DialogueListEntity:dialogueListbean UpdateResult:^(Boolean result) {
                             if (result) {
                                 [APPDELEGATE notifi_updateDialogueList:db]; // 发消息更新ui
                                  NSLog(@"消息更新成功");
                             }
                             else
                             {
                                 DLog(@"消息更新失败");
                             }
                         }];
             }
             else
             {
                 NSLog(@"之前没有对话内容, 无需更新");
             }
         }];

    }];
}
@end
