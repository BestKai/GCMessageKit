//
//  GCEmotionMangerView.m
//  baymax_marketing_iOS
//
//  Created by TonySheng on 16/1/12.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "GCEmotionMangerView.h"
#import "GCEmotionCollectionViewCell.h"
#import "GCMessageInputViewHelper.h"



#define GCEmotionPageControlHeight 38
#define GCEmotionSectionBarHeight 36
#define GCEmotionCollectionViewCellIdentifier @"GCEmotionCollectionViewCellIdentifier"

@interface GCEmotionMangerView ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>{
    
    NSMutableArray *emotionMAry;
}
/**
 *  显示表情的collectView控件
 */
@property (nonatomic, weak) UICollectionView *emotionCollectionView;
@property (nonatomic, weak) UIScrollView *scrollView;
/**
 *  显示页码的控件
 */
@property (nonatomic, weak) UIPageControl *emotionPageControl;



@end

@implementation GCEmotionMangerView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundView:frame];
    }
    return self;
}
- (void)setBackgroundView:(CGRect )frame {
    
    emotionMAry = [GCMessageInputViewHelper getEmotionImage];
    self.backgroundColor = [UIColor whiteColor];
    if (!_scrollView) {
        //scrollView 上面添加了一个CollectionView
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - GCEmotionPageControlHeight - GCEmotionSectionBarHeight) ];
        scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * 2, CGRectGetHeight(self.bounds) - GCEmotionPageControlHeight - GCEmotionSectionBarHeight);
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.pagingEnabled = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
    }
    
    if (!_emotionCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        [layout setItemSize:CGSizeMake([UIScreen mainScreen].bounds.size.width/6 - 12, (CGRectGetHeight(self.bounds) - GCEmotionPageControlHeight - GCEmotionSectionBarHeight)/3.-10)];
        //        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.sectionInset = UIEdgeInsetsMake(6,10,6, 6);
        
        UICollectionView *emotionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds) * 2, CGRectGetHeight(self.bounds) - GCEmotionPageControlHeight - GCEmotionSectionBarHeight) collectionViewLayout:layout];
        emotionCollectionView.backgroundColor = self.backgroundColor;
        
        emotionCollectionView.contentSize =  CGSizeMake([UIScreen mainScreen].bounds.size.width/7 - 5,emotionCollectionView.bounds.size.height/ 3 - 5);
        [emotionCollectionView registerClass:[GCEmotionCollectionViewCell class] forCellWithReuseIdentifier:GCEmotionCollectionViewCellIdentifier];
        emotionCollectionView.showsHorizontalScrollIndicator = NO;
        emotionCollectionView.showsVerticalScrollIndicator = NO;
        [emotionCollectionView setScrollsToTop:NO];
        emotionCollectionView.pagingEnabled = NO;
        emotionCollectionView.scrollEnabled = NO;
        emotionCollectionView.delegate = self;
        emotionCollectionView.dataSource = self;
        
        [self.scrollView addSubview:emotionCollectionView];
        self.emotionCollectionView = emotionCollectionView;
    }
    if (!_emotionPageControl) {
        UIPageControl *emotionPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame),self.width, GCEmotionPageControlHeight)];
        emotionPageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.471 alpha:1.000];
        emotionPageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.678 alpha:1.000];
        emotionPageControl.backgroundColor = self.backgroundColor;
        emotionPageControl.hidesForSinglePage = YES;
        emotionPageControl.defersCurrentPageDisplay = YES;
        emotionPageControl.numberOfPages = 2;
        [self addSubview:emotionPageControl];
        self.emotionPageControl = emotionPageControl;
    }
    
    static UIView *lineView = nil;
    if (!lineView) {
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_emotionPageControl.frame), self.width,.5)];
        lineView.backgroundColor = COLOR_LINE_GRAY;
        [self addSubview:lineView];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(screenWidth - 60 , CGRectGetMaxY(_emotionPageControl.frame)+ .5, 60,GCEmotionSectionBarHeight -.5);
    button.backgroundColor = [UIColor colorWithRed:0/255.0 green:120/255.0 blue:255/255.0 alpha:1];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
}

- (void)deleteButtonClick:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(didSendtext:)]) {
        [_delegate didSendtext:@"send"];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    //根据当前的坐标与页宽计算当前页码
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    [self.emotionPageControl setCurrentPage:currentPage];
}

#pragma UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return emotionMAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GCEmotionCollectionViewCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GCEmotionCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.gcEmotion = emotionMAry[indexPath.row];
    return cell;
}

#pragma mark - UICollectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(didSelectedEmotion:)]) {
        [self.delegate didSelectedEmotion:emotionMAry[indexPath.row]];
    }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
