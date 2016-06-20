//
//  GCMessageInputViewHelper.h
//  baymax_marketing_iOS
//
//  Created by TonySheng on 16/1/12.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCMessageKitMacro.h"

@interface GCMessageInputViewHelper : NSObject


+(YYTextSimpleEmoticonParser *)getEmoticonParserFromExpressionPackage;
///返回表情的数组
+ (NSMutableArray *)getEmotionImage;
///正则  表情
+ (NSRegularExpression *)regexEmoticon;

/// 表情字典 key:/偷笑 value:ImagePath
+ (NSDictionary *)emoticonDic;

/// 从path创建图片 (有缓存)
+ (UIImage *)imageWithPath:(NSString *)path;

@end
