//
//  GCVoiceMessageTableViewCell.h
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/6.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCMessageBaseTableViewCell.h"

@interface GCVoiceMessageTableViewCell : GCMessageBaseTableViewCell
{
    UILabel *durationLabel;
}

@property (strong,nonatomic) UIImageView *unReadDotImageView;

@property (strong,nonatomic) UIImageView *animationVoiceImageView;
;

@end
