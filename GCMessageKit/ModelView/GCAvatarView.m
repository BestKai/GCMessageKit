//
//  GCAvatarView.m
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/6.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "GCAvatarView.h"
#import "GCPhotoMessageHelper.h"

@implementation GCAvatarView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.width == 0 && frame.size.height == 0) {
        
        frame.size.width = GCAvatarViewWidth;
        frame.size.height = GCAvatarViewWidth;
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        avatarImageView = [[YYControl alloc] initWithFrame:CGRectMake(12, 0, 40, 40)];
        avatarImageView.exclusiveTouch = YES;

        __block typeof(self) weakSelf = self;
        avatarImageView.touchBlock = ^(YYControl *view, UIGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            
            if (![weakSelf.avatarDelegate respondsToSelector:@selector(avatarImageViewTapped)]) return;
            
            if (state == UIGestureRecognizerStateEnded) {
                UITouch *touch = touches.anyObject;
                CGPoint p = [touch locationInView:view];
                if (CGRectContainsPoint(view.bounds, p)) {
                    [weakSelf.avatarDelegate avatarImageViewTapped];
                }
            }
        };
        
        [self addSubview:avatarImageView];
    }
    
    return self;
}

- (void)loadAvatarWithUrl:(NSString *)avatarUrl withBubbleType:(GCBubbleMessageType)bubbleType
{
    [avatarImageView.layer yy_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholder:[UIImage imageNamed:@"headerPlaceHolder"] options:0 manager:[GCPhotoMessageHelper avatarImageManager] progress:nil transform:nil completion:nil];
    if (bubbleType == GCBubbleMessageTypeSending) {
        avatarImageView.left = 4;
    }else
    {
        avatarImageView.left = 12;
    }
}


@end
