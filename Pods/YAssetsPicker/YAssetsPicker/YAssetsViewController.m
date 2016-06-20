//
//  YAssetsViewController.m
//  YAssetsPickerDemo
//
//  Created by BestKai on 15/12/11.
//  Copyright © 2015年 BestKai. All rights reserved.
//

#import "YAssetsViewController.h"
#import "YImagePickerNavController.h"
#import "YImageModel.h"
#import "YPhotoPreviewController.h"


#pragma mark ----- colllectionCell
@implementation YGrideCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imageView.layer.masksToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageView];
        
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_selectButton setFrame:CGRectMake(CGRectGetWidth(frame)-32, 2, 30, 30)];
        _selectButton.contentMode = UIViewContentModeScaleAspectFit;
        [_selectButton addTarget:self action:@selector(selectedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selectButton];
    }
    
    return self;
}

- (void)setModel:(YImageModel *)model
{
    _model = model;
    
    if (model.thumbImage) {
        _imageView.image = model.thumbImage;
    }else
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [[YImageManager manager] getPhotoWithAsset:model.assets photoWidth:self.frame.size.width isSynchronous:NO completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    _imageView.image = photo;
                });
                model.thumbImage = photo;
            }];
            
        });
    }
    if (model.selected) {
        [_selectButton setImage:[UIImage imageNamed:@"selectedPic"] forState:UIControlStateNormal];
    }else
    {
        [_selectButton setImage:[UIImage imageNamed:@"unSelectedPic"] forState:UIControlStateNormal];
    }
}

- (void)selectedButtonClicked:(UIButton *)sender
{
    if (self.selectedDelegate) {
        
        [self.selectedDelegate selectedWithPhotModel:_model atCell:self];
    }
}
@end



@class YGrideCollectionCell;
@interface YAssetsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,YGrideSelectedDelegate,PHPhotoLibraryChangeObserver>
{
    UIButton *previewButton;
    
    UIButton *doneButton;
}
@end

@implementation YAssetsViewController

- (instancetype)initWithNav:(YImagePickerNavController *)navController
{
    self = [super init];
    
    if (self) {
        
        self.navController = navController;
        
        self.maxSelectNumber = navController.maxSelectNumber;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backImage"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissAction)];
    
    [self registerForNotifications];
    
    [self.view addSubview:self.groupCollection];
    
    [self customNavigationVCToolbar];
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    
    if (author == ALAuthorizationStatusAuthorized) {
//        [SVProgressHUD showWithStatus:@"正在加载..."];
    }
    [self customAssets];
}

- (void)registerForNotifications
{
    if (!IOS9Later) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didChangeLibrary:)
                                                     name:ALAssetsLibraryChangedNotification
                                                   object:nil];
    }else
    {
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    }
}

- (void)unregisterFromNotifications
{
    if (!IOS9Later) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:ALAssetsLibraryChangedNotification
                                                      object:nil];
    }else
    {
        [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
    }
}

- (void)didChangeLibrary:(NSNotification *)notification
{
    [self customAssets];
}

#pragma mark - PHPhotoLibraryChangeObserver
- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:_assetsGroup.result];

    if (collectionChanges == nil) {
        return;
    }
    _assetsGroup.result = [collectionChanges fetchResultAfterChanges];
    [self customAssets];
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setAssetsGroup:(YAlbumModel *)assetsGroup
{
    _assetsGroup = assetsGroup;
    
    self.title = _assetsGroup.name;
}

- (UICollectionView *)groupCollection
{
    if (!_groupCollection) {
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _groupCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,screenWidth,CGRectGetHeight(self.view.frame)-48-64) collectionViewLayout:flowLayout];
        
        _groupCollection.contentInset = UIEdgeInsetsZero;
        
        _groupCollection.backgroundColor = [UIColor whiteColor];
        
        [_groupCollection registerClass:[YGrideCollectionCell class] forCellWithReuseIdentifier:@"item"];
        
        _groupCollection.allowsMultipleSelection = YES;
        
        _groupCollection.delegate = self;
        
        _groupCollection.dataSource = self;
    }
    
    return _groupCollection;
}

- (void)customAssets
{
    _allAssetsModel = [NSMutableArray array];
    
    __block typeof(YAssetsViewController*)wealSelf = self;
    
    [[YImageManager manager] getAssetsFromFetchResult:_assetsGroup.result completion:^(NSArray<YAssetsModel *> *models) {
        
        for (int i = 0;i<models.count;i++) {
            
            YAssetsModel *model = models[i];
            
            YImageModel *photoModel = [YImageModel new];
            
            photoModel.assets = model.asset;
            
            photoModel.index =(int)index;
            
            [_allAssetsModel addObject:photoModel];
        }
        
        [wealSelf loadData];
    }];
}

- (void)loadData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.groupCollection reloadData];
        
        if (self.allAssetsModel.count) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.allAssetsModel.count-1 inSection:0];
            
            [self.groupCollection scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        }
//        [SVProgressHUD dismiss];
    });
}

