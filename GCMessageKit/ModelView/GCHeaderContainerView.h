//
//  GCHeaderContainerView.h
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/6.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCHeaderContainerView : UIView
{
    UIActivityIndicatorView *loadMoreActivityIndicatorView;
}


/**
 *  动画开始
 */
- (void)startAnimation;

/**
 *  动画结束
 */
- (void)stopAnimation;

@end
