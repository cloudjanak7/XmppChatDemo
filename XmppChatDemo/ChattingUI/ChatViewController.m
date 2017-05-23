//
//  ChatViewController.m
//  JabberClient
//
//  Created by Sandeep Kumar on 30/10/15.
//
//

#import "ChatViewController.h"
//#import "Constant.h"
#import "PhotoMediaItem.h"
#import "VideoMediaItem.h"
#import "IDMPhotoBrowser.h"
#import "ChatHistory.h"
#import "DialogHistory.h"
#import "XmppChatDemo-Swift.h"
//#import "AGEmojiKeyBoardView.h"
//#import "AGEmojiPageView.h"
//#import "ContactsTableViewController.h"

#define LASST_MESSAGE           @"msg"
#define LASST_MESSAGE_USERID    @"sender"
#define LASST_MESSAGE_DATE      @"time"




@interface ChatViewController ()<UIGestureRecognizerDelegate>
///<AGEmojiKeyboardViewDataSource,
//AGEmojiKeyboardViewDelegate,
//UIGestureRecognizerDelegate,
//WebServiceDelegate>
{
 
        BOOL isLoading;
        BOOL initialized;
        
        NSMutableArray *users;
        NSMutableArray *messages;
        NSMutableDictionary *avatars;
        
        JSQMessagesBubbleImage *bubbleImageOutgoing;
        JSQMessagesBubbleImage *bubbleImageIncoming;
        JSQMessagesAvatarImage *avatarImageBlank;
        NSIndexPath* selectedIndexPath;
        NSMutableArray* arrSelectedItemsIndex;
        BOOL isSelected;
        NSArray* arrContacts;
//        DataBaseHandler* dataManager;

        
        BOOL isMessageHistory;
}
@property(nonatomic,strong)UIActivityIndicatorView *activityIndicator;

@end

@implementation ChatViewController
@synthesize senderImage;
@synthesize receiverImage;


#pragma mark - App Delegate Custom Methods


#pragma mark - View controller

- (id) initWithUser:(NSString *) userName {
        
        if (self = [super init]) {
                
                chatWithUser = userName; // @ missing
//                turnSockets = [[NSMutableArray alloc] init];
        }
        
        return self;
        
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
        self.navigationController.navigationBarHidden=NO;
//        self.title = @"Test User";
        [self config];
        
}

-(void)config{
        //---------------------------------------------------------------------------------------------------------------------------------------------
        users = [[NSMutableArray alloc] init];
        messages = [[NSMutableArray alloc] init];
        avatars = [[NSMutableDictionary alloc] init];
        //---------------------------------------------------------------------------------------------------------------------------------------------
        /*******************************************/
        
        //        PFUser *user = [PFUser currentUser];
        self.senderId =@"you";// user.objectId;
    
        self.senderDisplayName = [self getNickNameFromUserName:chatWithUser];
        self.title = self.senderDisplayName;
        //---------------------------------------------------------------------------------------------------------------------------------------------
        
        
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        bubbleImageOutgoing = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor redColor]];
        bubbleImageIncoming = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor orangeColor]];
        //---------------------------------------------------------------------------------------------------------------------------------------------
        avatarImageBlank = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"chat_blank"] diameter:30.0];
        //---------------------------------------------------------------------------------------------------------------------------------------------
        isLoading = NO;
        initialized = NO;
        //[self loadMessages];
        
        XMPPManager *del = [XMPPManager sharedManager];
        del._messageDelegate = self;
    
        
        //Load Sender or User image
        arrContacts=[[NSUserDefaults standardUserDefaults] objectForKey:@"contacts"];
        
      
        
        UIImage*imgPlaceHolder=[UIImage imageNamed:@"search_placeholder.png"];
        

        //Sender image
        
        UIImageView *imgSenderPic=[[UIImageView alloc]initWithImage:imgPlaceHolder];
        senderImage=[UIImage imageNamed:@"hritik"];//imgPlaceHolder;
    

        UIImageView *imgReceiverPic=[[UIImageView alloc]initWithImage:imgPlaceHolder];
        receiverImage=[UIImage imageNamed:@"john"];//imgPlaceHolder;
        
        //Call Notification observer
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveMessageNotification:)
                                                     name:@"OnIncomingMessageUpdateDialogHistory"
                                                   object:nil];
    
        // Load message history from database
        [self loadMessageHistoryData ];
    

}

-(void)loadData{
        
        messages = [[NSMutableArray alloc] init];
        
        NSMutableDictionary* userData=[[NSUserDefaults standardUserDefaults] objectForKey:@"info"];
        //-------------------------------------------------------------------------------------------
        //Setup for loading data
        [self setInputToolBar:NO];
        
        [self setActivityIndicatorForMessageHistory];
        
        [_activityIndicator startAnimating];
}

-(void)viewWillAppear:(BOOL)animated{
        
        [super viewWillAppear:animated];
        
       // [self loadData];
        
        if(self.forwardMsg.length>0)    [self sendForwardedMessage];
        
}

- (void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
        [super viewDidAppear:animated];
        self.collectionView.collectionViewLayout.springinessEnabled = NO;
    
        
}

- (void)viewWillDisappear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
        [super viewWillDisappear:animated];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Custom Methods



//-(NSString*)getNickNameFromUserName:(NSString*)name{
//        NSArray* myArray = [name  componentsSeparatedByString:@"@"];
//        
//        NSString* firstString = myArray.count==2 ?[myArray objectAtIndex:0]:name;
//        return firstString;
//        
//}

