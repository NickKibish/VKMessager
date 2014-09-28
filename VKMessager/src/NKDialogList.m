//
//  NKDialogList.m
//  VKMessager
//
//  Created by Nick Kibish on 28.09.14.
//  Copyright (c) 2014 Nick Kibish. All rights reserved.
//

#import "NKDialogList.h"
#import "AppDelegate.h"

@interface NKDialogList ()

@end

@implementation NKDialogList

- (void)update
{
    [self.tableView reloadData];
}

- (IBAction)logOut:(id)sender
{
    [VKSdk forceLogout];
    [VKSdk initializeWithDelegate:[AppDelegate shareDelegate] andAppId:MY_APP_ID];
    if (![VKSdk wakeUpSession]) {
        NSArray *scope = @[VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS, VK_PER_EMAIL, VK_PER_MESSAGES];
        [VKSdk authorize:scope revokeAccess:YES];
    }
}

#pragma mark - Load View

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *delegate = [AppDelegate shareDelegate];
    delegate.dialogView = self;
    _dialogs = delegate.dialogs;
    _users = delegate.users;
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dialogs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NKDialogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.avatar.layer.cornerRadius = cell.avatar.frame.size.width / 2;
    cell.avatar.clipsToBounds = YES;
    
    id msg = [[_dialogs objectAtIndex:indexPath.row] valueForKey:@"message"];
    NSString *userID = [[msg valueForKey:@"user_id"] stringValue];
    NKUser *user = [_users valueForKey:userID];
    
    cell.userName.text = user.fullName;
    cell.avatar.image = user.avatar;
    
    [self setCellText:cell withMessage:msg];
    [self setCellViews:cell withMessage:msg];
    
    return cell;
}

- (void)setCellViews:(NKDialogCell *)cell withMessage:(NSDictionary *)message
{
    BOOL sent = [[message valueForKey:@"out"] boolValue];
    BOOL read = [[message valueForKey:@"read_state"] boolValue];
    UIColor *blue = [UIColor colorWithRed:237/255.f green:242/255.f blue:247/255.f alpha:1];
    
    if (!sent) {
        cell.myAvatar.image = nil;
        cell.myAvatar.layer.borderWidth = 0;
        
        if (!read) {
            cell.backgroundColor = blue;
            cell.messageView.backgroundColor = blue;
        } else {
            cell.backgroundColor = [UIColor whiteColor];
            cell.messageView.backgroundColor = [UIColor whiteColor];
        }
    } else {
        cell.myAvatar.layer.cornerRadius = cell.myAvatar.frame.size.width / 2;
        cell.myAvatar.clipsToBounds = YES;
        cell.myAvatar.layer.borderWidth = 2.0f;
        cell.myAvatar.layer.borderColor = blue.CGColor;
        cell.myAvatar.image = [AppDelegate shareDelegate].selfAvatar;
        
        if (!read) {
            cell.messageView.backgroundColor = blue;
            cell.backgroundColor = [UIColor whiteColor];
        } else {
            cell.messageView.backgroundColor = [UIColor whiteColor];
            cell.backgroundColor = [UIColor whiteColor];
        }
    }
}

- (void)setCellText:(NKDialogCell *)cell withMessage:(NSDictionary *)message
{
    NSArray *attachments = [message valueForKey:@"attachments"];
    if (!attachments) {
        cell.messagePreview.textColor = [UIColor colorWithRed:121/255.f green:124/255.f blue:128/255.f alpha:1];
        cell.messagePreview.text = [message valueForKey:@"body"];
    } else {
        id attachment = [attachments firstObject];
        NSString *type = [attachment valueForKey:@"type"];
        NSString *messageText = [self getDescriptionWithKey:type];
        
        cell.messagePreview.textColor = [UIColor colorWithRed:78/255.f green:113/255.f blue:153/255.f alpha:1];
        cell.messagePreview.text = messageText;
    }
}

- (NSString *)getDescriptionWithKey:(NSString *)key
{
    NSDictionary *values = @{@"photo":@"Фотография",
                             @"video":@"Видеозапись",
                             @"audio":@"Аудиозапись",
                             @"doc":@"Документ",
                             @"wall":@"Запись на стене",
                             @"wall_reply":@"Комментарий к записи на стене",};
    return [values valueForKey:key];
}

@end

@implementation NKUser

@end

@implementation NKDialogCell

- (instancetype)init
{
    if (self = [super init]) {
        self.avatar.layer.cornerRadius = self.avatar.frame.size.width / 2;
        self.avatar.clipsToBounds = YES;
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.avatar.layer.cornerRadius = self.avatar.frame.size.width / 2;
        self.avatar.clipsToBounds = YES;
    }
    return self;
}

@end