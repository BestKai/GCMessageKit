//
//  GCMessageInputView.m
//  YYKitDemo
//
//  Created by TonySheng on 16/1/7.
//  Copyright © 2016年 ibireme. All rights reserved.
//

#import "GCMessageInputView.h"
#import "YYControl.h"
#import "GCEmotionMangerView.h"
#import "GCMessageInputViewHelper.h"
#import "WBVoiceRecordHUD.h"
#import <AVFoundation/AVFoundation.h>
#import "GCMessageKitMacro.h"
#import "GCVoiceRecordHelper.h"
#import "GCMessageBubbleHelper.h"

#define kToolbarHeight (50)
#define GCButtonWidth  28
#define GCButtonHorizontalSpace  8

@interface GCMessageInputView () <YYTextViewDelegate, YYTextKeyboardObserver,AVAudioRecorderDelegate>{
    
}

/**
 *  管理录音工具对象
 */
@property (nonatomic, strong) GCVoiceRecordHelper *voiceRecordHelper;

/**
 *  判断是不是超出了录音最大时长
 */
@property (nonatomic) BOOL isMaxTimeStop;


///录音的时候 显示录音时候的界面
@property (nonatomic, strong) WBVoiceRecordHUD *voiceRecordHUD;


/**
 *  是否正在錄音
 */
@property (nonatomic, assign, readwrite) BOOL isRecording;

/**
 *  是否取消錄音
 */
@property (nonatomic, assign, readwrite) BOOL isCancelled;


@end