-(void)saveDialogHistoryData:(NSString*)message{
        
        NSMutableDictionary* userData=[[NSUserDefaults standardUserDefaults] objectForKey:@"info"];
        
        NSString* sender=@"arvind";
      //  NSString* diaologId=[self getNickNameFromUserName:chatWithUser];
   //     NSString* query=[NSString stringWithFormat:@"select creationDate from DialogHistory where dialogId=\"%@\"",diaologId];
//        NSString* creationDate=[dataManager getCreationDate:query];
//        
//        NSDate*date=[NSString getCurrentDateFromString:[NSString getCurrentTime]];
//        
//        NSString* time=[[Alert getDateFormatWithString:GET_FORMAT_TYPE] stringFromDate:date];
//        
//        DialogHistory* dialogHistory=[[DialogHistory alloc]init];
//        dialogHistory.dialogId=diaologId;
//        dialogHistory.LastMessage=message;
//        dialogHistory.LastMessageUserId=sender;
//        dialogHistory.LastMessageDate=time;
//        dialogHistory.creationDate=creationDate!=nil ? creationDate : time;
//        dialogHistory.unread=0;
//        //
//        //Insert Data into database
//        [dataManager insertAndUpdateDialogHistoryWithArrayUsingTrasaction:@[dialogHistory]];
//        //Show Dialog history data from database
//        [dataManager showDialogHistoryData];
    
}

-(void)loadMessageHistoryData{
    
    
        NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
        BOOL isLogin=userID; //&& ![userData isEqual:@""];
    
    
        if(isLogin){
                messages = [[NSMutableArray alloc] init];
            
            DBManager *db=[[DBManager alloc]initWithDB:DATABASE_NAME];
            NSArray *arrayMessageHistory;
            
            if (_isGroupChat){
            
                //NSString *strUserId = [self getNickNameFromUserName:chatWithUser];
                arrayMessageHistory=[db getGroupChatHistoryWithChatId:chatWithUser];
            }else{
            
                arrayMessageHistory=[db getChatHistoryData:TABLE_NAME_CHAT_HISTORY fromUser:userID toUser:chatWithUser];
            }
            
  
                for (ChatHistory* msg in arrayMessageHistory) {
                        NSMutableDictionary* data=[NSMutableDictionary dictionary];
                        
                      //  NSString* sender=[NSString stringWithFormat:@"%@@%@",msg.sender,@"localhost"];
                        
                        if([msg.from_username isEqualToString:userID])
                                [data setObject:@"you" forKey:@"sender"];
                        else
                                [data setObject:msg.from_username forKey:@"sender"];
                        
                        [data setObject:msg.chat_message forKey:@"msg"];
                        [data setObject:msg.chat_timestamp forKey:@"time"];
                        
                        [self addMessage:[data mutableCopy]];
                }
            
                [self finishReceivingMessage];
                [self scrollToBottomAnimated:NO];
        }
       

}

-(void)setInputToolBar:(BOOL)result{
        
        self.inputToolbar.contentView.textView.editable=result;
        self.inputToolbar.contentView.leftBarButtonItem.enabled=result;
        
}

-(void)setActivityIndicatorForMessageHistory{
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicator.color=[UIColor blackColor];
        _activityIndicator.center = CGPointMake( [UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/3);
        _activityIndicator.hidesWhenStopped = YES;
        
        [self.collectionView addSubview:_activityIndicator];
        
        
        
}


- (JSQMessage *)addMessage:(NSDictionary *)object
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
        JSQMessage *message;
        

        
        NSString *sender = [object objectForKey:@"sender"];
        NSString *text = [object objectForKey:@"msg"];
        NSString *time = [object objectForKey:@"time"];

//        NSArray * arr = [sender componentsSeparatedByString:@"/"];
//        sender=arr.count>1 ? arr[0] : sender;
        //---------------------------------------------------------------------------------------------------------------------------------------------
//        PFUser *user = object[PF_MESSAGE_USER];
//        NSString *name = user[PF_USER_FULLNAME];
//        //---------------------------------------------------------------------------------------------------------------------------------------------
//        PFFile *fileVideo = object[PF_MESSAGE_VIDEO];
//        PFFile *filePicture = object[PF_MESSAGE_PICTURE];
        //---------------------------------------------------------------------------------------------------------------------------------------------
        
//        if ((filePicture == nil) && (fileVideo == nil))
//        {
    
                NSString *strSender = [self getNickNameFromUserName:sender];
                message = [[JSQMessage alloc] initWithSenderId:sender
                                             senderDisplayName:strSender
                                                          date:[Alert getDateWithDateString:time setFormat:GET_FORMAT_TYPE]
                                                          text:text];
//        }
        //---------------------------------------------------------------------------------------------------------------------------------------------
/*
        if (fileVideo != nil)
        {
                JSQVideoMediaItem *mediaItem = [[JSQVideoMediaItem alloc] initWithFileURL:[NSURL URLWithString:fileVideo.url] isReadyToPlay:YES];
                mediaItem.appliesMediaViewMaskAsOutgoing = [user.objectId isEqualToString:self.senderId];
                message = [[JSQMessage alloc] initWithSenderId:user.objectId senderDisplayName:name date:object.createdAt media:mediaItem];
        }
        //---------------------------------------------------------------------------------------------------------------------------------------------
        if (filePicture != nil)
        {
                JSQPhotoMediaItem *mediaItem = [[JSQPhotoMediaItem alloc] initWithImage:nil];
                mediaItem.appliesMediaViewMaskAsOutgoing = [user.objectId isEqualToString:self.senderId];
                message = [[JSQMessage alloc] initWithSenderId:user.objectId senderDisplayName:name date:object.createdAt media:mediaItem];
                //-----------------------------------------------------------------------------------------------------------------------------------------
                [filePicture getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
                 {
                         if (error == nil)
                         {
                                 mediaItem.image = [UIImage imageWithData:imageData];
                                 [self.collectionView reloadData];
                         }
                 }];
        }
        //---------------------------------------------------------------------------------------------------------------------------------------------
 
 */
        //[users addObject:user];
        [messages addObject:message];
        
        //---------------------------------------------------------------------------------------------------------------------------------------------
        return message;
}


