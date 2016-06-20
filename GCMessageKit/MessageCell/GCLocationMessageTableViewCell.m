//
//  GCLocationMessageTableViewCell.m
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/6.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "GCLocationMessageTableViewCell.h"

@implementation GCLocationMessageTableViewCell

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
    locationLabel = [[UILabel alloc] init];
    locationLabel.textColor = [UIColor whiteColor];
    locationLabel.font = [UIFont systemFontOfSize:12.0];
    locationLabel.numberOfLines = 3;
    [self.contentView addSubview:locationLabel];
    
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizerHandle:)];
    
    [self.bubbleImageView addGestureRecognizer:tapgesture];
    
}

- (void)setMessage:(GCMessage *)message
{
    [super setMessage:message];
    
    
    self.bubbleImageView.frame = message.bubbleFrame;
    self.bubbleImageView.image = message.bubbleImage;
    
    locationLabel.text = message.geolocations;
    locationLabel.frame = message.locationFrame;
    
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
