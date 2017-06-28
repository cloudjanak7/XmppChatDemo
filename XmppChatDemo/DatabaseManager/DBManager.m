//
//  DBManager.m
//  KETTENSAEGE SHOP 24
//
//  Created by Infoicon on 05/01/16.
//  Copyright © 2016 InfoiconTechnologies. All rights reserved.
//

#import "DBManager.h"
#import "DialogHistory.h"


@implementation DBManager

#pragma mark - InitWithDB:-


- (id)initWithDB:(NSString*)dbName{
    if(self = [super init])
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:dbName];
        
        NSLog(@"writableDBPath =%@",writableDBPath);
        
        if (sqlite3_open([writableDBPath UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"could not prepare statement: %s\n", sqlite3_errmsg(_database));
            NSLog(@"Failed to open database!");
        }
    }
    return self;
}
#pragma mark - Create a copy of DB.

+ (BOOL)createEditableCopyOfDatabaseIfNeeded:(NSString*)dbName {
    
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:dbName];
    success = [fileManager fileExistsAtPath:writableDBPath];
    
    if (success) {
        NSLog(@"File Exist->%@",writableDBPath);
        return success;
    }
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    else{
        NSURL* fileURL = [NSURL fileURLWithPath:writableDBPath];
        [DBManager addSkipBackupAttributeToItemAtURL:fileURL];
    }
    return success;
}


#pragma mark - Add Skip Backup on Cloud

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
    if([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]){
        assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
        NSError *error = nil;
        BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
            NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        }
        return success;
    }
    else{
        NSLog(@"File Not Exist for excluding from backup->%@",URL);
        return NO;
    }
}

#pragma mark - Remove DB

+(void)removeFile:(NSString *)fileName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    
    
    if([fileManager fileExistsAtPath:filePath]){
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:filePath error:&error];
        if (success) {
            NSLog(@"Remove File : %@",filePath);
        }
        else
        {
            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
        }
    }
    else
        NSLog(@"File not Exist");
}


#pragma mark - Insert a rerod from DB Table
#pragma mark - Insert Record into Chat message history Table.
-(void)insertAndUpdateChatWithArrayUsingTrasaction:(NSArray*)arr{
    
    int insert=0,delete=0;
    NSLog(@"Employee data saving------->%lu",(unsigned long)arr.count);
    
    if(arr.count){
        const char *queryInsertAndUpdate =
        "INSERT OR REPLACE INTO CHAT_HISTORY         (chat_id,from_username,to_username,chat_message,chat_timestamp,message_stamp)VALUES(?,?,?,?,?,?)";
        const char *queryDelete = "delete from CHAT_HISTORY where chat_id=?";
        sqlite3_stmt *compiledStatement1 = nil;
        sqlite3_stmt *compiledStatement2 = nil;
        sqlite3_exec(_database, "BEGIN EXCLUSIVE TRANSACTION", 0, 0, 0);
        NSLog(@"sqlState =%d",sqlite3_prepare(_database, queryInsertAndUpdate, -1, &compiledStatement1, NULL));
        BOOL insertPrepare=(sqlite3_prepare(_database, queryInsertAndUpdate, -1, &compiledStatement1, NULL) == SQLITE_OK) ? YES : NO;
        BOOL deletePrepare=(sqlite3_prepare(_database, queryDelete, -1, &compiledStatement2, NULL) == SQLITE_OK )? YES : NO;
        //        NSLog(@"Insert Prepare->%hhd",insertPrepare);
        //        NSLog(@"Delete Prepare->%hhd",deletePrepare);
        
        if(insertPrepare || deletePrepare)
            for (int i = 0; i < arr.count; i++)
            {
                ChatHistory *chat = [arr objectAtIndex:i];
                
                // Insert or Replace
                
                if(chat!=nil && insertPrepare){
                    
                    sqlite3_bind_text(compiledStatement1, 1, [chat.chat_id UTF8String], -1, SQLITE_STATIC);
                    
                    sqlite3_bind_text(compiledStatement1, 2, [chat.from_username UTF8String], -1, SQLITE_STATIC);
                    
                    sqlite3_bind_text(compiledStatement1, 3, [chat.to_username  UTF8String], -1, SQLITE_STATIC);
                    
                    sqlite3_bind_text(compiledStatement1, 4, [chat.chat_message UTF8String], -1, SQLITE_STATIC);
                    
                    sqlite3_bind_text(compiledStatement1, 5, [chat.chat_timestamp UTF8String], -1, SQLITE_STATIC);
                    
                     sqlite3_bind_text(compiledStatement1, 6, [chat.message_stamp UTF8String], -1, SQLITE_STATIC);
                    
                    
                    if (sqlite3_step(compiledStatement1) != SQLITE_DONE)
                        NSLog(@"Values not inserted. Error: %s",sqlite3_errmsg(_database));
                    
                    if (sqlite3_reset(compiledStatement1) != SQLITE_OK)
                        NSLog(@"SQL Error: %s",sqlite3_errmsg(_database));
                    
                    insert+=1;
                }
                
            }
        
        //Close transaction for insert & update
        if (sqlite3_finalize(compiledStatement1) != SQLITE_OK)
            NSLog(@"SQL Error: %s",sqlite3_errmsg(_database));
        
        //Close transaction for delete
        if (sqlite3_finalize(compiledStatement2) != SQLITE_OK)
            NSLog(@"SQL Error: %s",sqlite3_errmsg(_database));
        
        if (sqlite3_exec(_database, "COMMIT TRANSACTION", 0, 0, 0) != SQLITE_OK)
            NSLog(@"SQL Error: %s",sqlite3_errmsg(_database));
    }
    
    NSLog(@"Record Add or Update->%d",insert);
    NSLog(@"Record Delete->%d",delete);
}

