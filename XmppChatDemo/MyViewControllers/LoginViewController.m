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
#import "XMPPRoomMemoryStorage.h"
#import "XMPPRoom.h"
#import "GroupDialogViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@property (nonatomic) XMPPManager *xmppManager;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.xmppManager = [XMPPManager sharedManager];
    //Native chat User
   
    _txtUsername.text=@"infoiconuser5@localhost";
    _txtPassword.text=@"infoiconuser5";
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnLoginAction:(id)sender {
    
    
    
    [self loginUserForChat];
//      GroupDialogViewController* vc=[self.storyboard instantiateViewControllerWithIdentifier:@"GroupDialogViewController"];
//    [self.navigationController pushViewController:vc animated:YES];
    
    
    DialogViewController* vc=[self.storyboard instantiateViewControllerWithIdentifier:@"DialogViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    
//    NSString *toUserName;
//    if ([_txtUsername.text isEqualToString:@"infoiconuser3@localhost"]){
//        toUserName=@"infoiconuser2@localhost";
//    }else{
//       toUserName=@"infoiconuser3@localhost";
//    }
//    
//    DBManager *dataManager = [[DBManager alloc]initWithDB:DATABASE_NAME];
//    NSArray *arrayDialog = [dataManager GetDialogHistoryData];
//    
//    if(arrayDialog.count>0){
//        DialogViewController* vc=[self.storyboard instantiateViewControllerWithIdentifier:@"DialogViewController"];
//        [self.navigationController pushViewController:vc animated:YES];
//        
//    }else{
//        ChatViewController* vc=[[ChatViewController alloc]initWithUser:toUserName];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}

#pragma mark- Chat Login

-(void)loginUserForChat{
    
    
    NSString* chatUser=_txtUsername.text;
    NSString* password=_txtPassword.text;
    
    [self setChatUserWithName:chatUser pass:password];
    
    
    BOOL connected = NO;
    
    if([chatUser isEqualToString:@""]){
    
    }else{
         [self.xmppManager connect];
    }
        //[[self appDelegate] disconnect];
    
    //connected = [[self appDelegate] connect];
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
