//
//  DialogTableViewCell.h
//  XmppChatDemo
//
//  Created by Infoicon on 11/05/17.
//  Copyright © 2017 InfoiconTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DialogTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblLastMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblUnreadMessageCount;

@end
