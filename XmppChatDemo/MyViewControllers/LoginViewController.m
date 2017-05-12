//
//  ViewController.m
//  XmppChatDemo
//
//  Created by Infoicon on 09/05/17.
//  Copyright © 2017 InfoiconTechnologies. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "ChatViewController.h"
#import "ChatHistory.h"
#import "DBManager.h"
#import "DialogViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //Native chat User
   
    _txtUsername.text=@"arvind@localhost";
    _txtPassword.text=@"arvind";
    
    DBManager *objDB=[[DBManager alloc]initWithDB:DATABASE_NAME];
    NSArray *array=[objDB getChatHistoryData:TABLE_NAME_CHAT_HISTORY fromUser:@"arvind" toUser:@"raj"];
    
    //[self saveAndGetChatHistory];
}

-(void)saveAndGetChatHistory{

    ChatHistory *chat=[[ChatHistory alloc] init];
    chat.chat_id=@"1";
    chat.from_username=@"raj";
    chat.to_username=@"arvind";
    chat.chat_message=@"hii";
    chat.chat_timestamp=@"";
   
    DBManager *objDB=[[DBManager alloc]initWithDB:DATABASE_NAME];
    
    NSArray *ar=[[NSArray alloc]initWithObjects:chat, nil];
    [objDB insertAndUpdateChatWithArrayUsingTrasaction:ar];
    
    NSArray *array=[objDB getChatHistoryData:TABLE_NAME_CHAT_HISTORY];
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnLoginAction:(id)sender {
    
    [self loginUserForChat];
    
    NSString *toUserName;
    if ([_txtUsername.text isEqualToString:@"arvind@localhost"]){
       toUserName=@"sandeep@localhost";
    }else{
       toUserName=@"arvind@localhost";
    }
    
    DBManager *dataManager = [[DBManager alloc]initWithDB:DATABASE_NAME];
    NSArray *arrayDialog = [dataManager GetDialogHistoryData];
    
    if(arrayDialog.count>0){
        DialogViewController* vc=[self.storyboard instantiateViewControllerWithIdentifier:@"DialogViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        ChatViewController* vc=[[ChatViewController alloc]initWithUser:toUserName];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark- Chat Login

-(void)loginUserForChat{
    
    
    NSString* chatUser=_txtUsername.text;
    NSString* password=_txtPassword.text;
    
    [self setChatUserWithName:chatUser pass:password];
    
    
    BOOL connected = NO;
    
    if([chatUser isEqualToString:@""])
        [[self appDelegate] disconnect];
    
    connected = [[self appDelegate] connect];
    NSLog(@"*** %@ = connected = %i",chatUser, connected);

    
    
}

-(void)setChatUserWithName:(NSString*)name pass:(NSString*)pass{
    
    name=!name ? @"": name;
    pass=!pass ? @"": pass;
    
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] setObject:pass forKey:@"userPassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
