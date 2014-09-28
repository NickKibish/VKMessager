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
    VKRequest *request = [VKRequest requestWithMethod:@"messages.getDialogs"
                                        andParameters:@{@"count":@50}
                                        andHttpMethod:@"GET"];
    [request executeWithResultBlock:^(VKResponse *response) {
        NSArray *items = [response.json valueForKey:@"items"];
        _dialogList.dialogs = [NSMutableArray arrayWithArray:items];
        NSMutableArray *users = [NSMutableArray array];
        for (id msg in items) {
            NSString *userID = [[msg valueForKey:@"message"] valueForKey:@"user_id"];
            [users addObject:userID];
        }
        [self loadUserDataWithUserIDs:users];
    } errorBlock:^(NSError *error) {
        
    }];
}

- (void)loadUserDataWithUserIDs:(NSArray *)userIDs
{
    VKRequest *r = [VKRequest requestWithMethod:@"users.get"
                                  andParameters:@{@"fields":@"photo_50,online,online_mobile"}
                                  andHttpMethod:@"GET"];
    [r executeWithResultBlock:^(VKResponse *response) {
        
    } errorBlock:^(NSError *error) {
        
    }];
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
    [_dialogList presentViewController:controller animated:YES completion:^{}];
}

- (void)vkSdkReceivedNewToken:(VKAccessToken *)newToken
{
    
}

@end