-(void)setLongPressGestureOnCell{
        // attach long press gesture to collectionView
        UILongPressGestureRecognizer *lpgr
        = [[UILongPressGestureRecognizer alloc]
           initWithTarget:self action:@selector(handleLongPress:)];
        lpgr.minimumPressDuration = .5; //seconds
        lpgr.delegate = self;
        lpgr.delaysTouchesBegan = YES;
        [self.collectionView addGestureRecognizer:lpgr];
}
/*
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
        if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
                return;
        }
        CGPoint p = [gestureRecognizer locationInView:self.collectionView];
        
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
        if (indexPath == nil){
                NSLog(@"couldn't find index path");
        } else {
                // get the cell at indexPath (the one you long pressed)
                JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)
                [self.collectionView cellForItemAtIndexPath:indexPath];
                // do stuff with the cell
                
                //[cell setUserInteractionEnabled:NO];
                [cell setAlpha:0.5];
                
                self.inputToolbar.contentView.textView.editable=NO;
                [self.inputToolbar.contentView.textView resignFirstResponder];
                self.inputToolbar.contentView.rightBarButtonItem.enabled=NO;
                
                
                
        }
}
*/
-  (void)handleLongPress:(UILongPressGestureRecognizer*)gestureRecognizer {
        if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
                NSLog(@"UIGestureRecognizerStateEnded");
                //Do Whatever You want on End of Gesture
        }
        else if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
                NSLog(@"UIGestureRecognizerStateBegan.");
                CGPoint p = [gestureRecognizer locationInView:self.collectionView];
                
                NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
                if (indexPath == nil){
                        NSLog(@"couldn't find index path");
                } else {
                        if(!isSelected){
                                isSelected=YES;
                                selectedIndexPath=indexPath;
                                // get the cell at indexPath (the one you long pressed)
                                JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)
                                [self.collectionView cellForItemAtIndexPath:indexPath];
                                // do stuff with the cell
                                
                                cell.backgroundColor=[UIColor grayColor];
                                //[cell setUserInteractionEnabled:NO];
                                [cell setAlpha:0.5];
                                
                                self.inputToolbar.contentView.textView.editable=NO;
                                [self.inputToolbar.contentView.textView resignFirstResponder];
                                self.inputToolbar.contentView.rightBarButtonItem.enabled=NO;
                                
                                [self createNavRightItems];
                                arrSelectedItemsIndex=[[NSMutableArray alloc]init];
                                [arrSelectedItemsIndex addObject:selectedIndexPath];
                        }
                }
                

        }
}


-(void)createNavRightItems{
        self.navigationItem.rightBarButtonItems =  @[[self forwardBarItem],[self deleteBarItem]];
//        self.navigationItem.leftBarButtonItem=      [self copyBarItem];
}

-(void)removeNavRightItems{
        self.navigationItem.rightBarButtonItems=nil;
}

-(NSArray*)matchObjectWithdata:(NSArray*) arr string:(NSString*)string{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username == %@", string];
        NSArray *matchingObjs = [arr filteredArrayUsingPredicate:predicate];
        
        if ([matchingObjs count] == 0)
        {
                //NSLog(@"No match");
                return nil;
        }
        else
        {
                //NSLog(@"Matched");
                return matchingObjs;
        }
}


#pragma mark - Delete Message Button

-(UIBarButtonItem*)deleteBarItem{
        
        UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc]
                                      
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                         target:self
                                         action:@selector(deleteRequest:)];
        return deleteButton;
        
}

-(IBAction)deleteRequest:(id)sender{
        //[self alertForAddUser];
        NSLog(@"Delete Message button clicked");
        
        [self.collectionView performBatchUpdates:^ {
                
                // Delete the items from the data source.
                [self deleteItemsFromDataSourceAtIndexPaths:arrSelectedItemsIndex];
                
                [self.collectionView deleteItemsAtIndexPaths:arrSelectedItemsIndex]; // no assertion now
        } completion:^(BOOL finish){
                
                if(finish) {
                        self.inputToolbar.contentView.textView.editable=YES;
                        self.inputToolbar.contentView.rightBarButtonItem.enabled=YES;
                        
                        [self removeNavRightItems];
                        selectedIndexPath=nil;
                        arrSelectedItemsIndex=nil;
                        isSelected=NO;
                }
        
        }];
}

-(void)deleteItemsFromDataSourceAtIndexPaths:(NSArray  *)itemPaths{
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
        for (NSIndexPath *itemPath  in itemPaths) {
                [indexSet addIndex:itemPath.row];
                
        }
        [messages removeObjectsAtIndexes:indexSet];
}


#pragma mark - Forward Message Button

-(UIBarButtonItem*)forwardBarItem{
        UIBarButtonItem *forward = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(forwardRequest:)];
        [forward setImage:[UIImage imageNamed:@"forward_message.png"]];
        //        self.navigationItem.rightBarButtonItem = refreshItem;
        return forward;
}

