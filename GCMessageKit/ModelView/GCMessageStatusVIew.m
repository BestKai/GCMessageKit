//
//  GCMessageStatusVIew.m
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/12.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "GCMessageStatusVIew.h"

@implementation GCMessageStatusVIew

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;

        sendingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        sendingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;

        [self addSubview:sendingView];
        
        _sentFailedView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        
        _sentFailedView.image = [UIImage imageNamed:@"unSend"];
        
        [self addSubview:_sentFailedView];
    }
    return self;
}

- (void)messageIsSending
{
    self.hidden = NO;
    _sentFailedView.hidden = YES;
    sendingView.hidden = NO;
    [sendingView startAnimating];
}

- (void)messageIsSentFailed
{
    self.hidden = NO;
    sendingView.hidden = YES;
    [sendingView stopAnimating];
    _sentFailedView.hidden = NO;
}

- (void)messageIsSentSuccessed
{
    [sendingView stopAnimating];
    self.hidden = YES;
}

- (void)setMessageStatus:(GCMessageStatus)messageStatus
{
    _messageStatus = messageStatus;
    
    switch (messageStatus) {
        case GCMessageStatusSent:
        {
            [self messageIsSentSuccessed];
        }
            break;
        case GCMessageStatusFailed:
        {
            [self messageIsSentFailed];
        }
            break;
        case GCMessageStatusSending:
        {
            [self messageIsSending];
        }
            break;
        default:
            break;
    }
}

@end
