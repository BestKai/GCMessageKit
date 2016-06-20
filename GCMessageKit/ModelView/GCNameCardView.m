//
//  GCBusinessCardView.m
//  purchasingManager
//
//  Created by cloud on 15/6/27.
//  Copyright (c) 2015年 郑州悉知. All rights reserved.
//

#import "GCNameCardView.h"
#import "GCMessageKitMacro.h"
@implementation GCNameCardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.layer.masksToBounds = YES;
        
        self.layer.cornerRadius = 5.0f;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 150, 15)];
        _titleLabel.text = @"名片";
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        [self addSubview:_titleLabel];
        
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(12, 31, frame.size.width-30, .5)];
        _line.backgroundColor = COLOR_LINE_GRAY;
        
        [self addSubview:_line];
        
        
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 40, 48, 48)];
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.image = [UIImage imageNamed:@"headerPlaceHolder"];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImageView.layer.cornerRadius = 4.0f;
        [self addSubview:_headerImageView];
        
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageView.frame)+8, CGRectGetMinY(_headerImageView.frame), 100, 20)];
        _userNameLabel.text =@"凯瑞";
        _userNameLabel.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:_userNameLabel];
        
        
        _telLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userNameLabel.frame.origin.x, CGRectGetMaxY(_userNameLabel.frame)+8, 100, 15)];
        _telLabel.font = [UIFont systemFontOfSize:14];
        _telLabel.textColor = [UIColor colorWithRed:100/255.0 green:124/255.0 blue:163/255.0 alpha:1];
        _telLabel.text = @"130383834832";
        [self addSubview:_telLabel];
//        _sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(121, 55, 12, 12)];
//        _sexImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sexMan@2x" ofType:@"png"]];
//        [self addSubview:_sexImageView];
        
        
//        UILabel *checkLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-68, 68, 53, 20)];
//        checkLabel.text = @"点击查看";
//        checkLabel.textColor = COLOR_NAVAIGATIONBAR;
//        checkLabel.font = [UIFont systemFontOfSize:13.0f];
//        [self addSubview:checkLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleLabel.frame = CGRectMake(10, 10, self.frame.size.width-20,15);
    
    _line.frame = CGRectMake(8, CGRectGetMaxY(_titleLabel.frame)+8, self.frame.size.width-16, .5);
    
    _headerImageView.frame = CGRectMake(10, CGRectGetMaxY(_line.frame)+8, 48, 48);
    
    _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_headerImageView.frame)+8, CGRectGetMinY(_headerImageView.frame), self.frame.size.width - CGRectGetMaxX(_headerImageView.frame)-16, 17);
    
    _telLabel.frame = CGRectMake(_userNameLabel.frame.origin.x, CGRectGetMaxY(_userNameLabel.frame)+8, _userNameLabel.frame.size.width, 15);
}

@end