//-(IBAction)forwardRequest:(id)sender{
//        NSLog(@"Forward Message button clicked");
//        
//        //Sort Array in Accending order
//        NSMutableArray* arrObjects=[self sortedArray:arrSelectedItemsIndex];
//        
//        //create single Message from selected messages
//        NSString* text=[self getAllMessages:arrObjects];
//        
//        ContactsTableViewController* vc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:kContactsTableViewController];;
//        vc.from=kChatViewController;        
//        vc.forwardMsg=text;
//        
//        [self.navigationController pushViewController:vc animated:YES];
//        
//        
//}

-(NSMutableArray*)sortedArray:(NSMutableArray*)arr{
        
        
        [arr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSInteger r1 = [obj1 row];
                NSInteger r2 = [obj2 row];
                if (r1 > r2) {
                        return (NSComparisonResult)NSOrderedDescending;
                }
                if (r1 < r2) {
                        return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
        }];
        
        return arr;
}

-(NSString*)getAllMessages:(NSMutableArray*)arr{
        
        NSString* text=@"";
        for (NSIndexPath* indexPath in arr) {
                
                JSQMessage *msg=messages[indexPath.item];
                
                text=[text stringByAppendingString:[NSString stringWithFormat:@"%@\n",msg.text]];
        }
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        return text;
}

-(void)saveDataAccodingTables:(NSString*)tableName array:(NSArray*)array{
   /*
        
        //NSString* query=[NSString stringWithFormat:@"select creationDate from DialogHistory where dialogId=\"%@\"",tableName];
        //NSString* creationDate=[dataManager getCreationDate:query];
        
        //--------------------------------------------------------------------------------
        NSDictionary* firstMessageDic=array[0];
        NSDictionary* lastMessageDic=array[array.count-1];
        
        NSString* lMessage=[lastMessageDic objectForKey:LASST_MESSAGE];
        NSString* lMessageUserId=[lastMessageDic objectForKey:LASST_MESSAGE_USERID];
        NSString* lMessageDate=[lastMessageDic objectForKey:LASST_MESSAGE_DATE];
        NSString* lCreationDate=[firstMessageDic objectForKey:LASST_MESSAGE_DATE];
        
        //Save Dialog History
        DialogHistory* dialogHistory=[[DialogHistory alloc]init];
        dialogHistory.dialogId          =tableName;
        dialogHistory.LastMessage       =!IS_NULL(lMessage)             ? lMessage              : @"";
        dialogHistory.LastMessageUserId =!IS_NULL(lMessageUserId)       ? lMessageUserId        : @"";
        dialogHistory.LastMessageDate   =!IS_NULL(lMessageDate)         ? lMessageDate          : @"";
        dialogHistory.creationDate      =!IS_NULL(lCreationDate)        ? lCreationDate         : @"";
        dialogHistory.unread=0;
        
        //Insert Data into database
        [dataManager insertAndUpdateDialogHistoryWithArrayUsingTrasaction:@[dialogHistory]];
        //[dataManager showDialogHistoryData];
        
        
        //--------------------------------------------------------------------------------
        NSMutableArray* arrMessage=[[NSMutableArray alloc]init];
        for (NSDictionary* messageDic in array) {
                MessageHistory* msg=[[MessageHistory alloc]init];
                
                NSString* messageId     =[messageDic objectForKey:@"id"];
                NSString* message       =[messageDic objectForKey:@"msg"];
                NSString* sender        =[messageDic objectForKey:@"sender"];
                NSString* to            =[messageDic objectForKey:@"to"];
                NSString* time          =[messageDic objectForKey:@"time"];
                
                msg.messageId   =!IS_NULL(messageId)     ? messageId     : @"";
                msg.message     =!IS_NULL(message)       ? message       : @"";
                msg.sender      =!IS_NULL(sender)        ? sender        : @"";
                msg.to          =!IS_NULL(to)            ? to            : @"";
                msg.time        =!IS_NULL(time)          ? time          : @"";
                
                
                [arrMessage addObject:msg];
                
        }

        
        //Create Table if not exist
        BOOL result=[dataManager createTableWithName:[Alert getTableNameWithUsername:tableName]];
        if(result){
                [dataManager insertAndUpdateMessageHistoryWithArrayUsingTrasaction:[Alert getTableNameWithUsername:tableName] arr:arrMessage];
                //[dataManager showMessageHistoryData:tableName];
        }
        
        
       */
        
        
}

-(void)saveDialogHistoryWithMessage:(NSString*)msg{

    
        DBManager *dataManager=[[DBManager alloc]initWithDB:DATABASE_NAME];
    
        //Save Dialog History in Database
        NSString* dialogId=[self getNickNameFromUserName:chatWithUser];
        
        NSString* queryCreationDate=[NSString stringWithFormat:@"select created_date from DIALOG_ID where dialog_id=\"%@\"",dialogId];
        NSString* creationDate=[dataManager getCreationDate:queryCreationDate];
        
        NSDate*date=[NSString getCurrentDateFromString:[NSString getCurrentTime]];
        NSString* time=[[Alert getDateFormatWithString:GET_FORMAT_TYPE] stringFromDate:date];
        
        
        DialogHistory* dialogHistory=[[DialogHistory alloc]init];
        dialogHistory.dialog_id=dialogId;
        dialogHistory.last_message=msg;
        dialogHistory.last_username=dialogId;
        dialogHistory.last_message_date=time;
        dialogHistory.created_date=creationDate!=nil ? creationDate : time;
        dialogHistory.unread_count=0;
        //
        //Insert Data into database
        [dataManager insertAndUpdateDialogHistoryWithArrayUsingTrasaction:@[dialogHistory]];
        
//        [dataManager showDialogHistoryData];
        

}

-(NSString*)getNickNameFromUserName:(NSString*)name{
    NSArray* myArray = [name  componentsSeparatedByString:@"@"];
    
    NSString* firstString = myArray.count==2 ?[myArray objectAtIndex:0]:name;
    return firstString;
    
}

