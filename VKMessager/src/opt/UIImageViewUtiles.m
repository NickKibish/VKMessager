//
//  UIImageView.m
//  VKMessager
//
//  Created by Nick Kibish on 30.09.14.
//  Copyright (c) 2014 Nick Kibish. All rights reserved.
//

#import "UIImageViewUtiles.h"

@implementation UIImageView (Utils)

- (void)makeRound
{
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.clipsToBounds = YES;
}

@end
