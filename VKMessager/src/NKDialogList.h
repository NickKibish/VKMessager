//
//  NKDialogList.h
//  VKMessager
//
//  Created by Nick Kibish on 28.09.14.
//  Copyright (c) 2014 Nick Kibish. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NKUser;
@interface NKDialogList : UITableViewController <UITabBarDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *dialogs;
@property (strong, nonatomic) NSMutableDictionary *users;

@end

@interface NKUser : NSObject

@property (strong, nonatomic) UIImage *avatar;
@property (strong, nonatomic) NSString *fullName;

@end