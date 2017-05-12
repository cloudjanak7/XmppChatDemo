//
//  DialogHistory.h
//  Talk2Good
//
//  Created by Sandeep Kumar on 19/11/15.
//  Copyright © 2015 InfoiconTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DialogHistory : NSObject

@property (nonatomic, retain) NSString *Id;
@property (nonatomic, retain) NSString *dialog_id;
@property (nonatomic, retain) NSString *last_message;
@property (nonatomic, retain) NSString *last_username;
@property (nonatomic, retain) NSString *last_message_date;
@property (nonatomic, retain) NSString *created_date;
@property int unread_count;

@end