- (void) receiveMessageNotification:(NSNotification *) notification{
        NSDictionary* info=[notification userInfo];
        
        //incoming Message
        if ([[notification name] isEqualToString:@"OnIncomingMessageUpdateDialogHistory"]){
                //                NSLog (@"Successfully received the test notification!");
                dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSString *sender = [info objectForKey:@"sender"];
                        NSString *m = [info objectForKey:@"msg"];
                        
                        if([sender isEqualToString:chatWithUser]){
                        
                                //Update Dialog history
                                [self saveDialogHistoryWithMessage:m];
                                
                        }
                        
                });
        }
        
}


//#pragma mark-
//#pragma mark Web services
//
//
//-(void)getMessageHistoryWS:(NSMutableDictionary*)data{
//        isMessageHistory=YES;
//        
//        NSString *urlString = kURL_MessageHistory;
//        
//        NSString *postString =[Alert jsonStringWithDictionary:[data mutableCopy]];
//        
//        // NSString* userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
//        // {  "member" : "80"}
//        
//        NSString *tempURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSLog(@" tempURL :%@---%@",tempURL,postString);
//        
//        if ([Alert networkStatus]) {
//                NSLog(@"connected");
//                WebService *webService = [[WebService alloc] initWithObject:self];
//                
//                
//                webService.postString = postString;
//                webService.delegate = self;
//                [webService setPostReqURL:tempURL];
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                        [webService getDataFromUrl];
//                        // [[SharedClass sharedObject] addProgressHud:self.navigationController.view];
//                });
//        }else{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                                        message:@"Network connection error. Please try again."
//                                                                       delegate:nil
//                                                              cancelButtonTitle:@"OK"
//                                                              otherButtonTitles:nil,nil];
//                        [alert  show];
//                        
//                });
//                
//                
//        }
//        
//        
//}


//#pragma mark Webservice delegate.
//
//-(void) webServiceFail:(NSError *) error{
////        [[SharedClass sharedObject] hudeHide];
////        if(refreshControl)
////                [refreshControl endRefreshing];
//        
//        [_activityIndicator stopAnimating];
//        
////        if(arrSection.count){
////                [self removeBackgroundLabel];
////        }
////        else{
////                [self setBackgroundLabel];
////        }
//        [self loadMessageHistoryData];
//        [self setInputToolBar:YES];
//}
//-(void)willPresentAlertView:(UIAlertView *)alertView{
//        
//        //UILabel *titleLbl=  [alertView valueForKey:@"_titleLbel"];
//        
//        [alertView setTintColor: [UIColor redColor]];
//        
//}
//-(void) getdataFormWebService:(NSMutableDictionary *) webServiceDic{
////        [[SharedClass sharedObject] hudeHide];
////        if(refreshControl)
////                [refreshControl endRefreshing];
//        
//        [_activityIndicator stopAnimating];
//        [self setInputToolBar:YES];
//        
//        
//        NSLog(@"Response : %@", webServiceDic);
//        NSString *success  = [webServiceDic valueForKey:@"success"];
//        
//        if ([success isEqualToString:@"true"]) {
//                
//                if(isMessageHistory){
//                        isMessageHistory=NO;
//                        NSArray *resPonsedataArray =[webServiceDic valueForKey:@"data"];
//                        
//                        if([resPonsedataArray isKindOfClass:[NSArray class]]){
//                                [self saveDataAccodingTables:[self getNickNameFromUserName:chatWithUser] array:resPonsedataArray];
//                        }
//                        
//                        
//                        //[self removeBackgroundLabel];
//                        
//                }
////                if(arrContants.count)   [self removeBackgroundLabel];
////                else                    [self setBackgroundLabel];
//                
//                
//                
//                
//        }
//        else if ([success isEqualToString:@"false"]) {
//                
//                if(isMessageHistory) isMessageHistory=NO;
//                
//        }
//        
//        else{
//                if(isMessageHistory) isMessageHistory=NO;
//                
//                
//        }
//        
//        //Load message history from database
//        [self loadMessageHistoryData];
//        
//        
//}


#pragma mark-
#pragma mark Send Forwarded Message

-(void)sendForwardedMessage{
        NSString *messageStr = self.forwardMsg;
        
        if([messageStr length] > 0) {
                
                NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
                [body setStringValue:messageStr];
                
                NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
                [message addAttributeWithName:@"type" stringValue:@"chat"];
                [message addAttributeWithName:@"to" stringValue:chatWithUser];
                [message addChild:body];
                
                [[XMPPManager sharedManager].xmppStream sendElement:message];
                
                // self.messageField.text = @"";
                
                
                NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
                [m setObject:[messageStr substituteEmoticons] forKey:@"msg"];
                [m setObject:@"you" forKey:@"sender"];
                [m setObject:[NSString getCurrentTime] forKey:@"time"];
                
                //[messages addObject:m];
                
                [self addMessage:m];
                
                [self finishSendingMessage];
                
                self.forwardMsg=nil;
                
                
        }

        
}
#pragma mark Chat delegates


