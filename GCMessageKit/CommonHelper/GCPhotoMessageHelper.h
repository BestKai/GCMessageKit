//
//  GCPhotoMessageHelper.h
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/7.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCMessageKitMacro.h"

@interface GCPhotoMessageHelper : NSObject

+ (YYWebImageManager *)photoMessageImageManager:(GCBubbleMessageType)bubbleMessageType;

+ (UIImage *)cropImageWithImage:(UIImage *)originImage WithbubbelType:(GCBubbleMessageType)bubbleMessageType;



+ (UIImage *)compressOriginImage:(UIImage *)originImage withLength:(CGFloat)maxLength;


+ (YYWebImageManager *)avatarImageManager;

@end
