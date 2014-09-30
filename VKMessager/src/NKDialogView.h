//
//  NKDialogView.h
//  VKMessager
//
//  Created by Nick Kibish on 28.09.14.
//  Copyright (c) 2014 Nick Kibish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKDialogList.h"

@interface NKDialogView : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *userAvatar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) NSString *methodIdentifier;
@property (strong, nonatomic) NSString *currentID;
@property (strong, nonatomic) NSString *chatID;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NKUser *user;

- (IBAction)send:(id)sender;
- (void)update;

@end

@interface NKMessageCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *messageView;

@end
