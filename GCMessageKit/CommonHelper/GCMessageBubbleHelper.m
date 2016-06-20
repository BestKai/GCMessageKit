//
//  GCMessageBubbleHelper.m
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/6.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "GCMessageBubbleHelper.h"

@implementation GCMessageBubbleHelper

+ (UIImage *)bubbleImageViewWithType:(GCBubbleMessageType)bubbleType messageType:(GCMessageType)messageType isAnonymous:(BOOL)anonymous
{
    NSString *messageTypeString = @"weChatBubble";

    switch (messageType) {
        case GCMessageTypePhoto:
        case GCMessageTypeVideo:
        case GCMessageTypeText:
        case GCMessageTypeVoice:
        {
            switch (bubbleType) {
                case GCBubbleMessageTypeSending:
                {
                    // 发送
                    if (anonymous) {
                        messageTypeString = [messageTypeString stringByAppendingString:@"_Sending_Anonymous"];
                    }else
                    {
                        messageTypeString = [messageTypeString stringByAppendingString:@"_Sending"];
                    }
                }
                    break;
                case GCBubbleMessageTypeReceiving:
                    // 接收
                    messageTypeString = [messageTypeString stringByAppendingString:@"_Receiving"];
                    break;
                default:
                    break;
            }
            
            messageTypeString = [messageTypeString stringByAppendingString:@"_Solid"];
        }
            break;
        case GCMessageTypeNameCard:
        {
            switch (bubbleType) {
                case GCBubbleMessageTypeSending:
                {
                    messageTypeString = [messageTypeString stringByAppendingString:@"_Sending"];
                }
                    break;
                case GCBubbleMessageTypeReceiving:
                {
                    messageTypeString = [messageTypeString stringByAppendingString:@"_Receiving"];
                }
                    break;
                default:
                    break;
            }
            messageTypeString = [messageTypeString stringByAppendingString:@"_MingPian"];
        }
            break;
        default:
            break;
    }
    
    UIImage *bubbleImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[[NSString alloc] initWithFormat:@"%@@2x",messageTypeString] ofType:@"png"]];
    
    UIEdgeInsets bubbleImageEdgeInsets = [self bubbleImageEdgeInserts];
    
    UIImage *edgeBubbleImage = [bubbleImage resizableImageWithCapInsets:bubbleImageEdgeInsets resizingMode:UIImageResizingModeStretch];
    
    return edgeBubbleImage;
}

+ (UIEdgeInsets)bubbleImageEdgeInserts
{
    return UIEdgeInsetsMake(30, 28, 85, 28);
}

@end



@implementation GCTextLinePositionModifier

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
            
            _lineHeightMultiple = 1.34;
            
        }else
        {
            _lineHeightMultiple = 1.3125;
        }
    }
    
    return self;
}

- (void)modifyLines:(NSArray *)lines fromText:(NSAttributedString *)text inContainer:(YYTextContainer *)container {
    //CGFloat ascent = _font.ascender;
    CGFloat ascent = _font.pointSize * 0.86;
    
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    for (YYTextLine *line in lines) {
        CGPoint position = line.position;
        position.y = _paddingTop + ascent + line.row  * lineHeight;
        line.position = position;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    GCTextLinePositionModifier *one = [self.class new];
    one->_font = _font;
    one->_paddingTop = _paddingTop;
    one->_paddingBottom = _paddingBottom;
    one->_lineHeightMultiple = _lineHeightMultiple;
    return one;
}

- (CGFloat)heightForLineCount:(NSUInteger)lineCount {
    if (lineCount == 0) return 0;
    //    CGFloat ascent = _font.ascender;
    //    CGFloat descent = -_font.descender;
    CGFloat ascent = _font.pointSize * 0.86;
    CGFloat descent = _font.pointSize * 0.14;
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    return _paddingTop + _paddingBottom + ascent + descent + (lineCount - 1) * lineHeight;
}

@end
