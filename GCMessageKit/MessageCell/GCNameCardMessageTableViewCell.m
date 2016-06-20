//
//  GCNameCardMessageTableViewCell.m
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/6.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "GCNameCardMessageTableViewCell.h"

@implementation GCNameCardMessageTableViewCell

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
    nameCardView = [[GCNameCardView alloc] init];
    
    [self addSubview:nameCardView];
    
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizerHandle:)];
    
    [nameCardView addGestureRecognizer:tapgesture];
}

- (void)setMessage:(GCMessage *)message
{
    [super setMessage:message];
    
    self.bubbleImageView.frame = message.bubbleFrame;
    self.bubbleImageView.image = message.bubbleImage;
    nameCardView.frame = message.nameCardFrame;
    
    
    [nameCardView.headerImageView yy_setImageWithURL:[NSURL URLWithString:message.userHeadImagUrl] placeholder:[UIImage imageNamed:@"headerPlaceHolder"]];
    nameCardView.userNameLabel.text = message.userTureName;
    nameCardView.telLabel.text = message.userMobile;
    nameCardView.titleLabel.text = message.isAddFriend?message.bubbleMessageType == GCBubbleMessageTypeSending?@"添加对方为好友":@"对方添加你为好友":@"名片";
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
