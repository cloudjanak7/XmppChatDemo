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
   
    _txtUsername.text=@"kollyde999@localhost";
    _txtPassword.text=@"kollyde999";
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnLoginAction:(id)sender {
 
    [self loginUserForChat];
    
    DialogViewController* vc=[self.storyboard instantiateViewControllerWithIdentifier:@"DialogViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    

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