#pragma mark - Get Chat history Records
- (NSArray*)getChatHistoryData:(NSString*)tableName{
    
    
    NSMutableArray *retval = [[NSMutableArray alloc] init]; //
    NSString *query = [NSString stringWithFormat:@"SELECT message_id,chat_id,from_username,to_username,chat_message,chat_timestamp,message_stamp FROM %@",tableName];
    const char* queryUTF8 = [query UTF8String];
    sqlite3_stmt *statement;
    
    @autoreleasepool {
        int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
        if (response == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                // int uniqueId = sqlite3_column_int(statement, 0);
                ChatHistory * jobs=[[ChatHistory alloc]init];
                
                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 0);
                    jobs.message_id = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    jobs.message_id = @"NULL";
                
                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 1);
                    jobs.chat_id = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    jobs.chat_id = @"NULL";
                
                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 2);
                    jobs.from_username = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    jobs.from_username = @"NULL";
                
                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 3);
                    jobs.to_username = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    jobs.to_username = @"NULL";
                
                if ( sqlite3_column_type(statement, 4) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 4);
                    jobs.chat_message = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    jobs.chat_message = @"NULL";
                
                if ( sqlite3_column_type(statement, 5) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 5);
                    jobs.chat_timestamp = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    jobs.chat_timestamp = @"NULL";
                
                if ( sqlite3_column_type(statement, 6) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 6);
                    jobs.message_stamp = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    jobs.message_stamp = @"NULL";
                
                
                [retval addObject:jobs];
            }
            sqlite3_finalize(statement);
        }
    }
    return retval;
}

#pragma mark - Get Chat history Records
- (NSArray*)getGroupChatHistoryWithChatId:(NSString*)chat_id{
    
    
    NSMutableArray *retval = [[NSMutableArray alloc] init]; //
       NSString *query = [NSString stringWithFormat:@"SELECT message_id,chat_id,from_username,to_username,chat_message,chat_timestamp,message_stamp FROM CHAT_HISTORY WHERE chat_id = '%@'",chat_id];
    const char* queryUTF8 = [query UTF8String];
    sqlite3_stmt *statement;
    
    @autoreleasepool {
        int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
        if (response == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                // int uniqueId = sqlite3_column_int(statement, 0);
                ChatHistory * jobs=[[ChatHistory alloc]init];
                
                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 0);
                    jobs.message_id = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    jobs.message_id = @"NULL";
                
                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 1);
                    jobs.chat_id = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    jobs.chat_id = @"NULL";
                
                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 2);
                    jobs.from_username = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    jobs.from_username = @"NULL";
                
                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 3);
                    jobs.to_username = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    jobs.to_username = @"NULL";
                
                if ( sqlite3_column_type(statement, 4) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 4);
                    jobs.chat_message = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    jobs.chat_message = @"NULL";
                
                if ( sqlite3_column_type(statement, 5) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 5);
                    jobs.chat_timestamp = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    jobs.chat_timestamp = @"NULL";
                
                if ( sqlite3_column_type(statement, 6) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 6);
                    jobs.message_stamp = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    jobs.message_stamp = @"NULL";
                
                
                [retval addObject:jobs];
            }
            sqlite3_finalize(statement);
        }
    }
    return retval;
}


