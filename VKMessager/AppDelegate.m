//
//  AppDelegate.m
//  VKMessager
//
//  Created by Nick Kibish on 28.09.14.
//  Copyright (c) 2014 Nick Kibish. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

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
                                        andParameters:@{@"count":@30}
                                        andHttpMethod:@"GET"];
    [request executeWithResultBlock:^(VKResponse *response) {
        
    } errorBlock:^(NSError *error) {
        
    }];
}

#pragma mark - Application delegate
- (BOOL)            application:(UIApplication *)application
  didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
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
    UIViewController *mainController = [self.window.rootViewController.navigationController.viewControllers firstObject];
    [mainController presentViewController:controller animated:YES completion:^{}];
}

- (void)vkSdkReceivedNewToken:(VKAccessToken *)newToken
{
    
}

@end
