//
//  DialogViewController.m
//  XmppChatDemo
//
//  Created by Infoicon on 11/05/17.
//  Copyright © 2017 InfoiconTechnologies. All rights reserved.
//

#import "DialogViewController.h"
#import "DialogTableViewCell.h"
#import "DBManager.h"
#import "DialogHistory.h"
#import "ChatViewController.h"
@interface DialogViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *arrayDialog;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation DialogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

-(void)viewWillAppear:(BOOL)animated{

     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTableOnIncomingMessage) name:@"OnIncomingMessageUpdateDialogHistory" object:nil];
    
    DBManager *dataManager = [[DBManager alloc]initWithDB:DATABASE_NAME];
    arrayDialog = [dataManager GetDialogHistoryData];
    [_tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{

    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"OnIncomingMessageUpdateDialogHistory" object:nil];
}

-(void)updateTableOnIncomingMessage{

    DBManager *dataManager = [[DBManager alloc]initWithDB:DATABASE_NAME];
    arrayDialog = [dataManager GetDialogHistoryData];
    [_tableView reloadData];
}


#pragma mark:- Tableview delegate and datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return arrayDialog.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    DialogTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DialogTableViewCell"];

    DialogHistory *dialog           = arrayDialog[indexPath.row];
    cell.lblUsername.text           = dialog.last_username;
    cell.lblLastMessage.text        = dialog.last_message;
    cell.lblDate.text               = dialog.last_message_date;
    
    if (dialog.unread_count == 0){
        cell.lblUnreadMessageCount.hidden=YES;
    }else{
         cell.lblUnreadMessageCount.hidden=NO;
        cell.lblUnreadMessageCount.text = [NSString stringWithFormat:@"%d",dialog.unread_count];
    }
    
   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DialogHistory *dialog= arrayDialog[indexPath.row];
    ChatViewController* vc=[[ChatViewController alloc]initWithUser:[dialog.last_username stringByAppendingString:@"@localhost"]];
    [self.navigationController pushViewController:vc animated:YES];
    
   
    dialog.unread_count=0;
    DBManager *dataManager=[[DBManager alloc]initWithDB:DATABASE_NAME];
    [dataManager insertAndUpdateDialogHistoryWithArrayUsingTrasaction:@[dialog]];
    
}


@end
