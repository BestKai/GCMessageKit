//
//  GCVoiceMessageTableViewCell.m
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/6.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "GCVoiceMessageTableViewCell.h"

@implementation GCVoiceMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initUI];
    }
    
    return self;
}

- (void)initUI
{
    durationLabel = [[UILabel alloc] init];
    durationLabel.textColor = [UIColor lightGrayColor];
    durationLabel.font = [UIFont systemFontOfSize:13.0f];
    durationLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:durationLabel];
    
    
    _unReadDotImageView = [[UIImageView alloc] init];
    _unReadDotImageView.image = [UIImage imageNamed:@"msg_chat_voice_unread"];
    [self.contentView addSubview:_unReadDotImageView];
    
    _animationVoiceImageView = [[UIImageView alloc] init];
    
    [self addSubview:_animationVoiceImageView];
    
    
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizerHandle:)];
    
    [self.bubbleImageView addGestureRecognizer:tapgesture];

}

- (void)setMessage:(GCMessage *)message
{
    [super setMessage:message];
    
    
    self.bubbleImageView.image = message.bubbleImage;
    self.bubbleImageView.frame = message.bubbleFrame;
    
    durationLabel.text = message.durationString;
    durationLabel.frame = message.durationFrame;
    
    _unReadDotImageView.hidden = message.isRead;
    _unReadDotImageView.frame = message.unReadImageFrame;
    
    _animationVoiceImageView.image = message.voiceImage;
    _animationVoiceImageView.frame = message.voiceImageFrame;
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:3];
    for (NSInteger i = 0; i < 3;i++) {
        
        UIImage *image;
        if (message.bubbleMessageType == GCBubbleMessageTypeReceiving) {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"ReceiverVoiceNodePlaying00%ld",i+1]];
        }else
        {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"SenderVoiceNodePlaying00%ld",i+1]];
        }
        if (image)
            [images addObject:image];
    }
    _animationVoiceImageView.animationImages = images;
    _animationVoiceImageView.animationDuration = 1.0;
    [_animationVoiceImageView stopAnimating];
    
}

- (void)singleTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGesture
{
    [self setNormalMenuController];

    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        
        if ([self.messageDelegate respondsToSelector:@selector(didSelectedOnCell:)]) {
            [self.messageDelegate didSelectedOnCell:self];
        }
    }
}



@end
