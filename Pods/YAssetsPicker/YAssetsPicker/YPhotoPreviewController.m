//
//  YPhotoPreviewController.h
//  YImagePickerController
//
//  Created by best_kai on 15/12/24.
//  Copyright © 2015年 best_kai. All rights reserved.
//

#import "YPhotoPreviewController.h"
#import "YImageManager.h"
#import "UIView+GCAdd.h"

@interface YPhotoPreviewCell ()<UIGestureRecognizerDelegate,UIScrollViewDelegate> {
    CGFloat _aspectRatio;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *imageContainerView;
@end

@implementation YPhotoPreviewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        [self addSubview:_scrollView];
        
        _imageContainerView = [[UIView alloc] init];
        _imageContainerView.clipsToBounds = YES;
        [_scrollView addSubview:_imageContainerView];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.clipsToBounds = YES;
        [_imageContainerView addSubview:_imageView];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        [self addGestureRecognizer:tap2];
    }
    return self;
}

- (void)setModel:(YImageModel *)model {
    _model = model;
    [_scrollView setZoomScale:1.0 animated:NO];
    [[YImageManager manager] getPhotoWithAsset:model.assets completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        self.imageView.image = photo;
        [self resizeSubviews];
    }];
}

- (void)resizeSubviews {
    _imageContainerView.origin = CGPointZero;
    _imageContainerView.width = self.width;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.height / self.width) {
        _imageContainerView.height = floor(image.size.height / (image.size.width / self.width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.width;
        if (height < 1 || isnan(height)) height = self.height;
        height = floor(height);
        _imageContainerView.height = height;
        _imageContainerView.centerY = self.height / 2;
    }
    if (_imageContainerView.height > self.height && _imageContainerView.height - self.height <= 1) {
        _imageContainerView.height = self.height;
    }
    _scrollView.contentSize = CGSizeMake(self.width, MAX(_imageContainerView.height, self.height));
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.height <= self.height ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;
}

#pragma mark - UITapGestureRecognizer Event

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock();
    }
}

#pragma mark - UIScrollViewDelegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.width > scrollView.contentSize.width) ? (scrollView.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.height > scrollView.contentSize.height) ? (scrollView.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageContainerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}
@end



@interface YPhotoPreviewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate> {
    UICollectionView *_collectionView;
    BOOL _isHideNaviBar;
    
    UIView *_naviBar;
    UIButton *_backButton;
    UIButton *_selectButton;
    
    UIView *_toolBar;
    UIButton *_okButton;
    
    UILabel *indexLabel;
}

@end

@implementation YPhotoPreviewController

- (NSMutableArray *)selectedPhotoArr {
    if (_selectedPhotoArr == nil) _selectedPhotoArr = [[NSMutableArray alloc] init];
    return _selectedPhotoArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configCollectionView];
    [self configCustomNaviBar];
    [self configBottomToolBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
    if (_currentIndex) [_collectionView setContentOffset:CGPointMake((self.view.width) * _currentIndex, 0) animated:NO];
    [self refreshNaviBarAndBottomBarState];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)configCustomNaviBar {
    _naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    _naviBar.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:.7];
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 44, 44)];
    [_backButton setImage:[UIImage imageNamed:@"backImageWhite"] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    
    _selectButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth-52, 20, 30, 30)];
    [_selectButton setImage:[UIImage imageNamed:@"unSelectedPic"] forState:UIControlStateNormal];
    [_selectButton addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    
    
    indexLabel = [[UILabel alloc] init];
    indexLabel.font = [UIFont systemFontOfSize:19];
    indexLabel.frame = CGRectMake(60, 20, screenWidth-120, 44);
    indexLabel.backgroundColor = [UIColor clearColor];
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [_naviBar addSubview:indexLabel];
    
    
    [_naviBar addSubview:_selectButton];
    [_naviBar addSubview:_backButton];
    [self.view addSubview:_naviBar];
}

- (void)configBottomToolBar {
    
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 48, self.view.width, 48)];
    _toolBar.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:.7];
//    _toolBar.alpha = 0.7;
    