@implementation GCMessageInputView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setUpUI{
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.layer.borderWidth = .5;
    self.layer.borderColor = COLOR_LINE_GRAY.CGColor;
    
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
        _toolbarOthersButton = nil;
        _toolbarEmoticonButton = nil;
        _toolbarVoiceButton = nil;
        _holdDownButton = nil;
        _textView = nil;
    }
    
    CGFloat buttonOrignX = GCButtonHorizontalSpace;
    
    if (self.allowsSendVoice) {
        
        if (!_toolbarVoiceButton) {
            _toolbarVoiceButton = [self _toolbarButtonWithImage:@"voice"highlight:@"voice_HL"];
            _toolbarVoiceButton.left = buttonOrignX;
            _toolbarVoiceButton.top = 11;
            _toolbarVoiceButton.tag = 101;
            [_toolbarVoiceButton setImage:[UIImage imageNamed:@"keyborad"] forState:UIControlStateSelected];
            buttonOrignX = CGRectGetMaxX(_toolbarVoiceButton.frame)+GCButtonHorizontalSpace;
        }
        
        if (!_holdDownButton) {
            
            UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);

            UIButton *holdDownButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonOrignX, 7, self.size.width - 3 * GCButtonWidth - 5 * GCButtonHorizontalSpace, 36)];
            
            
            [holdDownButton setBackgroundImage:[[UIImage imageNamed:@"VoiceBtn_Black"] resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
            
            [holdDownButton setBackgroundImage:[[UIImage imageNamed:@"VoiceBtn_BlackHL"] resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch] forState:UIControlStateHighlighted];
            
            [holdDownButton setTitle:@"按住说话" forState:UIControlStateNormal];
            [holdDownButton setTitle:@"放开发送" forState:UIControlStateHighlighted];
            
            
            holdDownButton.backgroundColor = [UIColor whiteColor];
            holdDownButton.layer.cornerRadius = 4;
            holdDownButton.layer.borderWidth = .5;
            holdDownButton.layer.borderColor = COLOR_LINE_GRAY.CGColor;
            
            [holdDownButton setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
            
            
            [holdDownButton addTarget:self action:@selector(holdDownButtonTouchDown) forControlEvents:UIControlEventTouchDown];
            [holdDownButton addTarget:self action:@selector(holdDownButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
            [holdDownButton addTarget:self action:@selector(holdDownButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
            [holdDownButton addTarget:self action:@selector(holdDownDragOutside) forControlEvents:UIControlEventTouchDragExit];
            [holdDownButton addTarget:self action:@selector(holdDownDragInside) forControlEvents:UIControlEventTouchDragEnter];
            
            [self addSubview:holdDownButton];
            _holdDownButton = holdDownButton;
            _holdDownButton.hidden = YES;
        }
    }

    if (!_textView) {
        _textView = [YYTextView new];
        
        CGFloat textWidth = self.allowsSendMultiMedia?(self.size.width - buttonOrignX - 2 * 28 - 3 * GCButtonHorizontalSpace):(self.size.width - buttonOrignX - 28 - 2 * GCButtonHorizontalSpace);
        
        _textView.frame = CGRectMake(buttonOrignX, 7, textWidth, 36);
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8);
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.delegate = self;
        _textView.inputAccessoryView = [UIView new];
        _textView.enablesReturnKeyAutomatically = YES;
        _textView.returnKeyType =  UIReturnKeySend;
        _textView.layer.borderWidth = .5;
        _textView.layer.borderColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1].CGColor;
        _textView.layer.cornerRadius = 5;
        _textView.textVerticalAlignment = YYTextVerticalAlignmentTop;
        
        _textView.textParser = [GCMessageInputViewHelper getEmoticonParserFromExpressionPackage];
        
        
        GCTextLinePositionModifier *modifier = [GCTextLinePositionModifier new];
        modifier.font = [UIFont systemFontOfSize:17];
        modifier.paddingTop = 8;
        modifier.paddingBottom = 8;
        _textView.linePositionModifier = modifier;
        [self addSubview:_textView];
        
        buttonOrignX = CGRectGetMaxX(_textView.frame)+GCButtonHorizontalSpace;
    }


    if (!_toolbarEmoticonButton) {
        _toolbarEmoticonButton = [self _toolbarButtonWithImage:@"face"highlight:@"face_HL"];
        _toolbarEmoticonButton.tag = 102;
        [_toolbarEmoticonButton setImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
        [_toolbarEmoticonButton setImage:[UIImage imageNamed:@"keyborad"] forState:UIControlStateSelected];
        _toolbarEmoticonButton.top = 11;
        _toolbarEmoticonButton.left = buttonOrignX;
        buttonOrignX = CGRectGetMaxX(_toolbarEmoticonButton.frame)+ GCButtonHorizontalSpace;
    }
    
    
    if (self.allowsSendMultiMedia) {
        if (!_toolbarOthersButton) {
            _toolbarOthersButton = [self _toolbarButtonWithImage:@"multiMedia"highlight:@"multiMedia_HL"];
            _toolbarOthersButton.tag = 103;
            _toolbarOthersButton.top = 11;
            _toolbarOthersButton.left = buttonOrignX;
        }
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview) {
        [self setUpUI];
    }
}

- (GCVoiceRecordHelper *)voiceRecordHelper {
    if (!_voiceRecordHelper) {
        _isMaxTimeStop = NO;
        
        WEAKSELF
        _voiceRecordHelper = [[GCVoiceRecordHelper alloc] init];
        _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
            NSLog(@"已经达到最大限制时间了，进入下一步的提示");
            
            // Unselect and unhilight the hold down button, and set isMaxTimeStop to YES.
            weakSelf.holdDownButton.selected = NO;
            weakSelf.holdDownButton.highlighted = NO;
            weakSelf.isMaxTimeStop = YES;
            
            [weakSelf finishRecorded];
        };
        _voiceRecordHelper.peakPowerForChannel = ^(float peakPowerForChannel) {
            weakSelf.voiceRecordHUD.peakPower = peakPowerForChannel;
        };
        _voiceRecordHelper.maxRecordTime = kVoiceRecorderTotalTime;
    }
    return _voiceRecordHelper;
}

- (WBVoiceRecordHUD *)voiceRecordHUD {
    if (!_voiceRecordHUD) {
        _voiceRecordHUD = [[WBVoiceRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
    }
    return _voiceRecordHUD;
}

- (UIButton *)_toolbarButtonWithImage:(NSString *)imageName highlight:(NSString *)highlightImageName {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    button.size = CGSizeMake(GCButtonWidth, GCButtonWidth);
    [button setImage:[YYImage imageNamed:imageName] forState:UIControlStateNormal];
    if (highlightImageName) {
        [button setImage:[YYImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    }
    
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button addTarget:self action:@selector(_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    return button;
}

#pragma mark ----
#pragma mark ---- 导航条上面的点击事件
- (void)_buttonClicked:(UIButton *)button {
    
    switch (button.tag) {
            //文本语音按钮点击事件
        case 101:{
            
            button.selected = !button.selected;
            
            _toolbarEmoticonButton.selected = NO;
            _toolbarOthersButton.selected = NO;
            _textView.text = nil;
            
            if (_toolbarVoiceButton.selected) {
                [self.textView resignFirstResponder];
            } else {
                [self.textView becomeFirstResponder];
            }
            //        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //        } completion:^(BOOL finished) {
            //        }];
            [_textView reloadInputViews];
            
            _holdDownButton.hidden = !_toolbarVoiceButton.selected;
            _textView.hidden = _toolbarVoiceButton.selected;
            
            if ([self.delegate respondsToSelector:@selector(didChangeSendVoiceAction:)]) {
                [self.delegate didChangeSendVoiceAction:button.selected];
            }
        }
            break;
            ///表情按钮
        case 102:{
            
            self.holdDownButton.hidden = YES;
            button.selected = !button.selected;
            
            self.toolbarVoiceButton.selected = NO;
            self.toolbarOthersButton.selected = NO;
            
            self.textView.hidden = NO;
            [_textView reloadInputViews];
            
            if (_delegate && [_delegate respondsToSelector:@selector(faceButtonisShowFace:)]) {
                [_delegate faceButtonisShowFace:button.selected];
            }
        }
            break;
            ///+号按钮
        case 103:{
            
            self.toolbarOthersButton.selected = !self.toolbarOthersButton.selected;
            if (self.toolbarOthersButton.selected) {
                ///显示更多
                [_textView resignFirstResponder];
                self.holdDownButton.hidden = YES;
                self.textView.hidden = NO;
                self.toolbarEmoticonButton.selected = NO;
                
                if (_delegate && [_delegate respondsToSelector:@selector(moreButtonIsShowMore:)]) {
                    [_delegate moreButtonIsShowMore:YES];
                }
                [_textView reloadInputViews];
                
            }else {
                
                //显示键盘
                if (_delegate && [_delegate respondsToSelector:@selector(moreButtonIsShowMore:)]) {
                    [_delegate moreButtonIsShowMore:NO];
                }
                [_textView reloadInputViews];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark ----
#pragma mark ---- GCEmotionMangerViewDelegate

- (void)sendGcEmotion:(GCEmotion *)emotion {
    
    if ([emotion.emotionName isEqualToString:@"delete"]) {
        
        if (_textView.text.length != 0) {
            [self.textView deleteBackward];
        }else {
            _textView.text = nil;
        }
    }else {
        
        YYTextPosition *start = (YYTextPosition *)_textView.selectedTextRange.start;
        
        if (!_textView.text) {
            _textView.text = emotion.emotionName;
        }else {
            
            //            NSTextAttachment *emojiTextAttachment = [NSTextAttachment new];
            //            emojiTextAttachment.image = gcEmotion.emotionPhoto;
            //            emojiTextAttachment.bounds = CGRectMake(0,0, 18, 18);
            //
            //             NSAttributedString *attributedString = [NSAttributedString attributedStringWithAttachment:emojiTextAttachment];
            //            NSMutableAttributedString *mAttributeString = [[NSMutableAttributedString alloc] initWithAttributedString:_textView.attributedText];
            //            _textView.attributedText = attributedString;
            static  NSMutableString *muString;
            if ( _textView.text && _textView.text.length != 0) {
                muString = [[NSMutableString alloc] initWithString:_textView.text?_textView.text:@""];
                [muString insertString:emotion.emotionName atIndex:_textView.text.length];
            }else {
                muString = [[NSMutableString alloc] initWithString:emotion.emotionName];
            }
            _textView.text = [NSString stringWithString:muString];
            
        }
        if (start.offset != 0 && start.offset) {
            _textView.selectedRange = NSMakeRange(start.offset + emotion.emotionName.length, 0);
        }else {
            
            _textView.selectedRange = NSMakeRange(_textView.text.length, 1);
        }
    }
    
    
}

- (void)sendButtonText:(NSString *)text {
    
    if (_textView.text && _textView.text.length != 0) {
        [self textView:_textView shouldChangeTextInRange:NSMakeRange(_textView.text.length, 0) replacementText:@"\n"];
    }
}

#pragma mark ----- YYTextViewDelegate
- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)]) {
        [self.delegate inputTextViewWillBeginEditing:textView];
    }
    
    _toolbarVoiceButton.selected = NO;
    _toolbarEmoticonButton.selected = NO;
    _toolbarOthersButton.selected = NO;
    
    return YES;
}


#pragma mark @protocol YYTextKeyboardObserver

- (void)textViewDidChange:(YYTextView *)textView {
    [UIView animateWithDuration:0.25f animations:^{
        
        if (self.textView.contentSize.height >= 36 && self.textView.size.height != self.textView.contentSize.height) {
            
            if (self.textView.contentSize.height<102) {
                self.textView.size = self.textView.contentSize;
            }else
            {
                self.textView.size = CGSizeMake( _textView.contentSize.width, 102);
            }
            
            if (_delegate && [_delegate respondsToSelector:@selector(refreshInputviewSize:)]) {
                [_delegate refreshInputviewSize:self.textView.size];
            }
            
        }else if (self.textView.contentSize.height < 36){
            if (_delegate && [_delegate respondsToSelector:@selector(refreshInputviewSize:)]) {
                [_delegate refreshInputviewSize:CGSizeMake(_textView.contentSize.width,36)];
            }
            self.textView.frame = CGRectMake(CGRectGetMinX(self.textView.frame),7, _textView.contentSize.width,36);
        }
        
        _toolbarVoiceButton.top = self.height - 11 - _toolbarVoiceButton.frame.size.height;
        
        _toolbarEmoticonButton.top = self.height - 11 - _toolbarEmoticonButton.frame.size.height;
        
        _toolbarOthersButton.top = self.height - 11 - _toolbarOthersButton.frame.size.height;
    }];
}

///录制语音按钮

- (void)holdDownButtonTouchDown {
    
    self.isCancelled = NO;
    self.isRecording = NO;
    
    WEAKSELF
    [self.voiceRecordHelper prepareRecordingWithPath:[self getRecorderPath] prepareRecorderCompletion:^BOOL{
        
        if (!weakSelf.isCancelled) {
            weakSelf.isRecording = YES;
            [weakSelf.voiceRecordHUD startRecordingHUDAtView:weakSelf.superview];

            [weakSelf.voiceRecordHelper startRecordingWithStartRecorderCompletion:^{
            }];
            return YES;
        }else
        {
            return NO;
        }
    }];
}

- (void)holdDownButtonTouchUpOutside {
    
    //如果已經開始錄音了, 才需要做取消的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    
    if (self.isRecording) {
        
//        self.holdDownButton.selected = NO;
//        [self.holdDownButton setBackgroundColor:[UIColor whiteColor]];
        WEAKSELF
        [self.voiceRecordHUD cancelRecordCompled:^(BOOL fnished) {
            weakSelf.voiceRecordHUD = nil;
        }];
        
        [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
            
        }];
    }else {
        self.isCancelled = YES;
    }
}

- (void)holdDownButtonTouchUpInside {
    
    //如果已經開始錄音了, 才需要做結束的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    if (self.isRecording) {
        
        if (self.isMaxTimeStop == NO) {
            WEAKSELF
            [self.voiceRecordHUD stopRecordCompled:^(BOOL fnished) {
                weakSelf.voiceRecordHUD = nil;
            }];
            
            [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
                
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(sentVoicePath:WithRecordDuration:)]) {
                    
                    NSLog(@"发送语音消息成功");
                    [weakSelf.delegate sentVoicePath:weakSelf.voiceRecordHelper.recordPath WithRecordDuration:weakSelf.voiceRecordHelper.recordDuration];
                }
            }];
        }else
        {
            self.isMaxTimeStop = NO;
        }
//        self.holdDownButton.selected = NO;
//        [self.holdDownButton setBackgroundColor:[UIColor whiteColor]];
    }else
    {
        self.isCancelled = YES;
    }
}
- (void)holdDownDragOutside {
    
    //如果已經開始錄音了, 才需要做拖曳出去的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    if (self.isRecording) {
        [self.voiceRecordHUD resaueRecord];
//        self.holdDownButton.backgroundColor = [UIColor whiteColor];
    }else {
        self.isCancelled = YES;
    }
}

- (void)holdDownDragInside {
    
    //如果已經開始錄音了, 才需要做拖曳回來的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    if (self.isRecording) {
        [self.voiceRecordHUD pauseRecord];
    }else {
        self.isCancelled = YES;
    }
    
}
- (NSString *)getRecorderPath {
    NSString *recorderPath = nil;
    recorderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    recorderPath = [recorderPath stringByAppendingFormat:@"%@-MySound.m4a", [dateFormatter stringFromDate:now]];
    return recorderPath;
}

- (void)finishRecorded
{
    WEAKSELF
    [self.voiceRecordHUD stopRecordCompled:^(BOOL fnished) {
        weakSelf.voiceRecordHUD = nil;
    }];
    
    [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(sentVoicePath:WithRecordDuration:)]) {
            
            NSLog(@"发送语音消息成功");
            [weakSelf.delegate sentVoicePath:weakSelf.voiceRecordHelper.recordPath WithRecordDuration:weakSelf.voiceRecordHelper.recordDuration];
        }
    }];
}


#pragma mark @protocol WBStatusComposeEmoticonView
- (void)emoticonInputDidTapText:(NSString *)text {
    if (text.length) {
        [_textView replaceRange:_textView.selectedTextRange withText:text];
    }
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if (textView.attributedText.length == 0) {
            return NO;
        }else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSendTextAction:)]) {
                [_delegate didSendTextAction:textView.text];
            }
            return NO;
        }
    }
    
    return YES;
}

- (void)resignFirstRes
{
    [self.textView resignFirstResponder];
}

- (void)becomFirstRes
{
    [self.textView becomeFirstResponder];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
