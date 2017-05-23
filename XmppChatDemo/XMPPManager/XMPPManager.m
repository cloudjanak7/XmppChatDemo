//
//  XMPPManager.m
//  XMPPGroupChat
//
//  Created by Infoicon on 09/05/17.
//  Copyright © 2017 InfoiconTechnologies. All rights reserved.
//

#import "XMPPManager.h"
#import "ChatViewController.h"
#import "XMPPReconnect.h"
#define kJABBER_HOSTNAME @"139.162.164.98"

@interface XMPPManager ()
@property (strong, nonatomic) XMPPReconnect *xmppReconnect;
@end
@implementation XMPPManager



+ (instancetype)sharedManager {
    static XMPPManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

#pragma mark - Setup Stream and Connect to Server

- (void)setupStream {
    self.xmppStream = [[XMPPStream alloc] init];
    [self.xmppStream setHostName:kJABBER_HOSTNAME];
    [self.xmppStream setHostPort:5222];
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (BOOL)connect {
    [self setupStream];
    
    if (![self.xmppStream isDisconnected]) {
        return YES;
    }

    NSString *currentUserId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userID"];
    if ([currentUserId isEqualToString:@""]||currentUserId==nil) {
        return NO;
    }
    
    [self.xmppStream setMyJID:[XMPPJID jidWithString:currentUserId]];
    self.xmppStream.hostName = kJABBER_HOSTNAME;
    [self.xmppStream setHostPort:5222];
    NSError *error = nil;
    
    if (![self.xmppStream connectWithTimeout:10 error:&error]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[NSString stringWithFormat:@"Can't connect to server %@", [error localizedDescription]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        
        return NO;
    }
    
    return YES;
}



//-(BOOL)connect {
//    self.xmppStream = [[XMPPStream alloc] init];
//    self.xmppStream.hostName = kJABBER_HOSTNAME;//@"lasonic.local";
//    [self.xmppStream setHostPort:5222];
//    [self.xmppStream addDelegate:self
//                   delegateQueue:dispatch_get_main_queue()];
//    
//    if (![self.xmppStream isDisconnected]) {
//        return YES;
//    }
//    
//   //[self.xmppStream setMyJID:[XMPPJID jidWithString:@"chat@lasonic.local"]];
//    NSString *jabberID = [[NSUserDefaults standardUserDefaults] stringForKey:@"userID"];
//    
//    [self.xmppStream setMyJID:[XMPPJID jidWithString:@"infoiconuser5@localhost"]];
//    
//    NSError *error;
//    if (![self.xmppStream connectWithTimeout:10 error:&error]) {
//        NSLog(@"Error: %@", [error localizedDescription]);
//        return NO;
//    }
//    
//    return YES;
//    
//}

-(void)xmppStreamDidConnect:(XMPPStream *)sender {
    NSError *error;
    
    NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"userPassword"];
    if(![[self xmppStream] authenticateWithPassword:myPassword error:&error])
        NSLog(@"Error authenticating: %@", error);
//    if (![self.xmppStream authenticateAnonymously:&error]) {
//         NSLog(@"Error: %@", [error localizedDescription]);
//    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
   
     NSLog(@"AUTHENTICATED");
    [self goOnline];
    
}

-(void)disconnect {
     [self goOffline];
    [self.xmppStream disconnect];
}


#pragma mark - XMPP Presence

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    
    NSString *presenceType = [presence type]; // online/offline
    NSString *myUsername = [[sender myJID] user];
    NSString *presenceFromUser = [[presence from] user];
    
    if (![presenceFromUser isEqualToString:myUsername]) {
        
        if ([presenceType isEqualToString:@"available"]) {
            
            NSLog(@"%@ has come online.",presenceFromUser);
            
        } else if ([presenceType isEqualToString:@"unavailable"]) {
            
            NSLog(@"%@ has gone offline.",presenceFromUser);
            
        }
    }
}

- (void)goOnline {
    XMPPPresence *presence = [XMPPPresence presence];
    [self.xmppStream sendElement:presence];
}

- (void)goOffline {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [self.xmppStream sendElement:presence];
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
    NSLog(@"%@",iq.description);
    return NO;
}


-(void)joinOrCreateRoom:(NSString*)roomName {
    
    self.xmppReconnect = [[XMPPReconnect alloc] init];
    [self.xmppReconnect activate:self.xmppStream];
    [self.xmppReconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self goOnline];
    [self.xmppRoom removeDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSString *jabberID = [[NSUserDefaults standardUserDefaults] stringForKey:@"userID"];
    
    XMPPRoomMemoryStorage *roomMemory = [[XMPPRoomMemoryStorage alloc]init];
    //XMPPJID  *roomJID = [XMPPJID jidWithString:@"chat@conference.lasonic.local"];
    roomName = [roomName stringByAppendingString:@"@conference.localhost"];
    XMPPJID  *roomJID = [XMPPJID jidWithString:roomName];
    self.xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:roomMemory
                                                      jid:roomJID
                                            dispatchQueue:dispatch_get_main_queue()];
    [self.xmppRoom activate:self.xmppStream];
    [self.xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
 
    [self.xmppRoom joinRoomUsingNickname:jabberID
                                 history:nil
                                password:nil];
}


- (void)handleIncomingMessage:(XMPPMessage *)message room:(XMPPRoom *)room{

     NSLog(@"Incomming message: %@", message.debugDescription);
}



-(void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID {
    NSLog(@"SENDER:%@ MESSSAGE:%@",sender,message);
     NSString *currentUserId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userID"];
    
    NSString *from = [[message attributeForName:@"from"] stringValue];
    from = [self getFromUser:from];
    
    NSString *error = [[message attributeForName:@"error"] stringValue];
    
    if([[message elementForName:@"body"]stringValue] != nil && ![from isEqualToString:currentUserId]  && !message.isErrorMessage){ //&& userData){
        
        NSString *msg = [[message elementForName:@"body"] stringValue];
       
        NSString *to = [[message attributeForName:@"to"] stringValue];
        to = [self getToUser:to];
        NSLog(@"%@ %@",msg,from);
        
        NSString *roomId = [[message attributeForName:@"from"] stringValue];
        roomId = [self getRoomId:roomId];
        NSLog(@"%@ %@",msg,from);
        
        NSDate*date=[NSString getCurrentDateFromString:[NSString getCurrentTime]];
        NSString* time=[[Alert getDateFormatWithString:GET_FORMAT_TYPE] stringFromDate:date];
        
        NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
        [m setObject:msg forKey:@"msg"];
        
        NSArray * arr = [from componentsSeparatedByString:@"/"];
        from=arr.count>1 ? arr[0] : from;
        
        [m setObject:from forKey:@"sender"];
        [m setObject:to forKey:@"receiver"];
        [m setObject:roomId forKey:@"roomId"];
        
        [__messageDelegate newMessageReceived:m];
        
        
        //Save Dialog History in Database
        
        DBManager *dataManager=[[DBManager alloc]initWithDB:DATABASE_NAME];
        //NSString* dialogId=[self getNickNameFromUserName:from];
        
        NSString* queryCreationDate=[NSString stringWithFormat:@"select created_date from DIALOG_HISTORY where dialog_id=\"%@\"",roomId];
        NSString* creationDate=[dataManager getCreationDate:queryCreationDate];
        
        NSString* queryUnread=[NSString stringWithFormat:@"select unread_count from DIALOG_HISTORY where dialog_id=\"%@\"",roomId];
        int unread=[dataManager getUnreadCount:queryUnread];
        
        
        DialogHistory* dialogHistory=[[DialogHistory alloc]init];
        dialogHistory.dialog_id=roomId;
        dialogHistory.last_message=msg;
        dialogHistory.last_username=from;
        dialogHistory.last_message_date=time;
        dialogHistory.created_date=creationDate!=nil ? creationDate : time;
        dialogHistory.chat_id=roomId;
        
        if ([self isCurrentView])
            dialogHistory.unread_count=0;
        else
            dialogHistory.unread_count=unread+1;
        //Insert Data into database
        [dataManager insertAndUpdateDialogHistoryWithArrayUsingTrasaction:@[dialogHistory]];
        
        //===========SAVING IN DATABASE =================//
        
       NSString *timeStamp = [[message elementForName:@"stamp"] stringValue];
        
        ChatHistory *chat=[[ChatHistory alloc] init];
        chat.message_id=roomId;
        chat.chat_id=roomId;
        chat.from_username=from;
        chat.to_username=to;
        chat.chat_message=msg;
        chat.chat_timestamp=timeStamp;
        NSArray *ar=[[NSArray alloc]initWithObjects:chat, nil];
        DBManager *objDB=[[DBManager alloc]initWithDB:DATABASE_NAME];
        [objDB insertAndUpdateChatWithArrayUsingTrasaction:ar];
        
        
        //Update Chat View
       // [[NSNotificationCenter defaultCenter] postNotificationName:@"OnIncomingMessageUpdateDialogHistory" object:nil userInfo:nil];
    }
}



-(NSString*)getFromUser:(NSString*)resFromUser{

  //  chatroom4@conference.localhost/infoiconuser6@localhost
    NSString *strFromUser;
    NSArray *array=[resFromUser componentsSeparatedByString:@"/"];
    if (array.count>1){
      
        strFromUser=array[1];
    }
    return strFromUser;
}

-(NSString*)getToUser:(NSString*)resToUser{
    
    //  to="infoiconuser7@localhost/4531232569561642012142
    NSString *strToUser;
    NSArray *array=[resToUser componentsSeparatedByString:@"/"];
    if (array.count>1){
        
        strToUser=array[0];
    }
    return strToUser;
}

-(NSString*)getRoomId:(NSString*)resToUser{
    
    //  to="infoiconuser7@localhost/4531232569561642012142
    NSString *strRoomId;
    NSArray *array=[resToUser componentsSeparatedByString:@"/"];
    
    if (array.count>0){
        NSArray *array2=[array[0] componentsSeparatedByString:@"@"];
        strRoomId = array2[0];
    }
    strRoomId = [strRoomId stringByAppendingString:@"@localhost"];
   return strRoomId;
}


- (void)xmppRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence {
    
    NSLog(@"Sender Presence::%@",sender);
   
}
- (void)xmppRoomDidCreate:(XMPPRoom *)sender{
    NSLog(@"ROOM CREATED");
}
- (void)xmppRoomDidJoin:(XMPPRoom *)sender{
    NSLog(@"ROOM JOINED");
     [sender fetchConfigurationForm];
}


/**
 * Necessary to prevent this message:
 * "This room is locked from entry until configuration is confirmed."
 */

- (void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(NSXMLElement *)configForm
{
    NSXMLElement *newConfig = [configForm copy];
    NSArray *fields = [newConfig elementsForName:@"field"];
    
    for (NSXMLElement *field in fields)
    {
        
        NSString *var = [field attributeStringValueForName:@"var"];
        // Make Room Persistent
        if ([var isEqualToString:@"muc#roomconfig_persistentroom"]) {
            [field removeChildAtIndex:0];
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
        }else if ([var isEqualToString:@"muc#roomconfig_roomname"]) {
            [field removeChildAtIndex:0];
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"GroupNameString"]];
        }else if ([var isEqualToString:@"muc#roomconfig_publicroom"]) {
            [field removeChildAtIndex:0];
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
        }else if ([var isEqualToString:@"muc#roomconfig_whois"]) {
            [field removeChildAtIndex:0];
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"anyone"]];
        }else if ([var isEqualToString:@"muc#roomconfig_allow_subscription"]) {
            [field removeChildAtIndex:0];
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
        }else if ([var isEqualToString:@"muc#roomconfig_membersonly"]) {
            [field removeChildAtIndex:0];
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"0"]];
        }else if ([var isEqualToString:@"muc#roomconfig_moderatedroom"]) {
            [field removeChildAtIndex:0];
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"0"]];
        }else if ([var isEqualToString:@"public_list"]) {
            [field removeChildAtIndex:0];
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
        }else if ([var isEqualToString:@"muc#roomconfig_allowinvites"]) {
            [field removeChildAtIndex:0];
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
        }else if ([var isEqualToString:@"muc#roomconfig_maxusers"]) {
            [field removeChildAtIndex:0];
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"10000"]];
        }
    }
    
    [sender configureRoomUsingOptions:newConfig];
}


// Other method

-(BOOL)isCurrentView{
    
    
    NSArray *viewControllers = ((UINavigationController *)Appdelegate.window.rootViewController).viewControllers;
    
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
