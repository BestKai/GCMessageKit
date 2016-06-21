//
//  GCOtherMessageInputView.m
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/15.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "GCOtherMessageInputView.h"
#import "GCMessageKitMacro.h"
#import "GCEmotionMangerView.h"
#import "GCOtherMenuItem.h"

@interface GCOtherMessageInputView ()<GCEmotionMangerViewDelegate>{
    GCEmotionMangerView *emotionView;
}

@property (nonatomic, strong) UIView *moreView;

@end

@implementation GCOtherMessageInputView

- (UIView *)moreView
{
    if (!_moreView) {
        _moreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        [self addSubview:_moreView];
    }
    return _moreView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createViewFrame:frame];
    }
    return self;
}

- (void)createViewFrame:(CGRect)frame {

    if (!emotionView) {
        emotionView = [[GCEmotionMangerView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, CGRectGetHeight(frame))];
        emotionView.delegate = self;
        [self addSubview:emotionView];
    }
}
- (void)sendIsShowEmotion:(BOOL)isShow {

    if (isShow) {
        emotionView.hidden = NO;
        self.moreView.hidden = YES;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            emotionView.frame = CGRectMake(0, 0, self.width, 216);
            self.moreView.frame = CGRectMake(0, 216, self.width, 216);
            
        } completion:^(BOOL finished) {
        }];
    }else {
        self.moreView.hidden = NO;
        emotionView.hidden = YES;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            emotionView.frame = CGRectMake(0, 216, self.width, 216);
            self.moreView.frame = CGRectMake(0, 0, self.width, 216);
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)setIsShowEmotionView:(BOOL)isShowEmotionView {
    
    _isShowEmotionView = isShowEmotionView;
    
    [self sendIsShowEmotion:_isShowEmotionView];
}

- (void)didSelectedEmotion:(GCEmotion *)gcEmotion{

    if (_delegate && [_delegate respondsToSelector:@selector(sendSelectedEmotion:)]) {
        [_delegate sendSelectedEmotion:gcEmotion];
    }
}

- (void)didSendtext:(NSString *)text {
    
    if (_delegate && [_delegate respondsToSelector:@selector(sendButtonTypeText:)]) {
        [_delegate sendButtonTypeText:text];
    }
}

- (UIView *)viewSetWithImage:(UIImage *)image withTitle:(NSString *)title withFrame:(CGRect)viewFrame {
    
    UIView *cellView = [[UIView alloc] initWithFrame:viewFrame];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewFrame.size.width, viewFrame.size.width)];
    imgView.image = image;
    [cellView addSubview:imgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, viewFrame.size.width + 6, viewFrame.size.width, 15)];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    [cellView addSubview:titleLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAtion:)];
    cellView.userInteractionEnabled = YES;
    [cellView addGestureRecognizer:tap];
    return cellView;
}

- (void)tapAtion:(UITapGestureRecognizer *)tap {
    
    switch ([tap view].tag) {
            //点击照片
        case 0:{
            if (_delegate && [_delegate respondsToSelector:@selector(clickToOpenAlbumView)]) {
                [_delegate clickToOpenAlbumView];
            }
        }
            break;
            //拍摄
        case 1:{
            if (_delegate && [_delegate respondsToSelector:@selector(clickPhotographView)]) {
            [_delegate clickPhotographView];
             }
        }
            break;
            //地图
        case 2:{
            if (_delegate && [_delegate respondsToSelector:@selector(clickGetAddressView)]) {
            [_delegate clickGetAddressView];
        }
        }
            break;
        case 3://名片
        {
            if (_delegate && [_delegate respondsToSelector:@selector(clickOpenBusinessCardView)]) {
                [_delegate clickOpenBusinessCardView];
            }
        }
            break;
        default:
            break;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview) {
        [self reloadSubViews];
    }
}

- (void)reloadSubViews
{
    if (!_otherMenuItems.count) {
        return;
    }
    for (UIView *subView in self.moreView.subviews) {
        [subView removeFromSuperview];
    }
    
    for (int i = 0; i< _otherMenuItems.count; i++) {
        
        GCOtherMenuItem *item = _otherMenuItems[i];
        
        UIView *phView = [self viewSetWithImage:item.normalIconImage withTitle:item.title withFrame:CGRectMake((screenWidth-GCOtherMenuItemWidth*4)/(4+1)*(i+1) + GCOtherMenuItemWidth*i, 20, GCOtherMenuItemWidth, GCOtherMenuItemHeight)];
        phView.tag = i;
        [self.moreView addSubview:phView];
    }
}


@end
