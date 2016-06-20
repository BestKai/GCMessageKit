//
//  GCEmotionCollectionViewCell.m
//  baymax_marketing_iOS
//
//  Created by TonySheng on 16/1/12.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "GCEmotionCollectionViewCell.h"

@interface GCEmotionCollectionViewCell()

@property (nonatomic, weak) UIImageView *emotionImageView;

@end

@implementation GCEmotionCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}
- (void)setup {
    if (!_emotionImageView) {
        UIImageView *emotionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 40 , 40                                          )];
        emotionImageView.backgroundColor = [UIColor redColor];
//        colorWithRed:0.000 green:0.251 blue:0.502 alpha:1.000
        
        emotionImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:emotionImageView];
        self.emotionImageView = emotionImageView;
    }

}

- (void)setGcEmotion:(GCEmotion *)gcEmotion {

    _gcEmotion = gcEmotion;
    
    
    if ([_gcEmotion.emotionName isEqualToString:@"delete"]) {
        self.emotionImageView.frame = CGRectMake(10, 7.5, 25, 18);
    }else {
        self.emotionImageView.frame = CGRectMake(10, 0, 30, 30);
    }

    self.emotionImageView.image = gcEmotion.emotionPhoto;
}


@end