//    TZImagePickerController *imagePickerVc = (TZImagePickerController *)self.navigationController;
//    if (imagePickerVc.allowPickingOriginalPhoto) {
//        _originalPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _originalPhotoButton.frame = CGRectMake(5, 0, 120, 44);
//        _originalPhotoButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
//        _originalPhotoButton.contentEdgeInsets = UIEdgeInsetsMake(0, -50, 0, 0);
//        _originalPhotoButton.backgroundColor = [UIColor clearColor];
//        [_originalPhotoButton addTarget:self action:@selector(originalPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        _originalPhotoButton.titleLabel.font = [UIFont systemFontOfSize:13];
//        [_originalPhotoButton setTitle:@"原图" forState:UIControlStateNormal];
//        [_originalPhotoButton setTitle:@"原图" forState:UIControlStateSelected];
//        [_originalPhotoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        [_originalPhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//        [_originalPhotoButton setImage:[UIImage imageNamed:@"preview_original_def"] forState:UIControlStateNormal];
//        [_originalPhotoButton setImage:[UIImage imageNamed:@"photo_original_sel"] forState:UIControlStateSelected];
//        
//        _originalPhotoLable = [[UILabel alloc] init];
//        _originalPhotoLable.frame = CGRectMake(60, 0, 70, 44);
//        _originalPhotoLable.textAlignment = NSTextAlignmentLeft;
//        _originalPhotoLable.font = [UIFont systemFontOfSize:13];
//        _originalPhotoLable.textColor = [UIColor whiteColor];
//        _originalPhotoLable.backgroundColor = [UIColor clearColor];
//        if (_isSelectOriginalPhoto) [self showPhotoBytes];
//    }
    
    _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _okButton.frame = CGRectMake(self.view.width - 110, 8, 90, _toolBar.frame.size.height-16);
    _okButton.titleLabel.font = [UIFont systemFontOfSize:16];
    _okButton.layer.cornerRadius = 16.0;
    _okButton.layer.masksToBounds = YES;

    [_okButton addTarget:self action:@selector(okButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_okButton setTitle:@"完成" forState:UIControlStateNormal];
    [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_okButton setBackgroundColor:[UIColor redColor]];

    
    [_toolBar addSubview:_okButton];
    [self.view addSubview:_toolBar];
}

- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.width, self.view.height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width , self.view.height) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _collectionView.contentSize = CGSizeMake(self.view.width * _photoArr.count, self.view.height);
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[YPhotoPreviewCell class] forCellWithReuseIdentifier:@"TZPhotoPreviewCell"];
}

#pragma mark - Click Event

- (void)select:(UIButton *)selectButton {
    
    YImageModel *model = _photoArr[_currentIndex];
    
    if (!_selectedPhotoArr) {
        _selectedPhotoArr = [NSMutableArray new];
    }
    
        // 1. select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
        
    if (_selectedPhotoArr.count == self.maxSelectNumber && !model.selected) {
        
        [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"你最多只能选择%zd张图片",self.maxSelectNumber] delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil] show];
        
        return;
    }
    
    
    model.selected = !model.selected;
    
    [self refreshNaviBarAndBottomBarState];
    
    if (model.selected) {
        
        [self.selectedPhotoArr addObject:model];

        [selectButton setImage:[UIImage imageNamed:@"selectedPic"] forState:UIControlStateNormal];

        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            
            selectButton.transform = CGAffineTransformMakeScale(1.3,1.3);
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                selectButton.transform = CGAffineTransformMakeScale(0.9,0.9);
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                    selectButton.transform = CGAffineTransformMakeScale(1.0,1.0);
                } completion:^(BOOL finished) {
                }];
            }];
        }];
    }else
    {
        if ([_selectedPhotoArr containsObject:model]) {
            [_selectedPhotoArr removeObject:model];
        }
        
        [selectButton setImage:[UIImage imageNamed:@"unSelectedPic"] forState:UIControlStateNormal];
    }
    
    if (self.selectedPhotoArr.count) {
        
        [_okButton setTitle:[NSString stringWithFormat:@"完成（%zd）",_selectedPhotoArr.count] forState:UIControlStateNormal];
    }else
    {
        [_okButton setTitle:@"完成" forState:UIControlStateNormal];
    }
    
    YAssetsViewController *assetVC =(YAssetsViewController *)self.handleViewControlelr;
    [assetVC reloadSubViews];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.returnNewSelectedPhotoArrBlock) {
        self.returnNewSelectedPhotoArrBlock(self.selectedPhotoArr,_isSelectOriginalPhoto);
        
    }
}

