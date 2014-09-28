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

#pragma mark - Load View

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *delegate = [AppDelegate shareDelegate];
    delegate.dialogView = self;
    _dialogs = delegate.dialogs;
    _users = delegate.users;
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
    NSString *body = [msg valueForKey:@"body"];
    NSString *userID = [[msg valueForKey:@"user_id"] stringValue];
    NKUser *user = [_users valueForKey:userID];
    
    cell.userName.text = user.fullName;
    cell.messagePreview.text = body;
    cell.avatar.image = user.avatar;
    
    return cell;
}

- (void)setCellText:(NKDialogCell *)cell withMessage:(NSDictionary *)message
{
    NSArray *attachments = [message valueForKey:@"attachments"];
    if (!attachments) {
        cell.messagePreview.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        cell.messagePreview.text = [message valueForKey:@"body"];
    } else {
        id attachment = [attachments firstObject];
        NSString *type = [attachment valueForKey:@"type"];
        NSString *messageText = [self getDescriptionWithKey:type];
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