//
//  AppDelegate.h
//  XmppChatDemo
//
//  Created by Infoicon on 09/05/17.
//  Copyright © 2017 InfoiconTechnologies. All rights reserved.
//
//http://139.162.164.98:5280/admin
//admin@localhost
//Vijay@123

//Commond
/*
ssh root@45.79.169.14
Pass: Axis@123
/opt/ejabberd-server/sbin/ejabberdctl registered_users localhost admin
/opt/ejabberd-server/sbin/ejabberdctl connected_users
/opt/ejabberd-server/sbin/ejabberdctl connected_users_number
 
 */


#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "XMPPStream.h"
#import "XMPPRosterMemoryStorage.h"
#import "XMPPUserMemoryStorageObject.h"
#import "XMPPRoster.h"
#import "XMPP.h"
#import "SMChatDelegate.h"
#import "SMMessageDelegate.h"
#import "XMPPReconnect.h"

// Room
#import "XMPPRoomMemoryStorage.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,XMPPStreamDelegate,
XMPPRosterDelegate>{

    XMPPStream *xmppStream;
    XMPPRoster *xmppRoster;
    XMPPReconnect*xmppReconnect;
    
 //   XMPPStream *xmppStream1;
 //   XMPPRoster *xmppRoster1;
  //  XMPPReconnect*xmppReconnect1;
    
    
    XMPPRosterMemoryStorage *xmppRosterMemStorage;
    
    XMPPPresence  *tempPresence;
    
 //   XMPPRosterMemoryStorage *xmppRosterMemStorage1;
    
 //   XMPPPresence  *tempPresence1;
    
    NSObject <SMChatDelegate> *_chatDelegate;
    NSObject <SMMessageDelegate> *_messageDelegate;
    
    NSString *password;
    NSString *password1;
    
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) XMPPReconnect*xmppReconnect;
@property (nonatomic, strong) XMPPStream *xmppStream;
@property (nonatomic, strong) XMPPRoster *xmppRoster;

@property (nonatomic, strong) XMPPRosterMemoryStorage *xmppRosterMemStorage;

@property (nonatomic, retain) id  _chatDelegate;
@property (nonatomic, retain) id  _messageDelegate;

@property (strong, nonatomic) NSMutableArray *onlineBuddies;

- (BOOL)connect;
- (void)disconnect;

//- (BOOL)connect1;
//- (void)disconnect1;

// Group/ Room
@property (nonatomic) XMPPRoom *xmppRoom;
-(void)joinOrCreateRoom:(NSString*)roomName;

@end

