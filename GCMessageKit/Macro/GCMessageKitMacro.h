//
//  GCMessageKitMacro.h
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/6.
//  Copyright © 2016年 XZ. All rights reserved.
//

#ifndef GCMessageKitMacro_h
#define GCMessageKitMacro_h

#import <YYText/YYText.h>
#import <YYWebImage/YYWebImage.h>
#import "UIView+GCAdd.h"

//#define screenWidth  [UIScreen mainScreen].bounds.size.width
//#define screenHeight [UIScreen mainScreen].bounds.size.height


#define GCMessageFontSize  16  //文字大小
#define GCAvatarViewWidth  56 // 头像视图宽度
#define GCTextMarginTop    12.0f // 文本上间隙
#define GCTextMarginBottom 12.0f // 文本下间隙
#define GCTextMarginLeft   8.0f //文本左间距
#define GCTextMarginRight  12.0f
#define GCMaxTextWidth     [UIScreen mainScreen].bounds.size.width - 115 // 文本最大宽度
#define GCBubbleMarginBottom 19 //气泡与cell底部距离
#define GCBubbleMarginTop    2  // 气泡与Cell顶部距离

#define GCInputViewHeight    50// 输入框高度


#define GCBubbleAngleWidth   6 //三角宽度
#define GCMessageStatusViewWidth  20

#pragma mark ----- color

#define GCMessageTimeColor   [UIColor whiteColor]

#define kVoiceRecorderTotalTime 60.0

#define COLOR_LINE_GRAY   [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1]


// block self
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;


#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define screenWidth ([[UIScreen mainScreen] bounds].size.width)
#define screenHeight ([[UIScreen mainScreen] bounds].size.height)




/**
 气泡类型
 */
typedef enum : NSUInteger {
    GCBubbleMessageTypeSending   = 0,//发送
    GCBubbleMessageTypeReceiving = 1,//接收
    
} GCBubbleMessageType;

/**
 消息发送状态
 */
typedef enum : NSUInteger {
    GCMessageStatusSending = 0,
    GCMessageStatusSent    = 1,
    GCMessageStatusFailed  = 2,
} GCMessageStatus;

/**
 消息类型
 */
typedef enum : NSUInteger {
    GCMessageTypeText     = 0,
    GCMessageTypePhoto    = 1,
    GCMessageTypeVideo    = 2,
    GCMessageTypeVoice    = 3,
    GCMessageTypeLocation = 4,
    GCMessageTypeNameCard = 5,
    GCMessageTypeAddFriend= 6
} GCMessageType;


typedef enum : NSUInteger {
    
    GCInputViewTypeNormal   = 0,
    GCInputViewTypeText     = 1,
    GCInputViewTypeEmotion  = 2,
    GCInputViewTypeShareMenu= 3,
    
}GCInputViewType;





#endif /* GCMessageKitMacro_h */
