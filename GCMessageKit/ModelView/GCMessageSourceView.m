//
//  GCMessageSourceView.m
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/21.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "GCMessageSourceView.h"

@implementation GCMessageSourceView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        alertImageView = [[YYControl alloc] initWithFrame:CGRectMake(2, 2, 16, 16)];
        alertImageView.image = [UIImage imageNamed:@"source_alert"];
        [self addSubview:alertImageView];
        
        _sourceLabel = [[UILabel alloc] init];
        _sourceLabel.textColor = [UIColor colorWithRed:82/255.0f green:103/255.0f blue:146/255.0f alpha:1];
        _sourceLabel.font = [UIFont systemFontOfSize:13.0];
        [self addSubview:_sourceLabel];
        
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}



@end
