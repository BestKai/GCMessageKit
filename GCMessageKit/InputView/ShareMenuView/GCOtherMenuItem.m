//
//  GCOtherMenuItem.m
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/3/6.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "GCOtherMenuItem.h"

@implementation GCOtherMenuItem


- (instancetype)initWithNormalIconImage:(UIImage *)normalIconImage title:(NSString *)title
{
    self = [super init];
    
    if (self) {
        self.normalIconImage = normalIconImage;
        self.title = title;
    }
    return self;
}

- (void)dealloc
{
    self.normalIconImage = nil;
    self.title = nil;
}

@end
