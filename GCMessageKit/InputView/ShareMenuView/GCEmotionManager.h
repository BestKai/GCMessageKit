//
//  GCEmotionManager.h
//  purchasingManager
//
//  Created by BestKai on 16/4/15.
//  Copyright © 2016年 郑州悉知. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCEmotionManager : NSObject

@property (nonatomic, copy) NSString *emotionName;
/**
 *  某一类表情的数据源
 */
@property (nonatomic, strong) NSMutableArray *emotions;


@property (nonatomic, copy) NSDictionary *emotionDic;

@end
