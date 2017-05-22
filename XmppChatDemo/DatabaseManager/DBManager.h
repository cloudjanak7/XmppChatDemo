//
//  DBManager.h
//  KETTENSAEGE SHOP 24
//
//  Created by Infoicon on 05/01/16.
//  Copyright © 2016 InfoiconTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ChatHistory.h"

#define DATABASE_NAME            @"XmppChatDemo.sqlite"
#define TABLE_NAME_CHAT_HISTORY  @"CHAT_HISTORY"
#define TABLE_NAME_DIALOG_HISTORY  @"DIALOG_HISTORY"

@interface DBManager : NSObject
{
    sqlite3 *_database;
}
// init sqlite database with name
- (id)initWithDB:(NSString*)dbName;
// create editable copy database with database name
+ (BOOL)createEditableCopyOfDatabaseIfNeeded:(NSString*)dbName;
// add skip backup attribute on cloud
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
// Remove file of DB
+(void)removeFile:(NSString *)fileName;


-(void)insertAndUpdateChatWithArrayUsingTrasaction:(NSArray*)arr;

-(void)deleteRecordFromTableName:(NSString*)tableName chat_id:(NSString *)chat_id;

// Insert record..
-(void)deleteAllRecordsFromTable:(NSString *)tableName;

- (NSArray*)getChatHistoryData:(NSString*)tableName;

- (NSArray*)getGroupChatHistoryWithChatId:(NSString*)chat_id;

- (NSArray*)getChatHistoryData:(NSString*)tableName fromUser:(NSString*)fromUser toUser:(NSString*)toUser;

-(void)insertAndUpdateDialogHistoryWithArrayUsingTrasaction:(NSArray*)arr;
- (NSArray*)GetDialogHistoryData;
- (NSString*)getCreationDate:(NSString *)query;

- (int)getUnreadCount:(NSString *)query;

//- (BOOL)recordExistOrNot:(NSString *)query;











@end
