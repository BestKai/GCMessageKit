//
//  GCMessageBaseTableViewCell.h
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/7.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCAvatarView.h"
#import "YYControl.h"
#import "GCMessage.h"
#import "GCMessageStatusVIew.h"
#import "GCMessageSourceView.h"
@class GCMessageBaseTableViewCell;
@protocol GCMessageTableCellDelegate <NSObject>

@optional
- (void)didSelectedOnCell:(GCMessageBaseTableViewCell *)cell;

- (void)avatarImageViewTapped:(GCBubbleMessageType)buubleMessageType;

- (void)tappedAtGoodsInfoWithMessage:(GCMessage *)message;

- (void)deleteCurrentMessage:(GCMessageBaseTableViewCell *)cell;

- (void)resendCurrentMessage:(GCMessageBaseTableViewCell *)cell;

@end


@interface GCMessageBaseTableViewCell : UITableViewCell<GCAvatarViewDelegate>

@property (strong,nonatomic) UILabel *timeLabel;

@property (strong,nonatomic) GCAvatarView *avatarView;

@property (strong,nonatomic) UIImageView *bubbleImageView;

@property (strong,nonatomic) GCMessageStatusVIew *messageStatusView;

@property (strong,nonatomic) GCMessageSourceView *sourceView;

@property (strong,nonatomic) GCMessage *message;

@property (assign,nonatomic) id<GCMessageTableCellDelegate> messageDelegate;

- (void)setNormalMenuController;
- (void)customCopy:(id)sender;
@end
