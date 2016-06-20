//
//  GCTextMessageTableViewCell.m
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/5.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "GCTextMessageTableViewCell.h"

@implementation GCTextMessageTableViewCell


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
    displayLabel = [[YYLabel alloc] init];
    
    displayLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    
    displayLabel.userInteractionEnabled = NO;
    
    displayLabel.ignoreCommonProperties = YES;
    
    displayLabel.fadeOnAsynchronouslyDisplay = NO;
    
    [self.contentView addSubview:displayLabel];
    
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureRecognizerHandle:)];
    
    tapgesture.numberOfTapsRequired = 2;
    
    [self.bubbleImageView addGestureRecognizer:tapgesture];
}

- (void)setMessage:(GCMessage *)message
{
    [super setMessage:message];
    
    
    self.bubbleImageView.image = message.bubbleImage;
    
    self.bubbleImageView.frame = message.bubbleFrame;
    
    displayLabel.textLayout = message.textLayout;
    
    displayLabel.frame = message.textLabelFrame;
    
}

- (void)doubleTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGesture
{
    [self setNormalMenuController];

    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        if ([self.messageDelegate respondsToSelector:@selector(didSelectedOnCell:)]) {
            [self.messageDelegate didSelectedOnCell:self];
        }
    }
}

- (void)customCopy:(id)sender
{
    [super customCopy:sender];
    
    [[UIPasteboard generalPasteboard] setString:displayLabel.textLayout.text.string];
    [self resignFirstResponder];
}

@end
