//
//  YImageManager.h
//  purchasingManager
//
//  Created by BestKai on 16/2/18.
//  Copyright © 2016年 郑州悉知. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define IOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)


@class PHFetchResult;
@interface YAlbumModel : NSObject

@property (nonatomic, strong) NSString *name;        ///< The album name
@property (nonatomic, assign) NSInteger count;       ///< Count of photos the album contain
@property (nonatomic, strong) id result;             ///< PHFetchResult<PHAsset> or ALAssetsGroup<ALAsset>
@end

@class PHAsset;
@interface YAssetsModel : NSObject

@property (nonatomic, strong) id asset;             ///< PHAsset or ALAsset


@end


@interface YImageManager : NSObject<UIAlertViewDelegate>
{
    UIAlertView *rightAlertView;
}
@property (nonatomic, strong) ALAssetsLibrary *assetLibrary;

@property (nonatomic, strong) PHCachingImageManager *cachingImageManager;


+ (instancetype)manager;

/// Return YES if Authorized 返回YES如果得到了授权
- (BOOL)authorizationStatusAuthorized;

/**
 *  获取相册最后一张图片
 *
 *  @param completion <#completion description#>
 */
- (void)getCameraRollAlbumLastImage:(void(^)(UIImage *placeHoderImage,id asset))completion;


/// Get Album 获得相册/相册数组
- (void)getCameraRollAlbumcompletion:(void (^)(YAlbumModel *model))completion;

/**
 *  获取所有相册数据
 *
 *  @param completion <#completion description#>
 */
- (void)getAllAlbumscompletion:(void (^)(NSArray<YAlbumModel *> *models))completion;

/**
 *  获取某个相册里所有照片
 *
 *  @param result     <#result description#>
 *  @param completion <#completion description#>
 */
- (void)getAssetsFromFetchResult:(id)result completion:(void (^)(NSArray<YAssetsModel *> *models))completion;


- (void)getAssetFromFetchResult:(id)result atIndex:(NSInteger)index  completion:(void (^)(YAssetsModel *model))completion;



/**
 *  /// Get photo 获得照片封面
 *
 *  @param model      <#model description#>
 *  @param completion <#completion description#>
 */
- (void)getPostImageWithAlbumModel:(YAlbumModel *)model completion:(void (^)(UIImage *postImage))completion;

/**
 *  获取屏幕大小尺寸图片
 *
 *  @param asset      <#asset description#>
 *  @param completion <#completion description#>
 */
- (void)getPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion;

/**
 *  获取制定宽度的图片
 *
 *  @param asset         <#asset description#>
 *  @param photoWidth    <#photoWidth description#>
 *  @param isSynchronous <#isSynchronous description#>
 *  @param completion    <#completion description#>
 */
- (void)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth isSynchronous:(BOOL)isSynchronous completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion;

/**
 *  获取原图
 *
 *  @param asset      <#asset description#>
 *  @param completion <#completion description#>
 */
- (void)getOriginalPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo,NSDictionary *info))completion;

/**
 *  获取系统图片的Data
 *
 *  @param asset      <#asset description#>
 *  @param completion <#completion description#>
 */
- (void)getImageDataWithAsset:(id)asset completion:(void (^)(NSData *imageData))completion;


@end