- (void)newMessageReceived:(NSDictionary *)messageContent {
        NSMutableDictionary* mc=[messageContent mutableCopy];
        
        NSString *sender = [mc objectForKey:@"sender"];
    
    if (_isGroupChat){
        
        NSString *roomId = [mc objectForKey:@"roomId"];
        if([roomId isEqualToString:chatWithUser]){
            
            NSDate*date=[NSString getCurrentDateFromString:[NSString getCurrentTime]];
            NSString* time=[[Alert getDateFormatWithString:GET_FORMAT_TYPE] stringFromDate:date];
            
            NSString *message = [mc objectForKey:@"msg"];
            [mc setObject:[message substituteEmoticons] forKey:@"msg"];
            [mc setObject:time forKey:@"time"];
            
            //===========ADDING AND LOADING RECEIVED MESSAGE =================//
            [self addMessage:mc];
            [self finishReceivingMessage];
            [self scrollToBottomAnimated:YES];
            
        }
        else{
            
            NSString *message = [mc objectForKey:@"msg"];
            
            NSString *strSender=[self getNickNameFromUserName:sender];
            GLNotificationBar * notificationBar = [[GLNotificationBar alloc]initWithTitle:@"New Message received." message:[NSString stringWithFormat:@"%@ : %@",strSender,message] preferredStyle:0 handler:nil];
            
            [notificationBar addAction:[[GLNotifyAction alloc]initWithTitle:@"Like" style:0 handler:^(GLNotifyAction * action) {
                NSLog(@"I Like this quote");
                //NSLog(@"Text reply %@",action.textResponse);
            }]];
            //[notificationBar addAction:[[GLNotifyAction alloc]initWithTitle:@"Cancel" style:4 handler:nil]];
            
            //[[SoundEffect sharedSoundEffect] messageToneStart];
        }
    }else{
        if([sender isEqualToString:chatWithUser]){
            
            NSDate*date=[NSString getCurrentDateFromString:[NSString getCurrentTime]];
            NSString* time=[[Alert getDateFormatWithString:GET_FORMAT_TYPE] stringFromDate:date];
            
            NSString *message = [mc objectForKey:@"msg"];
            [mc setObject:[message substituteEmoticons] forKey:@"msg"];
            [mc setObject:time forKey:@"time"];
            
            //===========ADDING AND LOADING RECEIVED MESSAGE =================//
            [self addMessage:mc];
            [self finishReceivingMessage];
            [self scrollToBottomAnimated:YES];
            
        }
        else{
            
            NSString *message = [mc objectForKey:@"msg"];
            
            NSString *strSender=[self getNickNameFromUserName:sender];
            GLNotificationBar * notificationBar = [[GLNotificationBar alloc]initWithTitle:@"New Message received." message:[NSString stringWithFormat:@"%@ : %@",strSender,message] preferredStyle:0 handler:nil];
            
            [notificationBar addAction:[[GLNotifyAction alloc]initWithTitle:@"Like" style:0 handler:^(GLNotifyAction * action) {
                NSLog(@"I Like this quote");
                //NSLog(@"Text reply %@",action.textResponse);
            }]];
            //[notificationBar addAction:[[GLNotifyAction alloc]initWithTitle:@"Cancel" style:4 handler:nil]];
            
            //[[SoundEffect sharedSoundEffect] messageToneStart];
        }
     }
     }



#pragma mark - JSQMessagesViewController method overrides

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
       // [self sendMessage:text Video:nil Picture:nil];
        
        NSString *messageStr = text;
        
        if([messageStr length] > 0) {

                //-------------------------------------------------------------------
                
                
                NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
                [body setStringValue:messageStr];
                
                NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
            
               // [message addAttributeWithName:@"to" stringValue:@"sandeep@localhost"];
                //Send message to receiver
                if (_isGroupChat){
                    
                     NSString *jabberID = [[NSUserDefaults standardUserDefaults] stringForKey:@"userID"];
                  //  NSString *strGroupName=[self getNickNameFromUserName:chatWithUser];
                    XMPPMessage *xMessage = [[XMPPMessage alloc] init];
                   // [xMessage addAttributeWithName:@"senderId" stringValue:jabberID];
                    
                    // [message addAttributeWithName:@"from" stringValue:[self getFullRoomId]];
                    
                  //  [xMessage addAttributeWithName:@"displayName" stringValue:jabberID];
                    NSString *dateTimeInterval = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
                    [xMessage addAttributeWithName:@"stamp" stringValue:dateTimeInterval];
                    
                  //  NSXMLElement *history = [NSXMLElement elementWithName:@"history"];
                   // [history addAttributeWithName:@"since" stringValue:dateTimeInterval];
                     //[NSDate dateWithTimeIntervalSince1970:1495549240.039486]
                    
                    NSXMLElement *threadElement = [NSXMLElement elementWithName:@"stamp" stringValue:dateTimeInterval];
                    [xMessage addChild:threadElement];
                    
                    
                    [xMessage addBody:messageStr];
                    
                    [[XMPPManager sharedManager].xmppRoom sendMessage:xMessage];
                }
                else{
                    [message addAttributeWithName:@"to" stringValue:chatWithUser];
                    [message addAttributeWithName:@"type" stringValue:@"chat"];
                    [message addChild:body];
                    
                    [[XMPPManager sharedManager].xmppStream sendElement:message];

                }
            
            
                //-------------------------------------------------------------------
                NSDate*date=[NSString getCurrentDateFromString:[NSString getCurrentTime]];
                
                NSString* time=[[Alert getDateFormatWithString:GET_FORMAT_TYPE] stringFromDate:date];
                
                //Create Local Message history
                NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
                [m setObject:[messageStr substituteEmoticons] forKey:@"msg"];
                [m setObject:@"you" forKey:@"sender"];
                [m setObject:time forKey:@"time"];
                
                
                
                //-------------------------------------------------------------------

                //===========SAVING IN DATABASE =================//
                NSString *sender = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
                ChatHistory *chat=[[ChatHistory alloc] init];
            
                if (_isGroupChat){
                    
                     chat.chat_id=chatWithUser;
                }else{
                    chat.chat_id=@"0";
                }
                    chat.from_username=sender;
                    chat.to_username=chatWithUser;
                    chat.chat_message=messageStr;
                    chat.chat_timestamp=time;
            
                    NSArray *ar=[[NSArray alloc]initWithObjects:chat, nil];
                    DBManager *objDB=[[DBManager alloc]initWithDB:DATABASE_NAME];
                    [objDB insertAndUpdateChatWithArrayUsingTrasaction:ar];
            
            
                //Save data for Dialog History
                [self saveDialogHistoryData:messageStr];
            
                [self addMessage:m];
                
                [self finishSendingMessage];
                [self scrollToBottomAnimated:YES];
                
                //-------------------------------------------------------------------
       
        }

}


