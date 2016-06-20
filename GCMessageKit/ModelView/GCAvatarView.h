//
//  GCAvatarView.h
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/6.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYControl.h"
#import "GCMessageKitMacro.h"

@protocol GCAvatarViewDelegate <NSObject>

- (void)avatarImageViewTapped;

@end

@interface GCAvatarView : UIView
{
    YYControl *avatarImageView;
}

@property (assign,nonatomic) id <GCAvatarViewDelegate> avatarDelegate;


/**
 *  加载头像
 *
 *  @param avatarUrl 头像URL
 */
- (void)loadAvatarWithUrl:(NSString *)avatarUrl withBubbleType:(GCBubbleMessageType)bubbleType;

@end
