//
//  GCPhotoMessageTableViewCell.h
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/6.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCMessageBaseTableViewCell.h"
#import "GCPhotoMessageHelper.h"
@interface GCPhotoMessageTableViewCell : GCMessageBaseTableViewCell
{
    UIImageView *videoImageView;
    
    UILabel *durationLabel;
    
    
    CAShapeLayer *boarderLayer;
}

@property (strong,nonatomic) YYControl *photoImageView;


@end
