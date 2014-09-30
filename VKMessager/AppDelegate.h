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
#import "NKDialogList.h"

#define MY_APP_ID @"4562378"

@interface AppDelegate : UIResponder <UIApplicationDelegate, VKSdkDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *dialogs;
@property (strong, nonatomic) NSMutableDictionary *users;
@property (strong, nonatomic) NKDialogList *dialogView;
@property (strong, nonatomic) UIImage *selfAvatar;

+ (AppDelegate *)shareDelegate;

@end

