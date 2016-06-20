//
//  GCMessageInputViewHelper.m
//  baymax_marketing_iOS
//
//  Created by TonySheng on 16/1/12.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "GCMessageInputViewHelper.h"
#import "GCEmotion.h"

@implementation GCMessageInputViewHelper


+ (NSRegularExpression *)regexEmoticon {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[[^ \\[\\]]+?\\]" options:kNilOptions error:NULL];
    });
    return regex;
}
+ (NSMutableArray *)getEmotionImage {
    
    static  NSMutableArray *emotions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        emotions = [NSMutableArray array];
        
        NSMutableArray *imgMAry = [NSMutableArray arrayWithArray:[GCMessageInputViewHelper emotionTSAry]];
        
        for (NSDictionary *dic in imgMAry) {
            GCEmotion *emotion = [[GCEmotion alloc] init];
            
            NSString *imageName = [NSString stringWithFormat:@"%@@2x",[[dic allValues] firstObject]];
            
            NSString *emoticonBundlePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
            
            emotion.emotionName = [dic allKeys][0];
            
            emotion.emotionPhoto = [GCMessageInputViewHelper imageWithPath:emoticonBundlePath];
            
            [emotions addObject:emotion];
            
        }
        
    });
    return  emotions;
    
}


+(YYTextSimpleEmoticonParser *)getEmoticonParserFromExpressionPackage{
    
    static  YYTextSimpleEmoticonParser *parser = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableDictionary *emDic = [[NSMutableDictionary alloc] init];
        
        NSMutableArray *imgMAry = [NSMutableArray arrayWithArray:[GCMessageInputViewHelper emotionTSAry]];
        
        for (int i = 0; i < imgMAry.count; i ++)
        {
            NSDictionary *dicTS = imgMAry[i];
            NSString *mapperKey = [dicTS allKeys][0];
            UIImage *emImage =  [[GCMessageInputViewHelper alloc] imageWithName:[NSString stringWithFormat:@"%@@2x",[dicTS allValues][0]]];
            
            
            emDic[mapperKey] = emImage;
        }
        parser = [YYTextSimpleEmoticonParser new];
        parser.emoticonMapper = emDic;
        
    });
    
    return parser;
    
}

+ (NSDictionary *)emoticonDic {
    static NSMutableDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = [NSMutableDictionary new];
        
        NSArray *imgMary = [self emotionTSAry];
        for (int i = 0; i<imgMary.count; i++) {
            
            NSDictionary *aa = imgMary[i];
            
            NSString *imageName = [NSString stringWithFormat:@"%@@2x",[aa.allValues firstObject]];
            NSString *emoticonBundlePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
            
            NSDictionary *bb = [NSDictionary dictionaryWithObject:emoticonBundlePath forKey:[aa.allKeys firstObject]];
            
            [dic addEntriesFromDictionary:bb];
        }
    });
    return dic;
}



- (UIImage *)imageWithName:(NSString *)name {
    //    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:name ofType:@"png"]];
    NSString *emoticonBundlePath = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
    //    NSString *path = [bundle pathForScaledResource:name ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:emoticonBundlePath];
    YYImage *image = [YYImage imageWithData:data scale:2];
    image.preloadAllAnimatedImageFrames = YES;
    return image;
}

+ (NSArray *) emotionTSAry {
    
    static NSArray *emAry = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ExpressionPackage" ofType:@"plist"];
        emAry = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    });
    return emAry;
}

+ (UIImage *)imageWithPath:(NSString *)path {
    if (!path) return nil;
    UIImage *image = [[self imageCache] objectForKey:path];
    if (image) return image;
//    if (path.pathScale == 1) {
//        // 查找 @2x @3x 的图片
//        NSArray *scales = [NSBundle preferredScales];
//        for (NSNumber *scale in scales) {
//            
//            image = [UIImage imageWithContentsOfFile:[path stringByAppendingPathScale:scale.floatValue]];
//            if (image) break;
//        }
//    } else {
        image = [UIImage imageWithContentsOfFile:path];
//    }
//    if (image) {
//        image = [image imageByDecoded];
//        [[self imageCache] setObject:image forKey:path];
//    }
    return image;
}

+ (YYMemoryCache *)imageCache {
    static YYMemoryCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [YYMemoryCache new];
        cache.shouldRemoveAllObjectsOnMemoryWarning = NO;
        cache.shouldRemoveAllObjectsWhenEnteringBackground = NO;
        cache.name = @"GCEmotionImageCache";
    });
    return cache;
}



@end
