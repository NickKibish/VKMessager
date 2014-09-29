//
//  AppDelegate.m
//  VKMessager
//
//  Created by Nick Kibish on 28.09.14.
//  Copyright (c) 2014 Nick Kibish. All rights reserved.
//

#import "AppDelegate.h"
#import "NKDialogList.h"

@interface AppDelegate ()
{
    NKDialogList *_dialogList;
}

@end

@implementation AppDelegate
+ (AppDelegate *)shareDelegate
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate;
}

- (void)startWorking
{
    VKRequest *avatarRequ = [VKRequest requestWithMethod:@"users.get"
                                           andParameters:@{@"fields":@"photo_50",}
                                           andHttpMethod:@"GET"];
    [avatarRequ executeWithResultBlock:^(VKResponse *response) {
        NSString *link = [[response.json firstObject] valueForKey:@"photo_50"];
        NSURL *avatarURL = [NSURL URLWithString:link];
        NSData *data = [NSData dataWithContentsOfURL:avatarURL];
        UIImage *image = [UIImage imageWithData:data];
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 30), NO, 0.0);
        [image drawInRect:CGRectMake(0, 0, 30, 30)];
        _selfAvatar= UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    } errorBlock:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:@"Ошибка" message:@"Время подсоеденения к серверу истекло" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }];
    VKRequest *request = [VKRequest requestWithMethod:@"messages.getDialogs"
                                        andParameters:@{@"count":@30}
                                        andHttpMethod:@"GET"];
    [request executeWithResultBlock:^(VKResponse *response) {
        NSArray *items = [response.json valueForKey:@"items"];
        [_dialogs addObjectsFromArray:items];
        NSMutableString *uIDs = [NSMutableString string];
        for (id msg in items) {
            NSString *userID = [[[msg valueForKey:@"message"] valueForKey:@"user_id"] stringValue];
            [uIDs appendString:userID];
            [uIDs appendString:@","];
        }
        [uIDs deleteCharactersInRange:NSMakeRange([uIDs length]-1, 1)];
        [self loadUserDataWithUserIDs:uIDs];
    } errorBlock:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)loadUserDataWithUserIDs:(NSString *)userIDs
{
    VKRequest *r = [VKRequest requestWithMethod:@"users.get"
                                  andParameters:@{@"fields":@"photo_50,online,online_mobile",
                                                  @"user_ids":userIDs}
                                  andHttpMethod:@"GET"];
    [r executeWithResultBlock:^(VKResponse *response) {
        for (id userData in response.json) {
            NKUser *user = [[NKUser alloc] init];
            user.fullName = [NSString stringWithFormat:@"%@ %@",
                             [userData valueForKey:@"first_name"],
                             [userData valueForKey:@"last_name"]];
            
            NSString *avatarLink = [userData valueForKey:@"photo_50"];
            NSURL *avatarURL = [NSURL URLWithString:avatarLink];
            NSData *imgData = [NSData dataWithContentsOfURL:avatarURL];
            UIImage *image = [UIImage imageWithData:imgData];
            user.avatar = image;
            
            NSString *userID = [[userData valueForKey:@"id"] stringValue];
            [_users setValue:user forKey:userID];
        }
        [_dialogView update];
    } errorBlock:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - Properties
- (NSMutableArray *)dialogs
{
    if (!_dialogs)
        _dialogs = [NSMutableArray array];
    return _dialogs;
}

- (NSMutableDictionary *)users
{
    if (!_users)
        _users = [NSMutableDictionary dictionary];
    return _users;
}

#pragma mark - Application delegate
- (BOOL)            application:(UIApplication *)application
  didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _dialogList = [self.window.rootViewController.navigationController.viewControllers firstObject];
    [VKSdk initializeWithDelegate:self andAppId:MY_APP_ID];
    if ([VKSdk wakeUpSession])
    {
        [self startWorking];
    } else {
        NSArray *scope = @[VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS, VK_PER_EMAIL, VK_PER_MESSAGES];
        [VKSdk authorize:scope revokeAccess:YES];
    }
    return YES;
}

#pragma mark - VK Delegate
-(BOOL)application:(UIApplication *)application
           openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
        annotation:(id)annotation
{
    [VKSdk processOpenURL:url fromApplication:sourceApplication];
    return YES;
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError
{
    
}

- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken
{
    
}

- (void)vkSdkUserDeniedAccess:(VKError *)authorizationError
{
    
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller
{
    [self.window.rootViewController presentViewController:controller animated:YES completion:^{}];
}

- (void)vkSdkReceivedNewToken:(VKAccessToken *)newToken
{
    [self startWorking];
}

@end
