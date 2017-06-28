//
//  UsersViewController.m
//  XmppChatDemo
//
//  Created by Infoicon on 18/05/17.
//  Copyright © 2017 InfoiconTechnologies. All rights reserved.
//

#import "UsersViewController.h"
#import "ChatViewController.h"

@interface UsersViewController ()
{
    NSArray *arrayUsers;
}
@end

@implementation UsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrayUsers=@[@"kollyde999@localhost",@"kollyde1000@localhost",@"kollyde1001@localhost"];
}

#pragma mark:- Tableview delegate and datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arrayUsers.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    
    cell.textLabel.text=arrayUsers[indexPath.row];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *userId = arrayUsers[indexPath.row];
    
    ChatViewController* vc=[[ChatViewController alloc]initWithUser:userId];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
