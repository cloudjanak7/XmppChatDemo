//
//  XMPPManager.h
//  XMPPGroupChat
//
//  Created by Infoicon on 09/05/17.
//  Copyright © 2017 InfoiconTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"
#import "XMPPRoomMemoryStorage.h"
#import "SMChatDelegate.h"
#import "SMMessageDelegate.h"


//@protocol MessageDelegate <NSObject>
//@required
//- (void)messageReceived:(NSDictionary *)message;
//@end

@interface XMPPManager : NSObject{
   // NSObject <SMChatDelegate> *_chatDelegate;
    //NSObject <SMMessageDelegate> *_messageDelegate;
}
@property (nonatomic, strong) NSObject<SMChatDelegate>*_chatDelegate;
@property (nonatomic, strong) NSObject<SMMessageDelegate>*_messageDelegate;
@property (nonatomic) XMPPStream *xmppStream;
@property (nonatomic) XMPPRoom *xmppRoom;

+ (instancetype)sharedManager;
-(void)joinOrCreateRoom:(NSString*)roomName;
-(BOOL)connect;
-(void)disconnect;

@end
