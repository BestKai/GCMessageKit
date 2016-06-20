//
//  YAlbumsViewController.h
//  YAssetsPickerDemo
//
//  Created by BestKai on 15/12/11.
//  Copyright © 2015年 BestKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YAssetsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "YImageManager.h"

@class YImagePickerNavController;
@interface YAlbumsViewController : UIViewController


- (instancetype)initWithNavController:(YImagePickerNavController *)navController;


@property (strong,nonatomic  ) UITableView               *groupTableView;


@property (strong  ,nonatomic) NSMutableArray            *groupAlbums;


@property (weak,nonatomic    ) YImagePickerNavController *navController;

@property (strong,nonatomic) UILabel *noPhotoLabel;


- (void)pushToAssetsController;


@end
