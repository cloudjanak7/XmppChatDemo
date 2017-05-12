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

@interface AppDelegate ()
{
    dispatch_queue_t background_queue;
    
    dispatch_queue_t getBalanceQueue;
    
    dispatch_queue_t updateTransactionQueue;
    
    dispatch_queue_t updateContactQueue;
}
@end

@implementation AppDelegate
@synthesize xmppStream;
@synthesize xmppRoster;
@synthesize xmppReconnect;
@synthesize xmppRosterMemStorage;
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
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /********Chatting from Ejabberd**********/
    [self disconnect];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /********Chatting from Ejabberd**********/
    
    [self setupStream];
    BOOL connected = NO;
    connected = [self connect];
    NSLog(@"*** connected = %i", connected);
    
    
    /********Calling from Sip**********/
    
   // [[XCPjsua sharedXCPjsua] sipInit];
    /*
    [self loginUserForCall];
    
    
    
    //Update Transaction History
    BOOL isHistory = [[NSUserDefaults standardUserDefaults] boolForKey:isTRANSACTION];
    if(isHistory)   [self callUpdateTransactionDetailWS];
    
    
    if([_chatDelegate respondsToSelector:@selector(buddyOnlineList:)])
        [_chatDelegate buddyOnlineList:[onlineBuddies mutableCopy]];
     */
}

- (void)applicationWillTerminate:(UIApplication *)application {}

#pragma mark - XMPP Custom methods

- (XMPPStream *)getXmppStream{
    if ( xmppStream == nil ) {
        
        xmppStream = [[XMPPStream alloc] init];
        [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        
    }
    
    return xmppStream;
}

- (XMPPRoster *)getXmppRoster{
    if ( xmppRoster == nil ) {
        xmppRosterMemStorage = [[XMPPRosterMemoryStorage alloc] init];
        xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterMemStorage
                                                 dispatchQueue:dispatch_get_main_queue()];
        xmppRoster.autoFetchRoster = YES;
        xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
        
        [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [xmppRoster activate:xmppStream];
        
        
        
    }
    
    return xmppRoster;
}

//- (XMPPStream *)getXmppStream1{
//    if ( xmppStream1 == nil ) {
//        
//        xmppStream1 = [[XMPPStream alloc] init];
//        [xmppStream1 addDelegate:self delegateQueue:dispatch_get_main_queue()];
//        
//        
//    }
//    
//    return xmppStream1;
//}
//
//- (XMPPRoster *)getXmppRoster1{
//    if ( xmppRoster1 == nil ) {
//        xmppRosterMemStorage1 = [[XMPPRosterMemoryStorage alloc] init];
//        xmppRoster1 = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterMemStorage1
//                                                  dispatchQueue:dispatch_get_main_queue()];
//        xmppRoster1.autoFetchRoster = YES;
//        xmppRoster1.autoAcceptKnownPresenceSubscriptionRequests = YES;
//        
//        [xmppRoster1 addDelegate:self delegateQueue:dispatch_get_main_queue()];
//        [xmppRoster1 activate:xmppStream1];
//        
//        
//        
//    }
//    
//    return xmppRoster1;
//}


- (void)setupStream{
    
    //self.jabberClass=[JabberClass sharedJabbered];
    [self getXmppStream];
    
    [self getXmppRoster];
    
    //init Reconnect
    xmppReconnect = [[XMPPReconnect alloc] init];
    
    [xmppReconnect         activate:xmppStream];
    
    // Specify your server's IP address
    [xmppStream setHostName:@"139.162.164.98"];//SIP_CHATTING_SERVER];
    
    // Specify your host port
    [xmppStream setHostPort:5222];//SIP_CHATTING_PORT];
    
#if !TARGET_IPHONE_SIMULATOR
    {
        //let xmpp run in the background
        xmppStream.enableBackgroundingOnSocket = YES;
        
    }
#endif
    
    //[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // xmppStream.enableBackgroundingOnSocket=YES;
    
}

- (void)goOnline {
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
}

- (void)goOffline {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
}

- (BOOL)connect {
    
    [self setupStream];
    
    NSString *jabberID = [[NSUserDefaults standardUserDefaults] stringForKey:@"userID"];
    NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"userPassword"];
    
    NSLog(@"Chat user->%@",jabberID);
    NSLog(@"Password->%@",myPassword);
    
    if([jabberID isEqualToString:@""] || [myPassword isEqualToString:@""])
    {
        jabberID=nil;
        myPassword=nil;
    }
    
 
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    
    
    if (jabberID == nil || myPassword == nil) {
        
        return NO;
    }
    
    [xmppStream setMyJID:[XMPPJID jidWithString:jabberID]];
    password = myPassword;
    
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:[NSString stringWithFormat:@"Can't connect to server %@", [error localizedDescription]]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            //		[alertView release];
            
            
            
            
        });
        
        
        
        
        return NO;
    }
    
    return YES;
}

