//
//  YAssetsViewController.h
//  YAssetsPickerDemo
//
//  Created by BestKai on 15/12/11.
//  Copyright © 2015年 BestKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "YImageManager.h"
#import "YImageModel.h"

@class YGrideCollectionCell;
@protocol YGrideSelectedDelegate <NSObject>

- (void)selectedWithPhotModel:(YImageModel *)model atCell:(YGrideCollectionCell *)cell;

@end

@interface YGrideCollectionCell : UICollectionViewCell

@property (strong,nonatomic) UIImageView *imageView;

@property (strong,nonatomic) UIButton *selectButton;

@property (strong,nonatomic) YImageModel *model;

@property (assign,nonatomic) id<YGrideSelectedDelegate> selectedDelegate;

@end





@class YImagePickerNavController;
@interface YAssetsViewController : UIViewController


- (instancetype)initWithNav:(YImagePickerNavController *)navController;

@property (strong,nonatomic) NSMutableArray *allAssetsModel;

@property (nonatomic,strong) YAlbumModel *assetsGroup;

@property (strong,nonatomic) NSMutableArray *selectedAssets;

@property (strong,nonatomic) UICollectionView *groupCollection;

@property (strong,nonatomic) YImagePickerNavController *navController;

@property (assign,nonatomic) NSUInteger  maxSelectNumber;


- (void)reloadSubViews;

@end
