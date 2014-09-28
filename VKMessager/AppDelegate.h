//
//  AppDelegate.h
//  VKMessager
//
//  Created by Nick Kibish on 28.09.14.
//  Copyright (c) 2014 Nick Kibish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <VKSdk.h>

#define MY_APP_ID @"4562378"

@interface AppDelegate : UIResponder <UIApplicationDelegate, VKSdkDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)shareDelegate;

@end

