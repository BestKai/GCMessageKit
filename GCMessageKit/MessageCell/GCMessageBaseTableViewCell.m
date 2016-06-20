//
//  GCMessageBaseTableViewCell.m
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/7.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "GCMessageBaseTableViewCell.h"

@implementation GCMessageBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initPublicUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeState:) name:@"chatDataChange" object:nil];
    }
    return self;
}

-(void)changeState:(NSNotification* )noti{
    
    if ([noti.object[1] isEqualToString:_message.msgID] || [noti.object[2] isEqualToString:_message.msgID]) {
        switch ([noti.object[0] intValue]) {
            case GCMessageStatusSent:{
                [_messageStatusView messageIsSentSuccessed];
            }
                break;
            case GCMessageStatusSending:{
                [_messageStatusView messageIsSending];
            }
                break;
            case GCMessageStatusFailed:{
                [_messageStatusView messageIsSentFailed];

            }
                break;
            default:
                break;
        }
    }
}



- (void)initPublicUI
{
    self.avatarView = [[GCAvatarView alloc] init];
    self.avatarView.avatarDelegate = self;
    [self.contentView addSubview:self.avatarView];

    
    self.timeLabel = [[UILabel alloc] init];
//    self.timeLabel.backgroundColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0];
    self.timeLabel.font = [UIFont systemFontOfSize:13.0];
    self.timeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
//    self.timeLabel.layer.cornerRadius = 4.0f;
//    self.timeLabel.layer.masksToBounds = YES;
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.timeLabel];
    
    
    self.bubbleImageView = [[UIImageView alloc] init];
    self.bubbleImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.bubbleImageView];
    
    
    self.messageStatusView = [[GCMessageStatusVIew alloc] init];
    self.messageStatusView.sentFailedView.userInteractionEnabled = YES;
    [self.messageStatusView.sentFailedView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resendMessage)]];
    [self.contentView addSubview:self.messageStatusView];
    
    _sourceView = [[GCMessageSourceView alloc] init];
    _sourceView.userInteractionEnabled = YES;
    [self.contentView addSubview:_sourceView];
    
    
    [self.sourceView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerHandle:)]];
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizerHandle:)];
    [recognizer setMinimumPressDuration:.4f];
    [self.contentView addGestureRecognizer:recognizer];
}

- (void)setMessage:(GCMessage *)message
{
    _message = message;
    self.avatarView.frame = message.avatarFrame;
    self.timeLabel.text = message.timeString;
    self.timeLabel.frame = message.timeFrame;
    
    [self.messageStatusView setFrame:message.statusFrame];
    [self.messageStatusView setMessageStatus:message.messageStatus];

    self.sourceView.frame = message.sourceFrame;
    self.sourceView.sourceLabel.text = message.sourceString;
    self.sourceView.sourceLabel.frame = CGRectMake(24, 0, message.sourceFrame.size.width-34, message.sourceFrame.size.height);
}


- (void)resendMessage
{
    if (self.messageDelegate && [self.messageDelegate respondsToSelector:@selector(resendCurrentMessage:)]) {
        [self.messageDelegate resendCurrentMessage:self];
    }
}

#pragma mark ----- GCAvatarViewDelegate
- (void)avatarImageViewTapped
{
    if ([self.messageDelegate respondsToSelector:@selector(avatarImageViewTapped:)]) {
        
        [self.messageDelegate avatarImageViewTapped:self.message.bubbleMessageType];
    }
}

- (void)tapGestureRecognizerHandle:(UITapGestureRecognizer *)tapgesture
{
    if (self.messageDelegate) {
        [self.messageDelegate tappedAtGoodsInfoWithMessage:self.message];
    }
}


- (void)longPressGestureRecognizerHandle:(UILongPressGestureRecognizer *)longPressGestureRecognizer
{
    if (longPressGestureRecognizer.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder]) {
        return;
    }
    
    NSArray *popMenuTitles;
    if (self.message.messageType ==  GCMessageTypeText) {
        popMenuTitles = @[@"删除",@"复制"];
    }else{
        popMenuTitles = @[@"删除"];
    }
    
    NSMutableArray *menuItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < popMenuTitles.count; i ++) {
        NSString *title = popMenuTitles[i];
        SEL action = nil;
        switch (i) {
            case 0: {
                action = @selector(customDelete:);
                break;
            }
            case 1: {
                action = @selector(customCopy:);
                break;
            }
            default:
                break;
        }
        if (action) {
            UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:title action:action];
            if (item) {
                [menuItems addObject:item];
            }
        }
    }
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:menuItems];
    CGRect targetRect = self.message.bubbleFrame;
    [menu setTargetRect:CGRectInset(targetRect, 0.0f, 4.0f) inView:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillShowNotification:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
    [menu setMenuVisible:YES animated:YES];
}

#pragma mark - Copying Method ———— 必须实现，否则不显示
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(customDelete:) || action == @selector(customCopy:));
}

#pragma mark - Menu Actions
- (void)customDelete:(id)sender
{
    if (self.messageDelegate && [self.messageDelegate respondsToSelector:@selector(deleteCurrentMessage:)]) {
        [self.messageDelegate deleteCurrentMessage:self];
    }
}

- (void)customCopy:(id)sender
{
}

- (void)more:(id)sender
{
    NSLog(@"更多");
}

#pragma mark - Notifications

- (void)handleMenuWillHideNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
}

- (void)setNormalMenuController
{
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }
}

@end
