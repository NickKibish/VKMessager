//
//  NKDialogView.m
//  VKMessager
//
//  Created by Nick Kibish on 28.09.14.
//  Copyright (c) 2014 Nick Kibish. All rights reserved.
//

#import "NKDialogView.h"
#import "AppDelegate.h"
#import "UIImageViewUtiles.h"

@interface NKDialogView ()
{
    CGPoint _originalCenter;
}

@property (strong, nonatomic) NSMutableArray *messages;

@end

@implementation NKDialogView

#pragma maek - Properties
- (NSMutableArray *)messages
{
    if (!_messages) {
        _messages = [NSMutableArray array];
    }
    return _messages;
}

- (NSString *)currentID
{
    if (!self.userID) {
        _currentID = self.chatID;
    } else {
        _currentID = self.userID;
    }
    return _currentID;
}

- (NSString *)methodIdentifier
{
    if (!self.userID) {
        _methodIdentifier = @"chat_id";
    } else {
        _methodIdentifier = @"user_id";
    }
    return _methodIdentifier;
}

- (IBAction)send:(id)sender
{
    VKRequest *sendRequest = [VKRequest requestWithMethod:@"messages.send"
                                            andParameters:@{self.methodIdentifier:self.currentID,
                                                            @"message":self.textField.text}
                                            andHttpMethod:@"GET"];
    [sendRequest executeWithResultBlock:^(VKResponse *response) {
        NSString *mid = [response.json stringValue];
        VKRequest *getMessage = [VKRequest requestWithMethod:@"messages.getById"
                                               andParameters:@{@"message_ids":mid}
                                               andHttpMethod:@"GET"];
        [getMessage executeWithResultBlock:^(VKResponse *response) {
            NSArray *messages = [response.json valueForKey:@"items"];
            [_messages insertObject:[messages firstObject] atIndex:0];
            NSArray *arr = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0
                                                                       inSection:0]];
            [self.tableView insertRowsAtIndexPaths:arr
                                  withRowAnimation:UITableViewRowAnimationBottom];
            self.textField.text = @"";
            [self.textField resignFirstResponder];
        }errorBlock:^(NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }errorBlock:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)update
{
    [self doRequestWithOffset:0];
}

- (void)doRequestWithOffset:(NSInteger)offset
{
    NSNumber *offsetNumber = [NSNumber numberWithInteger:offset];
    VKRequest *request = [VKRequest requestWithMethod:@"messages.getHistory"
                                        andParameters:@{@"user_id":_userID,
                                                        @"count":@30,
                                                        @"offset":offsetNumber}
                                        andHttpMethod:@"GET"];
    [request executeWithResultBlock:^(VKResponse *response) {
        [self.messages addObjectsFromArray:[response.json valueForKey:@"items"]];
        [self.tableView reloadData];
    }errorBlock:^(NSError *error){
        NSLog(@"Error: %@", error);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _originalCenter = self.view.center;
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI);
    
//    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.title = self.user.fullName;
    [self.userAvatar makeRound];
    self.userAvatar.image = self.user.avatar;

    [self doRequestWithOffset:0];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
    cell.transform = CGAffineTransformMakeRotation(M_PI);
    
    id msg = [_messages objectAtIndex:indexPath.row];
    NSString *str = [msg valueForKey:@"body"];
    BOOL sent = [[msg valueForKey:@"out"] boolValue];
    
    cell.textLabel.text = str;
    if (sent) {
        cell.textLabel.textAlignment = NSTextAlignmentRight;
    } else {
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    return cell;
}

#pragma mark Tableview Delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_messages.count > 25) {
        if (indexPath.row == _messages.count - 5) {
            [self doRequestWithOffset:_messages.count];
        }
    }
}

#pragma mark - TextField Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    return YES; }


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self send:nil];
    return YES;
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardBoundsUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    CGPoint center = CGPointMake(self.view.center.x, _originalCenter.y - keyboardFrameBeginRect.size.height);
    self.view.center = center;
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    self.view.center = _originalCenter;
}

@end