- (NSArray*)getChatHistoryData:(NSString*)tableName fromUser:(NSString*)fromUser toUser:(NSString*)toUser{
  
    NSMutableArray *retval = [[NSMutableArray alloc] init]; //
    NSString *query = [NSString stringWithFormat:@"SELECT message_id,chat_id,from_username,to_username,chat_message,chat_timestamp,message_stamp FROM %@ WHERE (from_username = '%@' AND to_username = '%@') OR (from_username = '%@' AND to_username = '%@') ",tableName,fromUser,toUser,toUser,fromUser];
    const char* queryUTF8 = [query UTF8String];
    sqlite3_stmt *statement;
    
    @autoreleasepool {
        int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
        if (response == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                // int uniqueId = sqlite3_column_int(statement, 0);
                ChatHistory * jobs=[[ChatHistory alloc]init];
                
                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 0);
                    jobs.message_id = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    jobs.message_id = @"NULL";
                
                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 1);
                    jobs.chat_id = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    jobs.chat_id = @"NULL";
                
                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 2);
                    jobs.from_username = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    jobs.from_username = @"NULL";
                
                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 3);
                    jobs.to_username = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    jobs.to_username = @"NULL";
                
                if ( sqlite3_column_type(statement, 4) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 4);
                    jobs.chat_message = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    jobs.chat_message = @"NULL";
                
                if ( sqlite3_column_type(statement, 5) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 5);
                    jobs.chat_timestamp = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    jobs.chat_timestamp = @"NULL";
                
                if ( sqlite3_column_type(statement, 6) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 6);
                    jobs.message_stamp = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    jobs.message_stamp = @"NULL";
                
                
                [retval addObject:jobs];
            }
            sqlite3_finalize(statement);
        }
    }
    return retval;

}


