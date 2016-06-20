//
//  GCEmotion.h
//  baymax_marketing_iOS
//
//  Created by TonySheng on 16/1/12.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCEmotion : NSObject
/**
 *  表情图片
 */
@property (nonatomic, strong) UIImage *emotionPhoto;

/**
 *  表情的名字
 */
@property (nonatomic, copy) NSString *emotionName;
@end