#pragma mark ----- 工具栏
- (void)customNavigationVCToolbar
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.groupCollection.frame), screenWidth, 48)];
    
    previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    previewButton.frame = CGRectMake(0, 0, 60, CGRectGetHeight(bottomView.frame));
    
    [previewButton setTitle:@"预览" forState:UIControlStateNormal];
    
    [previewButton setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.8] forState:UIControlStateNormal];
    
    previewButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    [previewButton addTarget:self action:@selector(previewSelectedPhotos) forControlEvents:UIControlEventTouchUpInside];
    
    previewButton.hidden = YES;
    
    [bottomView addSubview:previewButton];
    
    
    doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    doneButton.frame = CGRectMake(bottomView.frame.size.width-110, 8, 90, CGRectGetHeight(bottomView.frame)-16);
    
    doneButton.layer.cornerRadius = 16.0;
    doneButton.layer.masksToBounds = YES;
    [doneButton addTarget:self action:@selector(doneItemClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton setBackgroundColor:[UIColor redColor]];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    doneButton.hidden = YES;
    
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    
    [bottomView addSubview:doneButton];
    
    [self.view addSubview:bottomView];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
    [bottomView addSubview:line];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.allAssetsModel.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"item";
    
    YGrideCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    cell.model = [self assetAtIndexPath:indexPath];
    
    cell.selectedDelegate = self;
    
    return cell;
}

- (NSMutableArray *)selectedAssets
{
    if (!_selectedAssets) {
        _selectedAssets = [[NSMutableArray alloc] init];
    }
    return _selectedAssets;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 0, 2);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.frame.size.width-10)/4.0, (self.view.frame.size.width-10)/4.0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YPhotoPreviewController *photoPreviewVc = [[YPhotoPreviewController alloc] init];
    photoPreviewVc.photoArr = _allAssetsModel;
    photoPreviewVc.currentIndex = indexPath.row;
    photoPreviewVc.maxSelectNumber = self.maxSelectNumber;
    photoPreviewVc.handleViewControlelr = self;
    photoPreviewVc.selectedPhotoArr = self.selectedAssets;
    [self.navController pushViewController:photoPreviewVc animated:YES];
}

- (YImageModel *)assetAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.allAssetsModel.count > 0) ? self.allAssetsModel[indexPath.item] : nil;
}

#pragma mark ----- YGrideSelectedDelegate
- (void)selectedWithPhotModel:(YImageModel *)model atCell:(YGrideCollectionCell *)cell
{
    if (self.selectedAssets.count == self.maxSelectNumber && !model.selected) {
        [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"你最多只能选择%zd张图片",self.maxSelectNumber] delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil] show];
        
        return;
    }
    
    model.selected = !model.selected;
    
    if (model.selected) {
        
        [self.selectedAssets addObject:model];
    }else
    {
        if ([self.selectedAssets containsObject:model]) {
            
            [self.selectedAssets removeObject:model];
        }
    }
    if (!model.selected) {
        
        [cell.selectButton setImage:[UIImage imageNamed:@"unSelectedPic"] forState:UIControlStateNormal];
    }else
    {
        [cell.selectButton setImage:[UIImage imageNamed:@"selectedPic"] forState:UIControlStateNormal];

        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            
            cell.selectButton.transform = CGAffineTransformMakeScale(1.3,1.3);
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                cell.selectButton.transform = CGAffineTransformMakeScale(0.9,0.9);
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                    cell.selectButton.transform = CGAffineTransformMakeScale(1.0,1.0);
                } completion:^(BOOL finished) {
                }];
            }];
        }];
    }
    
    [self customNumberLabel];
}

- (void)reloadSubViews
{
    [self customNumberLabel];
    
    [self loadData];
}


- (void)customNumberLabel
{
    if (self.selectedAssets.count) {
        
        previewButton.hidden = NO;
        
        [previewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        doneButton.hidden = NO;
        
        [doneButton setTitle:[NSString stringWithFormat:@"完成（%zd）",self.selectedAssets.count] forState:UIControlStateNormal];
    }else
    {
        previewButton.hidden = YES;
        doneButton.hidden = YES;
    }
}

#pragma mark ----- 预览
-(void)previewSelectedPhotos
{
    YPhotoPreviewController *photoPreviewVc = [[YPhotoPreviewController alloc] init];
    photoPreviewVc.photoArr = self.selectedAssets;
    photoPreviewVc.maxSelectNumber = self.maxSelectNumber;
    photoPreviewVc.handleViewControlelr = self;
    photoPreviewVc.selectedPhotoArr = self.selectedAssets;
    [self.navController pushViewController:photoPreviewVc animated:YES];
}
#pragma mark ----- 完成
- (void)doneItemClicked
{
    if (self.navController.navDelegate) {
        
        [self.navController.navDelegate imagePickerNavController:self.navController DidFinshed:self.selectedAssets];
    }
}

- (void)dismissAction
{
    if (self.navController.navDelegate) {
        
        [self.navController.navDelegate imagePickerNavController:self.navController DidFinshed:nil];
    }
}


- (void)dealloc
{
    [self unregisterFromNotifications];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
