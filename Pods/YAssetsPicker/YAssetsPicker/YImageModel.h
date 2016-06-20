//
//  YImageModel.h
//  purchasingManager
//
//  Created by BestKai on 16/6/6.
//  Copyright © 2016年 郑州悉知. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YImageModel : NSObject

@property (assign,nonatomic) BOOL selected;

@property (strong,nonatomic) UIImage *thumbImage;

@property (strong,nonatomic) UIImage *originImage;

@property (strong,nonatomic) id assets;

@property (assign,nonatomic) NSInteger index;

@end
