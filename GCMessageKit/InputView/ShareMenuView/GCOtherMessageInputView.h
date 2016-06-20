//
//  GCOtherMessageInputView.h
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/15.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCEmotionMangerView.h"
#import "GCOtherMenuItem.h"

@protocol GCOtherMessageInputViewDelegate <NSObject>

@optional
//表情
- (void)sendSelectedEmotion:(GCEmotion *)emotion;

//判断按钮是发送还是别的  方便以后迭代升级
- (void)sendButtonTypeText:(NSString *)text;

// 相册
- (void)clickToOpenAlbumView;
// 相机
- (void)clickPhotographView;
// 地图
- (void)clickGetAddressView;
//名片
- (void)clickOpenBusinessCardView;

@end

@interface GCOtherMessageInputView : UIView

@property (nonatomic, weak) id<GCOtherMessageInputViewDelegate> delegate;

@property (copy  ,nonatomic)  NSArray *otherMenuItems;

@property (nonatomic, assign) BOOL isShowEmotionView;


- (void)reloadSubViews;

@end
