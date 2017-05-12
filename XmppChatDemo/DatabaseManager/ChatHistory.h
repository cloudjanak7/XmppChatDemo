//
//  OfflineStopJobs.h
//  Wolf
//
//  Created by Infoicon on 09/09/16.
//  Copyright © 2016 InfoiconTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatHistory : NSObject

@property (nonatomic, retain) NSString *database_id;
@property (nonatomic, retain) NSString *chat_id;
@property (nonatomic, retain) NSString *from_username;
@property (nonatomic, retain) NSString *to_username;
@property (nonatomic, retain) NSString *chat_message;
@property (nonatomic, retain) NSString *chat_timestamp;


@end
