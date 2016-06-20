//
//  GCEmotionManager.m
//  purchasingManager
//
//  Created by BestKai on 16/4/15.
//  Copyright © 2016年 郑州悉知. All rights reserved.
//

#import "GCEmotionManager.h"

@implementation GCEmotionManager

- (void)dealloc {
    [self.emotions removeAllObjects];
    self.emotions = nil;
}

@end
