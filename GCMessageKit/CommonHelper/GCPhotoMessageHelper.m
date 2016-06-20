//
//  GCPhotoMessageHelper.m
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/7.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "GCPhotoMessageHelper.h"
#import "UIImage+RoundedCorner.h"

@implementation GCPhotoMessageHelper

+ (YYWebImageManager *)photoMessageImageManager:(GCBubbleMessageType)bubbleMessageType
{
    static YYWebImageManager *manager;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"bayMax_marking.imageMessage"];
        YYImageCache *cache = [[YYImageCache alloc] initWithPath:path];
        manager = [[YYWebImageManager alloc] initWithCache:cache queue:[YYWebImageManager sharedManager].queue];
        manager.sharedTransformBlock = ^(UIImage *image, NSURL *url) {
            
            if (!image) return image;
            
            return image;
        };
    });
    return manager;
}

+ (UIImage *)cropImageWithImage:(UIImage *)originImage WithbubbelType:(GCBubbleMessageType)bubbleMessageType
{
    CGFloat scale = 0;
    if (originImage.size.height>originImage.size.width) {
        
        scale = originImage.size.height/200;
    }else
    {
        scale = originImage.size.width/200;
    }
    
    
    CGFloat radius = 7*scale;
    
    CGFloat angleHeight = 12*scale;//三角形高
    
    CGFloat topMargin = 7.5*scale;
    
    UIGraphicsBeginImageContext(originImage.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    float x1 = 0.;
    float y1 = 0.;
    float x2 = x1+originImage.size.width;
    float y2 = y1;
    float x3 = x2;
    float y3 = y1+originImage.size.height;
    float x4 = x1;
    float y4 = y3;
    
    CGFloat angleWidth = (GCBubbleAngleWidth)*scale;
    
    if (bubbleMessageType == GCBubbleMessageTypeReceiving) {
        CGContextMoveToPoint(gc, x1+angleWidth, y1+radius);
        CGContextAddArcToPoint(gc, x1+angleWidth, y1, x1 + angleWidth+radius, y1, radius);
        CGContextAddArcToPoint(gc, x2, y2, x2, y2+radius, radius);
        CGContextAddArcToPoint(gc, x3, y3, x3-radius, y3, radius);
        CGContextAddArcToPoint(gc, x4+angleWidth, y4, x4+angleWidth, y4-radius, radius);
        CGContextAddLineToPoint(gc, x1+angleWidth, y1+radius+topMargin+angleHeight);
        CGContextAddLineToPoint(gc, x1, y1+radius+topMargin+angleHeight/2.0);
        CGContextAddLineToPoint(gc, x1+angleWidth, y1+radius+topMargin);
    }else
    {
        CGContextMoveToPoint(gc, x1, y1+radius);
        CGContextAddArcToPoint(gc, x1, y1, x1+radius, y1, radius);
        CGContextAddArcToPoint(gc, x2-angleWidth, y2, x2-angleWidth, y2+radius, radius);
        CGContextAddLineToPoint(gc, x2-angleWidth, y1+radius+topMargin);
        CGContextAddLineToPoint(gc, x2, y1+radius+topMargin+angleHeight/2.0);
        CGContextAddLineToPoint(gc, x2-angleWidth, y1+radius+topMargin+angleHeight);
        CGContextAddArcToPoint(gc, x3-angleWidth, y3, x3-radius-angleWidth, y3, radius);
        CGContextAddArcToPoint(gc, x4, y4, x4, y4-radius, radius);
    }
    
    CGContextClosePath(gc);
    CGContextClip(gc);
    
    CGContextTranslateCTM(gc, 0, originImage.size.height);
    CGContextScaleCTM(gc, 1, -1);
    CGContextDrawImage(gc, CGRectMake(0, 0, originImage.size.width, originImage.size.height), originImage.CGImage);
    
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimage;
}

+ (UIImage *) compressOriginImage:(UIImage *)originImage withLength:(CGFloat)maxLength
{
    CGSize imageSize = originImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    if(width <= maxLength && height <= maxLength){
        return originImage;//不需要压缩
    }
    
    if(width == 0 || height == 0){
        return originImage;
    }
    
    UIImage *newImage = nil;
    CGFloat widthFactor = maxLength / width;
    CGFloat heightFactor = maxLength / height;
    CGFloat compressFactor = 0.0;
    
    if(widthFactor > heightFactor){
        compressFactor = heightFactor;//compress to fit height
    }else{
        compressFactor = widthFactor;//compress to fit width
    }
    
    CGFloat compressedWidth = width * compressFactor;
    CGFloat compressedHeight = height * compressFactor;
    CGSize targetSize = CGSizeMake(compressedWidth,compressedHeight);
    
    UIGraphicsBeginImageContext(targetSize);//this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.size.width = compressedWidth;
    thumbnailRect.size.height = compressedHeight;
    
    [originImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();//pop the context to get back to the default
    
    if(newImage != nil){
        return newImage;
    }else{
        return originImage;
    }
}


+ (YYWebImageManager *)avatarImageManager
{
    static YYWebImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"DaiBai.avatar"];
        YYImageCache *cache = [[YYImageCache alloc] initWithPath:path];
        manager = [[YYWebImageManager alloc] initWithCache:cache queue:[YYWebImageManager sharedManager].queue];
        manager.sharedTransformBlock = ^(UIImage *image, NSURL *url) {
            if (!image) return image;
            
            CGFloat minSize = MIN(image.size.width, image.size.height);
            UIImage *roundImage = [image roundedCornerImageWithCornerRadius:minSize/2];
            return roundImage;
        };
    });
    return manager;
}


@end