- (void)disconnect {
    
    [self goOffline];
    [xmppStream disconnect];
    [_chatDelegate didDisconnect];
    
}


#pragma mark -
#pragma mark XMPP delegates

- (void)xmppStreamWillConnect:(XMPPStream *)sender{
    
    NSLog(@"xmppStreamWillConnect");
    
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    
    NSLog(@"xmppStreamDidConnect");
    
   // isOpen = YES;
    NSError *error = nil;
    if(![[self xmppStream] authenticateWithPassword:password error:&error])
        NSLog(@"Error authenticating: %@", error);
    
    //        if(![[self xmppStream1] authenticateWithPassword:password1 error:&error])
    //                NSLog(@"Error authenticating: %@", error);
    
    
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    NSLog(@"xmppStreamDidAuthenticate");
    
    [self goOnline];
    
    //        [self goOnline1];
    
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
    
    NSLog(@"error->%@",error);
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    // message recived
 
    
    NSLog(@"SENDER:%@ MESSSAGE:%@",sender,message);
    
    /// NSMutableDictionary* userData=[[NSUserDefaults standardUserDefaults] objectForKey:@"info"];
    if([[message elementForName:@"body"]stringValue] != nil){ //&& userData){
          
          NSString *msg = [[message elementForName:@"body"] stringValue];
          NSString *from = [[message attributeForName:@"from"] stringValue];
          NSString *to = [[message attributeForName:@"to"] stringValue];
          NSLog(@"%@ %@",msg,from);
          
          NSDate*date=[NSString getCurrentDateFromString:[NSString getCurrentTime]];
          NSString* time=[[Alert getDateFormatWithString:GET_FORMAT_TYPE] stringFromDate:date];
          
          NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
          [m setObject:msg forKey:@"msg"];
          
          NSArray * arr = [from componentsSeparatedByString:@"/"];
          from=arr.count>1 ? arr[0] : from;
          
          [m setObject:from forKey:@"sender"];
          [m setObject:to forKey:@"receiver"];
        
          [_messageDelegate newMessageReceived:m];
          
        
        //Save Dialog History in Database
        
        DBManager *dataManager=[[DBManager alloc]initWithDB:DATABASE_NAME];
        NSString* dialogId=[self getNickNameFromUserName:from];
        
        NSString* queryCreationDate=[NSString stringWithFormat:@"select created_date from DIALOG_HISTORY where dialog_id=\"%@\"",dialogId];
        NSString* creationDate=[dataManager getCreationDate:queryCreationDate];
        
        NSString* queryUnread=[NSString stringWithFormat:@"select unread_count from DIALOG_HISTORY where dialog_id=\"%@\"",dialogId];
        int unread=[dataManager getUnreadCount:queryUnread];
        
        
        DialogHistory* dialogHistory=[[DialogHistory alloc]init];
        dialogHistory.dialog_id=dialogId;
        dialogHistory.last_message=msg;
        dialogHistory.last_username=dialogId;
        dialogHistory.last_message_date=time;
        dialogHistory.created_date=creationDate!=nil ? creationDate : time;
   
        if ([self isCurrentView])
                dialogHistory.unread_count=0;
        else
                dialogHistory.unread_count=unread+1;
        //Insert Data into database
        [dataManager insertAndUpdateDialogHistoryWithArrayUsingTrasaction:@[dialogHistory]];
        
        //===========SAVING IN DATABASE =================//
        ChatHistory *chat=[[ChatHistory alloc] init];
        chat.chat_id=@"0";
        chat.from_username=from;
        chat.to_username=to;
        chat.chat_message=msg;
        chat.chat_timestamp=time;
        NSArray *ar=[[NSArray alloc]initWithObjects:chat, nil];
        DBManager *objDB=[[DBManager alloc]initWithDB:DATABASE_NAME];
        [objDB insertAndUpdateChatWithArrayUsingTrasaction:ar];


        //Update Chat View
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OnIncomingMessageUpdateDialogHistory" object:nil userInfo:nil];
      }
   
    

 
    
    /*
    
    //load database here
    dataManager = [[DataBaseHandler alloc] initWithDB:DATABASE_NAME];
    
    //sender.myJID.user
    NSMutableDictionary* userData=[[NSUserDefaults standardUserDefaults] objectForKey:@"info"];
    
    if([[message elementForName:@"body"]stringValue] != nil && userData){
        NSString *msg = [[message elementForName:@"body"] stringValue];
        NSString *from = [[message attributeForName:@"from"] stringValue];
        NSString *to = [[message attributeForName:@"to"] stringValue];
        NSLog(@"%@ %@",msg,from);
        
        NSDate*date=[NSString getCurrentDateFromString:[NSString getCurrentTime]];
        NSString* time=[[Alert getDateFormatWithString:GET_FORMAT_TYPE] stringFromDate:date];
        
        NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
        [m setObject:msg forKey:@"msg"];
        
        
        NSArray * arr = [from componentsSeparatedByString:@"/"];
        from=arr.count>1 ? arr[0] : from;
        
        [m setObject:from forKey:@"sender"];
        
        [_messageDelegate newMessageReceived:m];
        
        
        
        //Save Dialog History in Database
        NSString* dialogId=[self getNickNameFromUserName:from];
        
        NSString* queryCreationDate=[NSString stringWithFormat:@"select creationDate from DialogHistory where dialogId=\"%@\"",dialogId];
        NSString* creationDate=[dataManager getCreationDate:queryCreationDate];
        
        NSString* queryUnread=[NSString stringWithFormat:@"select unread from DialogHistory where dialogId=\"%@\"",dialogId];
        int unread=[dataManager getUnreadCount:queryUnread];
        
        
        DialogHistory* dialogHistory=[[DialogHistory alloc]init];
        dialogHistory.dialogId=dialogId;
        dialogHistory.LastMessage=msg;
        dialogHistory.LastMessageUserId=dialogId;
        dialogHistory.LastMessageDate=time;
        dialogHistory.creationDate=creationDate!=nil ? creationDate : time;
        dialogHistory.unread=unread+1;
        //
        //Insert Data into database
        [dataManager insertAndUpdateDialogHistoryWithArrayUsingTrasaction:@[dialogHistory]];
        
        //                [dataManager showDialogHistoryData];
        
        
        BOOL result=[self isCurrentView];//Check- Chat view screen or not ?
        
        if(result){
            NSMutableDictionary* senderInfo=[NSMutableDictionary dictionary];
            
            [senderInfo setObject:from forKey:@"sender"];
            [senderInfo setObject:msg forKey:@"msg"];
            
            //Update Chat View
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OnIncomingMessageUpdateDialogHistory" object:nil userInfo:senderInfo];
            senderInfo=nil;
            
        }
        else{
            
            //Update Inbox View,Dash view
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OnIncomingMessage" object:nil userInfo:nil];
            
            [[SoundEffect sharedSoundEffect] messageToneStart];
            
        }
        
        
        
        
        
    }
    /*
     NSString *msg = [[message elementForName:@"body"] stringValue];
     NSString *from = [[message attributeForName:@"from"] stringValue];
     
     NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
     [m setObject:msg forKey:@"msg"];
     [m setObject:from forKey:@"sender"];
     
     [_messageDelegate newMessageReceived:m];
     //	[m release];
     */
    
}

-(BOOL)isCurrentView{
    
    
    NSArray *viewControllers = ((UINavigationController *)self.window.rootViewController).viewControllers;
    
    UIViewController* vc=[viewControllers lastObject];
    
    if([vc isKindOfClass:[ChatViewController class]])
    {
        
        return YES;
    }
    
    return NO;
}

-(NSString*)getNickNameFromUserName:(NSString*)name{
    NSArray* myArray = [name  componentsSeparatedByString:@"@"];
    
    NSString* firstString = myArray.count==2 ?[myArray objectAtIndex:0]:name;
    return firstString;
    
}






@end