#pragma mark:- Using Dialog History Transaction
//Dialog History
-(void)insertAndUpdateDialogHistoryWithArrayUsingTrasaction:(NSArray*)arr{
    
    int insert=0,delete=0;
    NSLog(@"DialogHistory data saving------->%lu",(unsigned long)arr.count);
    
    if(arr.count){
        
        
        const char *queryInsertAndUpdate =
        "INSERT OR REPLACE INTO DIALOG_HISTORY (                                                                                                                                                                                                                   dialog_id,                                                                                                                            last_message,                                                                                                                                 last_username,                                                                                                                                  last_message_date,                                                                                                                                   created_date,                                                                                                        unread_count,                                                                                                        chat_id)                                                                                                                                       VALUES(?,?,?,?,?,?,?)";
        
        const char *queryDelete = "delete from DIALOG_HISTORY where dialog_id=?";
        
        sqlite3_stmt *compiledStatement1 = nil;
        sqlite3_stmt *compiledStatement2 = nil;
        
        sqlite3_exec(_database, "BEGIN EXCLUSIVE TRANSACTION", 0, 0, 0);
        
        BOOL insertPrepare=(sqlite3_prepare(_database, queryInsertAndUpdate, -1, &compiledStatement1, NULL) == SQLITE_OK) ? YES : NO;
        BOOL deletePrepare=(sqlite3_prepare(_database, queryDelete, -1, &compiledStatement2, NULL) == SQLITE_OK )? YES : NO;
        //        NSLog(@"Insert Prepare->%hhd",insertPrepare);
        //        NSLog(@"Delete Prepare->%hhd",deletePrepare);
        
        if(insertPrepare || deletePrepare)
            for (int i = 0; i < arr.count; i++) {
                DialogHistory * dialogHistory = [arr objectAtIndex:i];
                
                //                if(exhibitors==nil)
                //                    NSLog(@"Object not found");
                //                else
                // Insert or Replace
                
                if(dialogHistory!=nil && insertPrepare){
                    
                    sqlite3_bind_text(compiledStatement1, 1, [dialogHistory.dialog_id UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(compiledStatement1, 2, [dialogHistory.last_message UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(compiledStatement1, 3, [dialogHistory.last_username UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(compiledStatement1, 4, [dialogHistory.last_message_date UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(compiledStatement1, 5, [dialogHistory.created_date UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_int (compiledStatement1, 6, dialogHistory.unread_count);
                     sqlite3_bind_text(compiledStatement1, 7, [dialogHistory.chat_id UTF8String], -1, SQLITE_STATIC);
                    
                    if (sqlite3_step(compiledStatement1) != SQLITE_DONE)
                        NSLog(@"Values not inserted. Error: %s",sqlite3_errmsg(_database));
                    if (sqlite3_reset(compiledStatement1) != SQLITE_OK)
                        NSLog(@"SQL Error: %s",sqlite3_errmsg(_database));
                    
                    insert+=1;
                }
              
            }
        
        //Close transaction for insert & update
        if (sqlite3_finalize(compiledStatement1) != SQLITE_OK)
            NSLog(@"SQL Error: %s",sqlite3_errmsg(_database));
        
        //Close transaction for delete
        if (sqlite3_finalize(compiledStatement2) != SQLITE_OK)
            NSLog(@"SQL Error: %s",sqlite3_errmsg(_database));
        
        if (sqlite3_exec(_database, "COMMIT TRANSACTION", 0, 0, 0) != SQLITE_OK)
            NSLog(@"SQL Error: %s",sqlite3_errmsg(_database));
    }
    
    NSLog(@"Record Add or Update->%d",insert);
    NSLog(@"Record Delete->%d",delete);
}


- (NSArray*)GetDialogHistoryData{
    
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    NSString *query = @"SELECT * from DIALOG_HISTORY";
    const char* queryUTF8 = [query UTF8String];
    sqlite3_stmt *statement;
    
    @autoreleasepool {
        int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
        if (response == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                // int uniqueId = sqlite3_column_int(statement, 0);
                DialogHistory* dh=[[DialogHistory alloc]init];
                
                //                                int Id = sqlite3_column_int(statement, 0);
                //                                dh.Id=@(Id);
                
                
                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 0);
                    dh.dialog_id = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    dh.dialog_id=@"NULL";
                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 1);
                    dh.last_message = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    dh.last_message=@"NULL";
                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 2);
                    dh.last_username = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    dh.last_username=@"NULL";
                
                
                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 3);
                    dh.last_message_date = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    dh.last_message_date=@"NULL";
                
                if ( sqlite3_column_type(statement, 4) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 4);
                    dh.created_date = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    dh.created_date=@"NULL";
                
                if ( sqlite3_column_type(statement, 5) != SQLITE_NULL ){
                    
                    dh.unread_count = sqlite3_column_int(statement, 5);
                }
                else
                    dh.unread_count=0;
                
                if ( sqlite3_column_type(statement, 6) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 6);
                    dh.chat_id = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    dh.chat_id=@"NULL";
                
        
                
                [retval addObject:dh];
            }
            sqlite3_finalize(statement);
        }
    }
    return retval;
}

//- (NSArray*)GetDialogHistoryData{
//    
//    NSMutableArray *retval = [[NSMutableArray alloc] init]; //
//    NSString *query = [NSString stringWithFormat:@"SELECT id,dialog_id,last_message,last_username,last_message_date,created_date,unread_count,chat_id FROM DIALOG_HISTORY"];
//    const char* queryUTF8 = [query UTF8String];
//    sqlite3_stmt *statement;
//    
//    @autoreleasepool {
//        int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
//        if (response == SQLITE_OK) {
//            while (sqlite3_step(statement) == SQLITE_ROW) {
//                // int uniqueId = sqlite3_column_int(statement, 0);
//                DialogHistory * jobs=[[DialogHistory alloc]init];
//                
//                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
//                    char *nameChars = (char *) sqlite3_column_text(statement, 0);
//                    jobs.Id = [[NSString alloc] initWithUTF8String:nameChars];
//                }
//                else
//                    jobs.Id = @"NULL";
//                
//                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL ){
//                    char *nameChars = (char *) sqlite3_column_text(statement, 1);
//                    jobs.dialog_id = [[NSString alloc] initWithUTF8String:nameChars];
//                }
//                else
//                    jobs.dialog_id = @"NULL";
//                
//                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL ){
//                    char *nameChars = (char *) sqlite3_column_text(statement, 2);
//                    jobs.last_message = [[NSString alloc] initWithUTF8String:nameChars];
//                }
//                else
//                    jobs.last_message = @"NULL";
//                
//                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL ){
//                    char *nameChars = (char *) sqlite3_column_text(statement, 3);
//                    jobs.last_username = [[NSString alloc] initWithUTF8String:nameChars];
//                }
//                else
//                    jobs.last_username = @"NULL";
//                
//                if ( sqlite3_column_type(statement, 4) != SQLITE_NULL ){
//                    char *nameChars = (char *) sqlite3_column_text(statement, 4);
//                    jobs.last_message_date = [[NSString alloc] initWithUTF8String:nameChars];
//                }
//                else
//                    jobs.last_message_date = @"NULL";
//                
//                if ( sqlite3_column_type(statement, 5) != SQLITE_NULL ){
//                    char *nameChars = (char *) sqlite3_column_text(statement, 5);
//                    jobs.created_date = [[NSString alloc] initWithUTF8String:nameChars];
//                }
//                else
//                    jobs.created_date = @"NULL";
//                
//                if ( sqlite3_column_type(statement, 6) != SQLITE_NULL ){
//                   // char *nameChars = (char *) sqlite3_column_int(statement, 6);
//                    jobs.unread_count = sqlite3_column_int(statement, 6);
//                }
//                else
//                    jobs.unread_count = 0;
//                
//                if ( sqlite3_column_type(statement, 7) != SQLITE_NULL ){
//                    char *nameChars = (char *) sqlite3_column_text(statement, 7);
//                    jobs.chat_id = [[NSString alloc] initWithUTF8String:nameChars];
//                }
//                else
//                    jobs.chat_id = @"NULL";
//                
//                
//                [retval addObject:jobs];
//            }
//            sqlite3_finalize(statement);
//        }
//    }
//    return retval;
//    
//}



#pragma mark - Delete a rerod from DB Table
-(void)deleteRecordFromTableName:(NSString*)tableName chat_id:(NSString *)chat_id{
    
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE chat_id ='%@'",tableName,chat_id];
    
    const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
    sqlite3_stmt *statement = nil;
    
    if(sqlite3_prepare_v2(_database,sql, -1, &statement, NULL)!= SQLITE_OK)
    {
        NSAssert1(0,@"error preparing statement",sqlite3_errmsg(_database));
    }
    else
    {
        sqlite3_step(statement);
    }
    sqlite3_finalize(statement);
}


#pragma mark - deleteAllRecordsFromTable
-(void)deleteAllRecordsFromTable:(NSString *)tableName{
     NSString *query = [NSString stringWithFormat:@"DELETE from %@",tableName];
    
    const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
    sqlite3_stmt *statement = nil;
    
    if(sqlite3_prepare_v2(_database,sql, -1, &statement, NULL)!= SQLITE_OK)
    {
        NSAssert1(0,@"error preparing statement",sqlite3_errmsg(_database));
    }
    else
    {
        sqlite3_step(statement);
    }
    sqlite3_finalize(statement);
}





#pragma mark - Create A table With Name..
-(BOOL)createTableWithName:(NSString*)tableName{
    
    int rc=0;
    
    NSString* queryString=[NSString stringWithFormat:
                           @"CREATE TABLE IF NOT EXISTS %@                                                                                                         (                                                                                                                               messageId INTEGER ,                                                                                                           message  TEXT,                                                                                                           sender  TEXT,                                                                                                           'to'  TEXT,                                                                                                           time  TEXT)",tableName];
    
    
    char * query =(char*)[queryString UTF8String];
    char * errMsg;
    rc = sqlite3_exec(_database, query,NULL,NULL,&errMsg);
    
    if(SQLITE_OK != rc)
    {
        NSLog(@"Failed to create table rc:%d, msg=%s",rc,errMsg);
        return NO;
    }
    else    NSLog(@"Successfully created '%@' Table",tableName);
    
    return YES;
    // sqlite3_close(db);
}

//-(NSMutableArray *)sorted:(NSMutableArray *)array withKey:(NSString *)date{
//    
//    NSMutableArray *arrayOfSorting = [[NSMutableArray alloc]init];;
//    for (AssignJob *assign in array) {
//        NSSortDescriptor *dateDescriptor = [NSSortDescriptor
//                                            sortDescriptorWithKey:assign.job_date
//                                            ascending:YES];
//        NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
//        NSArray *sortedEventArray = [array
//                                     sortedArrayUsingDescriptors:sortDescriptors];
//        [arrayOfSorting addObjectsFromArray:sortedEventArray];
//
//    }
//    return arrayOfSorting;
//    
//}


- (NSString*)getCreationDate:(NSString *)query{
    NSString* creationDate;
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
        if (sqlite3_step(statement)==SQLITE_ROW)
        {
            if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                char *nameChars = (char *) sqlite3_column_text(statement, 0);
                creationDate = [[NSString alloc] initWithUTF8String:nameChars];
            }
            else creationDate=nil;
        }
        else
        {
            creationDate=nil;
            //NSLog(@"%s,",sqlite3_errmsg(_database));
        }
        sqlite3_finalize(statement);
        // sqlite3_close(_database);
    }
    else
        NSLog(@"Query Not Executed");
    return creationDate;
}


- (int)getUnreadCount:(NSString *)query{
    int unread=0;
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
        if (sqlite3_step(statement)==SQLITE_ROW)
        {
            
            if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                unread = sqlite3_column_int(statement, 0);
            }
        }
        else
        {
            //NSLog(@"%s,",sqlite3_errmsg(_database));
        }
        sqlite3_finalize(statement);
        // sqlite3_close(_database);
    }
    else
        NSLog(@"Query Not Executed");
    return unread;
}


@end
