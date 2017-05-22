//
//  GroupDialogViewController.m
//  XmppChatDemo
//
//  Created by Infoicon on 18/05/17.
//  Copyright © 2017 InfoiconTechnologies. All rights reserved.
//

#import "GroupDialogViewController.h"
#import "GroupDialogTVC.h"

@interface GroupDialogViewController ()
{

    NSArray *arrayGroupName;
}
@property (weak, nonatomic) IBOutlet UITextField *txtCreateGroup;
@end

@implementation GroupDialogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    arrayGroupName=@[@"Test"];
}

- (IBAction)btnCreateGroup:(id)sender {
    
    if(_txtCreateGroup.text.length==0){
    
    }else{
    
       
    }
}



#pragma mark:- Tableview delegate and datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arrayGroupName.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GroupDialogTVC *cell=[tableView dequeueReusableCellWithIdentifier:@"GroupDialogTVC"];
    
    cell.detailTextLabel.text=arrayGroupName[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    DialogHistory *dialog= arrayDialog[indexPath.row];
//    ChatViewController* vc=[[ChatViewController alloc]initWithUser:[dialog.last_username stringByAppendingString:@"@localhost"]];
//    [self.navigationController pushViewController:vc animated:YES];
//    
//    
//    dialog.unread_count=0;
//    DBManager *dataManager=[[DBManager alloc]initWithDB:DATABASE_NAME];
//    [dataManager insertAndUpdateDialogHistoryWithArrayUsingTrasaction:@[dialog]];
    
}

@end
