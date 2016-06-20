//
//  GCNameCardView.h
//  purchasingManager
//
//  Created by cloud on 15/6/27.
//  Copyright (c) 2015年 郑州悉知. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCNameCardView : UIView

@property (strong, nonatomic) UIImageView *headerImageView;

@property (strong, nonatomic) UILabel *userNameLabel;

@property (strong,nonatomic) UILabel *telLabel;

@property (strong, nonatomic) UIImageView *sexImageView;

@property (strong,nonatomic) UIView *line;

@property (strong,nonatomic) UILabel *titleLabel;

- (instancetype)initWithFrame:(CGRect)frame;


@end
