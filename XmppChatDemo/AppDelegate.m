//
//  AppDelegate.m
//  XmppChatDemo
//
//  Created by Infoicon on 09/05/17.
//  Copyright © 2017 InfoiconTechnologies. All rights reserved.
//

#import "AppDelegate.h"
#import "DBManager.h"
#import "NSString+Utils.h"
#import "Alert.h"
#import "Constant.h"
#import "DialogHistory.h"
#import "ChatViewController.h"
#import "XMPPManager.h"

@interface AppDelegate ()
{
    dispatch_queue_t background_queue;
    
    dispatch_queue_t getBalanceQueue;
    
    dispatch_queue_t updateTransactionQueue;
    
    dispatch_queue_t updateContactQueue;
}

@property (nonatomic) XMPPManager *xmppManager;
@end

@implementation AppDelegate
@synthesize xmppStream;
@synthesize xmppRoster;
@synthesize xmppReconnect;
@synthesize xmppRosterMemStorage;
@synthesize xmppRoom;
@synthesize _chatDelegate;
@synthesize _messageDelegate;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Create Database
    BOOL isCreated=[DBManager createEditableCopyOfDatabaseIfNeeded:DATABASE_NAME];
    if(isCreated){
        NSLog(@"DATABASE CREATE SUCCESS");
    }else{
        NSLog(@"DATABASE CREATE FAILED");
    }
     self.xmppManager = [XMPPManager sharedManager];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /********Chatting from Ejabberd**********/
   // [self disconnect];
     [self.xmppManager disconnect];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /********Chatting from Ejabberd**********/

    [self.xmppManager connect];

}

- (void)applicationWillTerminate:(UIApplication *)application {}


@end
