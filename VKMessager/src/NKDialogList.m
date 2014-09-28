//
//  NKDialogList.m
//  VKMessager
//
//  Created by Nick Kibish on 28.09.14.
//  Copyright (c) 2014 Nick Kibish. All rights reserved.
//

#import "NKDialogList.h"

@interface NKDialogList ()

@end

@implementation NKDialogList

- (void)update
{
//   NKDialogList - (void)update
    [self.tableView reloadData];
}

#pragma mark - Load View

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    return cell;
}

@end