-(NSString*)getFullRoomId{

     //chatroom4@conference.localhost/infoiconuser6@localhost
    
    NSString *strRoom = [self getNickNameFromUserName:chatWithUser];
    
    NSString *currentUserId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userID"];
    NSString *fullJID = [NSString stringWithFormat:@"%@@conference.localhost/%@",strRoom,currentUserId];
    
    return fullJID;
}


//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didPressAccessoryButton:(UIButton *)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
        /*
        [self.view endEditing:YES];
        NSArray *menuItems = @[[[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"chat_camera"] title:@"Camera"],
                               [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"chat_audio"] title:@"Audio"],
                               [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"chat_pictures"] title:@"Pictures"],
                               [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"chat_videos"] title:@"Videos"],
                               [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"chat_location"] title:@"Location"],
                               [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"chat_stickers"] title:@"Stickers"]];
        RNGridMenu *gridMenu = [[RNGridMenu alloc] initWithItems:menuItems];
        gridMenu.delegate = self;
        [gridMenu showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
         
         */
        
//        if ([self.inputToolbar.contentView.textView.inputView isKindOfClass:[AGEmojiKeyboardView class]]) {
//                
//                [self.inputToolbar.contentView.leftBarButtonItem setImage:[UIImage imageNamed:@"ic_smile"] forState:UIControlStateNormal];
//                self.inputToolbar.contentView.textView.inputView = nil;
//                [self.inputToolbar.contentView.textView reloadInputViews];
//                
//        } else {
//                
//                [self.inputToolbar.contentView.leftBarButtonItem setImage:[UIImage imageNamed:@"keyboard_icon"] forState:UIControlStateNormal];
//                
//                AGEmojiKeyboardView *emojiKeyboardView = [[AGEmojiKeyboardView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 216) dataSource:self];
//                emojiKeyboardView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//                emojiKeyboardView.delegate = self;
//                emojiKeyboardView.tintColor = [UIColor colorWithRed:0.678 green:0.762 blue:0.752 alpha:1.000];
//                
//                self.inputToolbar.contentView.textView.inputView = emojiKeyboardView;
//                [self.inputToolbar.contentView.textView reloadInputViews];
//                [self.inputToolbar.contentView.textView becomeFirstResponder];
//        }
}

- (NSArray *)sectionsImages {
        return @[@"😊", @"😊", @"🎍", @"🐶", @"🏠", @"🕘", @"Back"];
}

- (UIImage *)randomImage:(NSInteger)categoryImage {
        
        CGSize size = CGSizeMake(30, 30);
        UIGraphicsBeginImageContextWithOptions(size , NO, 0);
        
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
        [attributes setObject:[UIFont systemFontOfSize:27] forKey:NSFontAttributeName];
        NSString * sectionImage = self.sectionsImages[categoryImage];
        [sectionImage drawInRect:CGRectMake(0, 0, 30, 30) withAttributes:attributes];
        
        
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
}

//#pragma mark - Emoji Data source
//
//- (UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView imageForSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category {
//        UIImage *img = [self randomImage:category];
//        
//        return [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//}
//
//- (UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView imageForNonSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category {
//        UIImage *img = [self randomImage:category];
//        return [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//}
//
//- (UIImage *)backSpaceButtonImageForEmojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView {
//        UIImage *img = [UIImage imageNamed:@"keyboard_icon"];
//        return [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//}

#pragma mark - Emoji Delegate

//- (void)emojiKeyBoardView:(AGEmojiKeyboardView *)emojiKeyBoardView didUseEmoji:(NSString *)emoji {
//        
//        NSString *textViewString = self.inputToolbar.contentView.textView.text;
//        self.inputToolbar.contentView.textView.text = [textViewString stringByAppendingString:emoji];
//        [self textViewDidChange:self.inputToolbar.contentView.textView];
//}
//
//- (void)emojiKeyBoardViewDidPressBackSpace:(AGEmojiKeyboardView *)emojiKeyBoardView {
//        
//        self.inputToolbar.contentView.textView.inputView = nil;
//        [self.inputToolbar.contentView.textView reloadInputViews];
//        [self.inputToolbar.contentView.leftBarButtonItem setImage:[UIImage imageNamed:@"ic_smile"] forState:UIControlStateNormal];
//}

#pragma mark - JSQMessages CollectionView DataSource

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
        return messages[indexPath.item];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
             messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
        if ([self outgoing:messages[indexPath.item]])
        {
                return bubbleImageOutgoing;
        }
        else return bubbleImageIncoming;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
                    avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
