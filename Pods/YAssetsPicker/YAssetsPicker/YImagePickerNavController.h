//
//  YImagePickerNavController.h
//  YAssetsPickerDemo
//
//  Created by BestKai on 15/12/11.
//  Copyright © 2015年 BestKai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AssetsLibrary/AssetsLibrary.h>
#import "YAlbumsViewController.h"
#import <Photos/Photos.h>

#define screenWidth ([[UIScreen mainScreen] bounds].size.width)
#define screenHeight ([[UIScreen mainScreen] bounds].size.height)

#define IOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)


@class YImagePickerNavController;
@protocol YImageNavControllerDelegate <NSObject>

- (void)imagePickerNavController:(YImagePickerNavController *)navControlelr DidFinshed:(NSMutableArray *)selectedArray;

@end


@interface YImagePickerNavController : UINavigationController

@property (nonatomic, assign) BOOL userIsDenied;

/**
 *  最大可选数目
 */
@property (assign,nonatomic) NSUInteger  maxSelectNumber;

@property (weak,nonatomic) id<YImageNavControllerDelegate> navDelegate;


- (void)showFirstAssetsController;


@end
