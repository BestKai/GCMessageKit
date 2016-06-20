//
//  GCHeaderContainerView.m
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/6.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "GCHeaderContainerView.h"


@implementation GCHeaderContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        loadMoreActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        loadMoreActivityIndicatorView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.0,  10);
        
        [self addSubview:loadMoreActivityIndicatorView];
        
    }
    return self;
}


- (void)startAnimation
{
    [loadMoreActivityIndicatorView startAnimating];
}

-(void)stopAnimation
{
    [loadMoreActivityIndicatorView stopAnimating];
}


@end