//        PFUser *user = users[indexPath.item];
//        if (avatars[user.objectId] == nil)
//        {
//                [self loadAvatar:user];
//                return avatarImageBlank;
//        }
//        else return avatars[user.objectId];
        UIImage* image;
        
        if ([self outgoing:messages[indexPath.item]]){
                
                image=senderImage ? senderImage :nil;
        }
        else{
                image=receiverImage ? receiverImage :nil;
                
        }
        
        JSQMessagesAvatarImage *avatarImage;
        if(image){
                avatarImage=[JSQMessagesAvatarImageFactory avatarImageWithImage:image diameter:30.0];
        }
        else    avatarImage=nil;
        
        return avatarImage ? avatarImage : avatarImageBlank;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
        if (indexPath.item % 3 == 0)
        {
                JSQMessage *message = messages[indexPath.item];
                return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
        }
        else return nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
        JSQMessage *message = messages[indexPath.item];
        if ([self incoming:message])
        {
                if (indexPath.item > 0)
                {
                        JSQMessage *previous = messages[indexPath.item-1];
                        if ([previous.senderId isEqualToString:message.senderId])
                        {
                                return nil;
                        }
                }
                return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
        }
        else return nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
        return nil;
}

#pragma mark - UICollectionView DataSource

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
        return [messages count];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
        JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
        
        if ([self outgoing:messages[indexPath.item]])
        {
                cell.textView.textColor = [UIColor whiteColor];
        }
        else
        {
                cell.textView.textColor = [UIColor blackColor];
        }
        return cell;
}

#pragma mark - JSQMessages collection view flow layout delegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
        if (indexPath.item % 3 == 0)
        {
                return kJSQMessagesCollectionViewCellLabelHeightDefault;
        }
        else return 0;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
        JSQMessage *message = messages[indexPath.item];
        if ([self incoming:message])
        {
                if (indexPath.item > 0)
                {
                        JSQMessage *previous = messages[indexPath.item-1];
                        if ([previous.senderId isEqualToString:message.senderId])
                        {
                                return 0;
                        }
                }
                return kJSQMessagesCollectionViewCellLabelHeightDefault;
        }
        else return 0;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
        return 0;
}

#pragma mark - Responding to collection view tap events

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
        NSLog(@"didTapLoadEarlierMessagesButton");
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView
           atIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
        JSQMessage *message = messages[indexPath.item];
        if ([self incoming:message])
        {
//                ProfileView *profileView = [[ProfileView alloc] initWith:message.senderId User:nil];
//                [self.navigationController pushViewController:profileView animated:YES];
        }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
        JSQMessage *message = messages[indexPath.item];
        if (message.isMediaMessage)
        {
                if ([message.media isKindOfClass:[PhotoMediaItem class]])
                {
                        PhotoMediaItem *mediaItem = (PhotoMediaItem *)message.media;
                        NSArray *photos = [IDMPhoto photosWithImages:@[mediaItem.image]];
                        IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
                        [self presentViewController:browser animated:YES completion:nil];
                }
                if ([message.media isKindOfClass:[VideoMediaItem class]])
                {
                       // VideoMediaItem *mediaItem = (VideoMediaItem *)message.media;
//                        MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:mediaItem.fileURL];
//                        [self presentMoviePlayerViewControllerAnimated:moviePlayer];
//                        [moviePlayer.moviePlayer play];
                }
        }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
        NSLog(@"didTapCellAtIndexPath %@", NSStringFromCGPoint(touchLocation));
        /*
        JSQMessagesCollectionView *cell =(JSQMessagesCollectionView*)[collectionView cellForItemAtIndexPath:indexPath];
        
        if(isSelected){
                if([arrSelectedItemsIndex containsObject:indexPath ]){
                        [arrSelectedItemsIndex removeObject:indexPath];
                        cell.backgroundColor=[UIColor clearColor];
                        [cell setAlpha:1];
                }
                else{
                        [arrSelectedItemsIndex addObject:indexPath];
                        cell.backgroundColor=[UIColor grayColor];
                        [cell setAlpha:0.5];
                }
                
                if(!arrSelectedItemsIndex.count)
                {
                        //[cell setUserInteractionEnabled:YES];
                        cell.backgroundColor=[UIColor clearColor];
                        [cell setAlpha:1];
                        self.inputToolbar.contentView.textView.editable=YES;
                        self.inputToolbar.contentView.rightBarButtonItem.enabled=YES;
                        
                        [self removeNavRightItems];
                        
                        selectedIndexPath=nil;
                        isSelected=NO;
                        
                }
                
        }
        */
}

#pragma mark - RNGridMenuDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
//        [gridMenu dismissAnimated:NO];
//        if ([item.title isEqualToString:@"Camera"])		PresentMultiCamera(self, YES);
//        if ([item.title isEqualToString:@"Audio"])		ActionPremium(self);
//        if ([item.title isEqualToString:@"Pictures"])	PresentPhotoLibrary(self, YES);
//        if ([item.title isEqualToString:@"Videos"])		PresentVideoLibrary(self, YES);
//        if ([item.title isEqualToString:@"Location"])	ActionPremium(self);
//        if ([item.title isEqualToString:@"Stickers"])	ActionPremium(self);
}

#pragma mark - UIImagePickerControllerDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
        NSURL *video = info[UIImagePickerControllerMediaURL];
        UIImage *picture = info[UIImagePickerControllerEditedImage];
        //---------------------------------------------------------------------------------------------------------------------------------------------
       // [self sendMessage:nil Video:video Picture:picture];
        //---------------------------------------------------------------------------------------------------------------------------------------------
        [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helper methods

//-------------------------------------------------------------------------------------------------------------------------------------------------


- (BOOL)incoming:(JSQMessage *)message
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
        return ([message.senderId isEqualToString:self.senderId] == NO);
}

//-------------------------------------------------------------------------------------------------------------------------------------------------

- (BOOL)outgoing:(JSQMessage *)message
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
        return ([message.senderId isEqualToString:self.senderId] == YES);
}





@end
