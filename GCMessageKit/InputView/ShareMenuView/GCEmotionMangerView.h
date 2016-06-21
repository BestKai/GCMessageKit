//
//  GCEmotionMangerView.h
//  baymax_marketing_iOS
//
//  Created by TonySheng on 16/1/12.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GCEmotion;
@protocol GCEmotionMangerViewDelegate <NSObject>

- (void)didSelectedEmotion:(GCEmotion *)gcEmotion;
- (void)didSendtext:(NSString *)text;

@end

@interface GCEmotionMangerView : UIView

@property (nonatomic, weak) id<GCEmotionMangerViewDelegate> delegate;

@end
