//
//  GCPhotoMessageTableViewCell.m
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/6.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "GCPhotoMessageTableViewCell.h"


@implementation GCPhotoMessageTableViewCell


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
    _photoImageView = [[YYControl alloc] init];
    _photoImageView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
    _photoImageView.exclusiveTouch = YES;
    WEAKSELF
    _photoImageView.touchBlock = ^(YYControl *view, UIGestureRecognizerState state, NSSet *touches, UIEvent *event)
    {
        if (state == UIGestureRecognizerStateEnded) {
            
            if ([weakSelf.messageDelegate respondsToSelector:@selector(didSelectedOnCell:)]) {
                [weakSelf.messageDelegate didSelectedOnCell:weakSelf];
            }
        }
    };
    
    [self.contentView addSubview:_photoImageView];
    
    
    
    
    videoImageView = [[UIImageView alloc] init];
    
    videoImageView.image = [UIImage imageNamed:@"MessageVideoPlay"];
    
    [self.contentView addSubview:videoImageView];
    
    
    boarderLayer=[CAShapeLayer layer];
    boarderLayer.fillColor  = [UIColor clearColor].CGColor;
    boarderLayer.strokeColor    = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1].CGColor;
    boarderLayer.lineWidth      = 1;
    [_photoImageView.layer addSublayer:boarderLayer];
    
    
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizerHandle:)];
    
    [videoImageView addGestureRecognizer:tapgesture];
    
    
    durationLabel = [[UILabel alloc] init];
    durationLabel.textColor = [UIColor lightGrayColor];
    durationLabel.font = [UIFont systemFontOfSize:13.0f];
    durationLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:durationLabel];

}

- (void)setMessage:(GCMessage *)message
{
    [super setMessage:message];
    
    
    [_photoImageView.layer removeAnimationForKey:@"contents"];

    _photoImageView.frame = message.bubbleFrame;
    
    // 兼容老版本 ，没有图片宽高
    if (message.photoSize.width == 0 || message.photoSize.height == 0) {
        _photoImageView.contentMode = UIViewContentModeScaleToFill;
    }else
    {
        _photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    

    if (message.messageType == GCMessageTypeVideo) {
        
        videoImageView.frame = message.videoCoverFrame;
        videoImageView.hidden = !message.videoCoverPhoto;
        _photoImageView.image = message.videoCoverPhoto?message.videoCoverPhoto:message.bubbleImage;
        
        durationLabel.hidden = NO;
        durationLabel.text = message.videoDuration;
        durationLabel.frame = message.durationFrame;
        
    }else
    {
        videoImageView.frame = CGRectZero;
        videoImageView.hidden = YES;
        durationLabel.hidden = YES;

        if (message.photo) {
            _photoImageView.image = message.photo;
        }else
        {
            if ([message.thumbnailUrl containsString:@"http:"]) {
                [_photoImageView.layer yy_setImageWithURL:[NSURL URLWithString:message.thumbnailUrl] placeholder:[UIImage imageNamed:@"goodsPlaceholder"] options:kNilOptions manager:[GCPhotoMessageHelper photoMessageImageManager:message.bubbleMessageType] progress:nil transform:nil completion:nil];
            }else
            {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSData* data = [[NSData alloc] initWithContentsOfFile:message.thumbnailUrl options:NSDataReadingMapped error:nil];
                    
                    UIImage *image = [[UIImage alloc] initWithData:data];
                    
                    message.photo = image;

                    dispatch_async(dispatch_get_main_queue(), ^{
                        _photoImageView.image = message.photo;
                    });
                });
            }
        }
        
        CGSize photoSize = message.bubbleFrame.size;
        
        CGFloat w = photoSize.width;
        CGFloat h = photoSize.height;
        
        CGFloat radius = 8;
        CGFloat angleWidth = 6;
        
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        bezierPath.lineWidth = 1;
        bezierPath.lineCapStyle = kCGLineCapRound;
        bezierPath.lineJoinStyle = kCGLineJoinRound;
        
        if (message.bubbleMessageType == GCBubbleMessageTypeSending) {
            
            [bezierPath moveToPoint:CGPointMake(w-angleWidth,h-radius)];
            [bezierPath addArcWithCenter:CGPointMake(w-radius-angleWidth, h-radius) radius:radius startAngle:0 endAngle:M_PI/2 clockwise:YES];
            [bezierPath addArcWithCenter:CGPointMake(radius, h-radius) radius:radius startAngle:M_PI/2 endAngle:M_PI clockwise:YES];
            [bezierPath addArcWithCenter:CGPointMake(radius,radius) radius:radius startAngle:M_PI endAngle:3*M_PI/2 clockwise:YES];
            [bezierPath addArcWithCenter:CGPointMake(w-radius-angleWidth, radius) radius:radius startAngle:3*M_PI/2 endAngle:2*M_PI clockwise:YES];
            [bezierPath addLineToPoint:CGPointMake(w-angleWidth,40/2-angleWidth)];
            [bezierPath addLineToPoint:CGPointMake(w, 40/2)];
            [bezierPath addLineToPoint:CGPointMake(w-angleWidth, 40/2+angleWidth)];
            
        }else
        {
            [bezierPath moveToPoint:CGPointMake(w,h-radius)];
            [bezierPath addArcWithCenter:CGPointMake(w-radius, h-radius) radius:radius startAngle:0 endAngle:M_PI/2 clockwise:YES];
            [bezierPath addArcWithCenter:CGPointMake(radius+angleWidth, h-radius) radius:radius startAngle:M_PI/2 endAngle:M_PI clockwise:YES];
            [bezierPath addLineToPoint:CGPointMake(angleWidth, 40/2+angleWidth)];
            [bezierPath addLineToPoint:CGPointMake(0, 40/2)];
            [bezierPath addLineToPoint:CGPointMake(angleWidth,40/2-angleWidth)];
            [bezierPath addArcWithCenter:CGPointMake(radius+angleWidth,radius) radius:radius startAngle:M_PI endAngle:3*M_PI/2 clockwise:YES];
            [bezierPath addArcWithCenter:CGPointMake(w-radius, radius) radius:radius startAngle:3*M_PI/2 endAngle:2*M_PI clockwise:YES];
        }
        
        [bezierPath closePath];

        CAShapeLayer *shapLayer = [CAShapeLayer layer];
        shapLayer.path = bezierPath.CGPath;
        
        boarderLayer.path = bezierPath.CGPath;
        boarderLayer.frame=_photoImageView.bounds;
        
        _photoImageView.layer.mask = shapLayer;
    }
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