- (void)okButtonClick {
    
    if (self.handleViewControlelr) {
        YAssetsViewController *assetVC =(YAssetsViewController *)self.handleViewControlelr;
        
        if (assetVC.navController.navDelegate) {
            
            if (_selectedPhotoArr.count) {
                [assetVC.navController.navDelegate imagePickerNavController:assetVC.navController DidFinshed:_selectedPhotoArr];
            }else
            {
                NSMutableArray *selectArr = [NSMutableArray arrayWithObjects:_photoArr[_currentIndex], nil];
                [assetVC.navController.navDelegate imagePickerNavController:assetVC.navController DidFinshed:selectArr];
            }
        }
    }else
    {
        if (self.okButtonClickBlock) {
            self.okButtonClickBlock(_selectedPhotoArr,NO);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offSet = scrollView.contentOffset;
    _currentIndex = offSet.x / self.view.width;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self refreshNaviBarAndBottomBarState];
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photoArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YPhotoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZPhotoPreviewCell" forIndexPath:indexPath];
    cell.model = _photoArr[indexPath.row];
    
    __block BOOL _weakIsHideNaviBar = _isHideNaviBar;
    if (!cell.singleTapGestureBlock) {
        cell.singleTapGestureBlock = ^(){
            // show or hide naviBar / 显示或隐藏导航栏
            _weakIsHideNaviBar = !_weakIsHideNaviBar;
            
            if (_weakIsHideNaviBar) {
                //收起来
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
                
                [UIView animateWithDuration:.3 animations:^{
                    
                    [_naviBar setFrame:CGRectMake(0, -CGRectGetHeight(_naviBar.frame), CGRectGetWidth(_naviBar.frame), CGRectGetHeight(_naviBar.frame))];
                    
                    [_toolBar setFrame:CGRectMake(0, screenHeight, CGRectGetWidth(_toolBar.frame), CGRectGetHeight(_toolBar.frame))];
                        
                } completion:^(BOOL finished) {
                    
                }];
                
            }else
            {
                //打开
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
                
                [UIView animateWithDuration:.3 animations:^{
                    
                    [_naviBar setFrame:CGRectMake(0, 0, CGRectGetWidth(_naviBar.frame), CGRectGetHeight(_naviBar.frame))];
                    
                   [_toolBar setFrame:CGRectMake(0, screenHeight-48, CGRectGetWidth(_toolBar.frame), CGRectGetHeight(_toolBar.frame))];
                   
                } completion:^(BOOL finished) {
                    
                }];
            }
        };
    }
    return cell;
}

#pragma mark - Private Method

- (void)refreshNaviBarAndBottomBarState {
    
    YImageModel *model = _photoArr[_currentIndex];
    [_selectButton setImage:model.selected?[UIImage imageNamed:@"selectedPic"]:[UIImage imageNamed:@"unSelectedPic"] forState:UIControlStateNormal];
    indexLabel.text = [NSString stringWithFormat:@"%zd / %zd", _currentIndex + 1,_photoArr.count];
    
    if (self.selectedPhotoArr.count) {
        [_okButton setTitle:[NSString stringWithFormat:@"完成（%zd）",(unsigned long)_selectedPhotoArr.count] forState:UIControlStateNormal];
    }else
    {
        [_okButton setTitle:@"完成" forState:UIControlStateNormal];
    }

//    _numberLable.text = [NSString stringWithFormat:@"%zd",_selectedPhotoArr.count];
//    _numberImageView.hidden = (_selectedPhotoArr.count <= 0 || _isHideNaviBar);
//    _numberLable.hidden = (_selectedPhotoArr.count <= 0 || _isHideNaviBar);
//    
//    _originalPhotoButton.selected = _isSelectOriginalPhoto;
//    _originalPhotoLable.hidden = !_originalPhotoButton.isSelected;
//    if (_isSelectOriginalPhoto) [self showPhotoBytes];
    
    // If is previewing video, hide original photo button
    // 如果正在预览的是视频，隐藏原图按钮
    if (_isHideNaviBar) return;
//    if (model.type == TZAssetModelMediaTypeVideo) {
//        _originalPhotoButton.hidden = YES;
//        _originalPhotoLable.hidden = YES;
//    } else {
//        _originalPhotoButton.hidden = NO;
//        if (_isSelectOriginalPhoto)  _originalPhotoLable.hidden = NO;
//    }
}

//- (void)showPhotoBytes {
//    
//    [[YImageManager manager] getPhotosBytesWithArray:@[_photoArr[_currentIndex]] completion:^(NSString *totalBytes) {
//        _originalPhotoLable.text = [NSString stringWithFormat:@"(%@)",totalBytes];
//    }];
//}

@end
