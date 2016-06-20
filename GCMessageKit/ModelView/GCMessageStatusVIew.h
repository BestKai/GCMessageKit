//
//  GCMessageStatusVIew.h
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/12.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCMessageKitMacro.h"

@interface GCMessageStatusVIew : UIView
{
    UIActivityIndicatorView *sendingView;
}

@property (strong,nonatomic) UIImageView *sentFailedView;


@property (assign,nonatomic)GCMessageStatus  messageStatus;

- (void)messageIsSending;

- (void)messageIsSentSuccessed;

- (void)messageIsSentFailed;

@end
