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
#import "NSString+Utils.h"
#import "Alert.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "UsersViewController.h"
@interface DialogViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *arrayDialog;

}
@property (weak, nonatomic) IBOutlet UITextField *txtCreateGroup;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation DialogViewController

#pragma mark - App Delegate Custom Methods

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigation];
}

-(void)configNavigation{

    UIBarButtonItem *barButtonAddUser = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addUser)];
                                         
    self.navigationItem.rightBarButtonItem = barButtonAddUser;
    
}

-(void)addUser{

    UsersViewController *objVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UsersViewController"];
    [self.navigationController pushViewController:objVC animated:YES];
    
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
  
    cell.lblLastMessage.text        = dialog.last_message;
    cell.lblDate.text               = dialog.last_message_date;
    
    if ([dialog.chat_id isEqualToString:@"0"]){
        // Single chat
        cell.lblUsername.text           = dialog.last_username;
    }else{
        //Group chat
        cell.lblUsername.text           = dialog.chat_id;
    }
    
    
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
    
    if ([dialog.chat_id isEqualToString:@"0"]){
        // Single chat
       
        ChatViewController* vc=[[ChatViewController alloc]initWithUser:[dialog.last_username stringByAppendingString:@"@localhost"]];
        [self.navigationController pushViewController:vc animated:YES];
       
    }else{
        //Group chat
        
         [[XMPPManager sharedManager]joinOrCreateRoom:dialog.chat_id];
       
        ChatViewController* vc=[[ChatViewController alloc]initWithUser:[dialog.chat_id stringByAppendingString:@"@localhost"]];
        vc.isGroupChat = YES;
        [self.navigationController pushViewController:vc animated:YES];
       
    }
    
   
    
   
    dialog.unread_count=0;
    DBManager *dataManager=[[DBManager alloc]initWithDB:DATABASE_NAME];
    [dataManager insertAndUpdateDialogHistoryWithArrayUsingTrasaction:@[dialog]];
    
}


#pragma mark: group chat
// Group chat
- (IBAction)btnCreateGroup:(id)sender {
    
    if (_txtCreateGroup.text.length==0){
        [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter group name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
        
    }else{
    
          NSString *userName=[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
        
        NSDate*date=[NSString getCurrentDateFromString:[NSString getCurrentTime]];
        NSString* time=[[Alert getDateFormatWithString:GET_FORMAT_TYPE] stringFromDate:date];
        
        DialogHistory* dialogHistory=[[DialogHistory alloc]init];
        dialogHistory.dialog_id=_txtCreateGroup.text;
        dialogHistory.last_message=@"no message";
        dialogHistory.last_username=userName;
        dialogHistory.last_message_date=time;
        dialogHistory.created_date=time;
        dialogHistory.unread_count=0;
        dialogHistory.chat_id=_txtCreateGroup.text;
      
        DBManager *dataManager = [[DBManager alloc]initWithDB:DATABASE_NAME];
 
        //Insert Data into database
        [dataManager insertAndUpdateDialogHistoryWithArrayUsingTrasaction:@[dialogHistory]];
        
        arrayDialog = [dataManager GetDialogHistoryData];
        
        [[XMPPManager sharedManager]joinOrCreateRoom:_txtCreateGroup.text];
        
        // [[self appDelegate]joinOrCreateRoom:_txtCreateGroup.text];
        [_tableView reloadData];
        
    }
}




@end
