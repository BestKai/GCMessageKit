//
//  GCMessageInputView.h
//  YYKitDemo
//
//  Created by TonySheng on 16/1/7.
//  Copyright © 2016年 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCEmotion.h"
#import <YYText/YYText.h>


@protocol GCMessageInputViewDelegate <NSObject>

/**
*  输入框将要开始编辑
*
*  @param messageInputTextView 输入框对象
*/
- (void)inputTextViewWillBeginEditing:(YYTextView *)messageInputTextView;

/**
 *  在发送文本和语音之间发送改变时，会触发这个回调函数
 *
 *  @param changed 是否改为发送语音状态
 */
- (void)didChangeSendVoiceAction:(BOOL)changed;


@optional

/**
 *  发送文本消息，包括系统的表情
 *
 *  @param text 目标文本消息
 */
- (void)didSendTextAction:(NSString *)text;

///语音消息
- (void)sentVoicePath:(NSString *)voicePath WithRecordDuration:(NSString *)recordDuration;

- (void)sentInputViewFrameWithSize:(CGSize)newSize;
///实时更新frame
- (void)refreshInputviewSize:(CGSize)newSize;

///表情button 点击是否显示EmotionMangerView
- (void)faceButtonisShowFace:(BOOL)isShowFace;
///更多  点击是否先是MoreView
- (void)moreButtonIsShowMore:(BOOL)isShowMore;

@end

@interface GCMessageInputView : UIView

@property (nonatomic, weak) id<GCMessageInputViewDelegate> delegate;
///输入框
@property (nonatomic, strong) YYTextView *textView;

/**
 *  是否允许发送语音
 */
@property (nonatomic, assign) BOOL allowsSendVoice; // default is YES


/**
 *  是否允许发送多媒体
 */
@property (nonatomic, assign) BOOL allowsSendMultiMedia; // default is YES






///显示录音按按钮的按钮
@property (nonatomic, strong) UIButton *toolbarVoiceButton;
///录音按钮
@property (nonatomic, weak, readonly) UIButton *holdDownButton;
///表情按钮
@property (nonatomic, strong) UIButton *toolbarEmoticonButton;
///  +按钮
@property (nonatomic, strong) UIButton *toolbarOthersButton;


- (void)setUpUI;

/// 传入点击表情
- (void)sendGcEmotion:(GCEmotion *)emotion;

//判断Button的类型
- (void)sendButtonText:(NSString *)text;

- (void)resignFirstRes;

- (void)becomFirstRes;

@end
