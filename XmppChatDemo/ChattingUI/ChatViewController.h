//
//  ChatViewController.h
//  JabberClient
//
//  Created by Sandeep Kumar on 30/10/15.
//
//

#import "JSQMessagesViewController.h"
#import "JSQMessages.h"
#import "RNGridMenu.h"
#import "Constant.h"
#import "Alert.h"
#import "SoundEffect.h"
//#import "UIImageView+AFNetworking.h"

@interface ChatViewController : JSQMessagesViewController
<UIActionSheetDelegate, UIImagePickerControllerDelegate, RNGridMenuDelegate>

{
        NSString *chatWithUser;
       //UIImage* senderImage;
      //  UIImage* receiverImage;


}

- (id) initWithUser:(NSString *) userName;
@property (strong, nonatomic) NSString* forwardMsg;
@property (strong, nonatomic) UIImage* senderImage;
@property (strong, nonatomic) UIImage* receiverImage;

// Group chat
@property(nonatomic,assign) BOOL isGroupChat;
@property(nonatomic,strong) NSString *chat_id;


@end
