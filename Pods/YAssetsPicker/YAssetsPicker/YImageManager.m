//
//  YImageManager.m
//  purchasingManager
//
//  Created by BestKai on 16/2/18.
//  Copyright © 2016年 郑州悉知. All rights reserved.
//

#import "YImageManager.h"
#import "UIImage+Resize.h"


@implementation YAlbumModel


@end


@implementation YAssetsModel
@end



@implementation YImageManager

+ (instancetype)manager {
    
    static YImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        manager.cachingImageManager = [[PHCachingImageManager alloc] init];
    });
    return manager;
}

- (ALAssetsLibrary *)assetLibrary {
    if (_assetLibrary == nil) _assetLibrary = [[ALAssetsLibrary alloc] init];
    return _assetLibrary;
}

/// Return YES if Authorized 返回YES如果得到了授权
- (BOOL)authorizationStatusAuthorized {
    
    if (IOS9Later) {
        if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied||[PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusRestricted) return NO;
    } else {
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied || [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted) return NO;
    }
    return YES;
}

- (void)getCameraRollAlbumLastImage:(void (^)(UIImage *, id))completion
{
    [self getCameraRollAlbumcompletion:^(YAlbumModel *model) {
        
        [self getAssetsFromFetchResult:model.result completion:^(NSArray<YAssetsModel *> *models) {
            
            [self getPhotoWithAsset:[[models lastObject] asset] photoWidth:100 isSynchronous:YES completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                
                if (completion) {
                    completion(photo,[[models lastObject] asset]);
                }
            }];
        }];
    }];
}



#pragma mark - Get Album
/// Get Album 获得相册/相册数组
- (void)getCameraRollAlbumcompletion:(void (^)(YAlbumModel *))completion{
    __block YAlbumModel *model;
    if (IOS9Later) {
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %zd", PHAssetMediaTypeImage];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
        for (PHAssetCollection *collection in smartAlbums) {
            if ([collection.localizedTitle isEqualToString:@"Camera Roll"] || [collection.localizedTitle isEqualToString:@"相机胶卷"]) {
                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
                
                model = [self modelWithResult:fetchResult name:collection.localizedTitle];
                if (completion) completion(model);
                break;
            }
        }
    } else {
        [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if ([group numberOfAssets] < 1) return;
            NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
            if ([name isEqualToString:@"Camera Roll"] || [name isEqualToString:@"相机胶卷"]) {
                model = [self modelWithResult:group name:name];
                if (completion) completion(model);
                *stop = YES;
            }
        } failureBlock:nil];
    }
}

- (void)getAllAlbumscompletion:(void (^)(NSArray<YAlbumModel *> *))completion{
    
    NSMutableArray *albumArr = [NSMutableArray array];
    if (IOS9Later) {
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        
        PHAssetCollectionSubtype smartAlbumSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary | PHAssetCollectionSubtypeSmartAlbumRecentlyAdded | PHAssetCollectionSubtypeSmartAlbumVideos;
        // For iOS 9, We need to show ScreenShots Album && SelfPortraits Album
        if (IOS9Later) {
            smartAlbumSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary | PHAssetCollectionSubtypeSmartAlbumRecentlyAdded | PHAssetCollectionSubtypeSmartAlbumScreenshots | PHAssetCollectionSubtypeSmartAlbumSelfPortraits | PHAssetCollectionSubtypeSmartAlbumVideos;
        }
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:smartAlbumSubtype options:nil];
        for (PHAssetCollection *collection in smartAlbums) {
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (fetchResult.count < 1) continue;
            if ([collection.localizedTitle containsString:@"Deleted"] || [collection.localizedTitle containsString:@"最近删除"]) continue;
            if ([collection.localizedTitle isEqualToString:@"Camera Roll"] || [collection.localizedTitle isEqualToString:@"相机胶卷"]) {
                [albumArr insertObject:[self modelWithResult:fetchResult name:collection.localizedTitle] atIndex:0];
            } else {
                [albumArr addObject:[self modelWithResult:fetchResult name:collection.localizedTitle]];
            }
        }
        
        PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular | PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
        for (PHAssetCollection *collection in albums) {
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (fetchResult.count < 1) continue;
            if ([collection.localizedTitle isEqualToString:@"My Photo Stream"]) {
                [albumArr insertObject:[self modelWithResult:fetchResult name:collection.localizedTitle] atIndex:1];
            } else {
                [albumArr addObject:[self modelWithResult:fetchResult name:collection.localizedTitle]];
            }
        }
        if (completion) completion(albumArr);
    } else {
        [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group == nil) {
                if (completion) completion(albumArr);
            }
            if ([group numberOfAssets] < 1) return;
            NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
            if ([name isEqualToString:@"Camera Roll"] || [name isEqualToString:@"相机胶卷"]) {
                [albumArr insertObject:[self modelWithResult:group name:name] atIndex:0];
            } else if ([name isEqualToString:@"My Photo Stream"] || [name isEqualToString:@"我的照片流"]) {
                [albumArr insertObject:[self modelWithResult:group name:name] atIndex:1];
            } else {
                [albumArr addObject:[self modelWithResult:group name:name]];
            }
        } failureBlock:nil];
    }
}

#pragma mark - Get Assets
/// Get Assets 获得照片数组
- (void)getAssetsFromFetchResult:(id)result completion:(void (^)(NSArray<YAssetsModel *> *))completion {
    NSMutableArray *photoArr = [NSMutableArray array];
    if ([result isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *fetchResult = (PHFetchResult *)result;
        [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHAsset *asset = (PHAsset *)obj;
            
            YAssetsModel *model = [[YAssetsModel alloc] init];
            model.asset = asset;
            [photoArr addObject:model];
        }];
        if (completion) completion(photoArr);
    } else if ([result isKindOfClass:[ALAssetsGroup class]]) {
        ALAssetsGroup *gruop = (ALAssetsGroup *)result;
        [gruop setAssetsFilter:[ALAssetsFilter allPhotos]];
        [gruop enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result == nil) {
                if (completion) completion(photoArr);
            }
            YAssetsModel *model = [[YAssetsModel alloc] init];
            
            model.asset = result;
            
            [photoArr addObject:model];
            
            return;
        }];
    }
}

///  Get asset at index 获得下标为index的单个照片
- (void)getAssetFromFetchResult:(id)result atIndex:(NSInteger)index completion:(void (^)(YAssetsModel *))completion {
    if ([result isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *fetchResult = (PHFetchResult *)result;
        PHAsset *asset = fetchResult[index];
        
        YAssetsModel *model = [[YAssetsModel alloc] init];
        model.asset = asset;
        if (completion) completion(model);
    } else if ([result isKindOfClass:[ALAssetsGroup class]]) {
        ALAssetsGroup *gruop = (ALAssetsGroup *)result;
        [gruop setAssetsFilter:[ALAssetsFilter allPhotos]];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
        [gruop enumerateAssetsAtIndexes:indexSet options:NSEnumerationConcurrent usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            YAssetsModel *model = [[YAssetsModel alloc] init];
            model.asset = result;
            if (completion) completion(model);
            return;
        }];
    }
}

#pragma mark - Get Photo

/// Get photo 获得照片本身
- (void)getPhotoWithAsset:(id)asset completion:(void (^)(UIImage *, NSDictionary *, BOOL isDegraded))completion {
    [self getPhotoWithAsset:asset photoWidth:[UIScreen mainScreen].bounds.size.width isSynchronous:NO completion:completion];
}

- (void)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth isSynchronous:(BOOL)isSynchronous completion:(void (^)(UIImage *, NSDictionary *, BOOL isDegraded))completion {
    if (photoWidth > 600) photoWidth = 600.0;
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = (PHAsset *)asset;
        CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
        CGFloat multiple = [UIScreen mainScreen].scale;
        CGFloat pixelWidth = photoWidth * multiple;
        CGFloat pixelHeight = pixelWidth / aspectRatio;
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = isSynchronous;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(pixelWidth, pixelHeight) contentMode:PHImageContentModeAspectFit options:isSynchronous?options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            BOOL downloadFinined;
            
            downloadFinined  =  isSynchronous?(![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]):(![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            
            // 排除取消，错误，低清图三种情况，即已经获取到了高清图
            //            BOOL downloadFinined = ;
            if (downloadFinined && result) {
                //修复图片旋转问题
                if (completion) completion(isSynchronous?[result fixOrientation]:result,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
            }
            // Download image from iCloud / 从iCloud下载图片
            if ([info objectForKey:PHImageResultIsInCloudKey] && !result) {
                PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
                option.networkAccessAllowed = YES;
                [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    UIImage *resultImage = [UIImage imageWithData:imageData scale:0.1];
                    resultImage = [self scaleImage:resultImage toSize:CGSizeMake(pixelWidth, pixelHeight)];
                    if (resultImage) {
                        if (completion) completion([resultImage fixOrientation],info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                    }
                }];
            }
        }];
    } else if ([asset isKindOfClass:[ALAsset class]]) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            ALAsset *alAsset = (ALAsset *)asset;
            ALAssetRepresentation *assetRep = [alAsset defaultRepresentation];
            if (photoWidth == [UIScreen mainScreen].bounds.size.width) {
                dispatch_async(dispatch_get_global_queue(0,0), ^{
                    CGImageRef fullScrennImageRef = [assetRep fullScreenImage];
                    UIImage *fullScrennImage = [UIImage imageWithCGImage:fullScrennImageRef scale:1.0 orientation:UIImageOrientationUp];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) completion([fullScrennImage fixOrientation],nil,NO);
                    });
                });
            }else
            {
                CGImageRef thumbnailImageRef = alAsset.aspectRatioThumbnail;
                UIImage *thumbnailImage = [UIImage imageWithCGImage:thumbnailImageRef scale:1.0 orientation:UIImageOrientationUp];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (completion) completion([thumbnailImage fixOrientation],nil,YES);
                });
            }
        });
    }
}

- (void)getPostImageWithAlbumModel:(YAlbumModel *)model completion:(void (^)(UIImage *))completion {
    if (IOS9Later) {
        [[YImageManager manager] getPhotoWithAsset:[model.result lastObject] photoWidth:75 isSynchronous:NO completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            if (completion) completion(photo);
        }];
    } else {
        ALAssetsGroup *gruop = model.result;
        UIImage *postImage = [UIImage imageWithCGImage:gruop.posterImage];
        if (completion) completion(postImage);
    }
}

/// Get Original Photo / 获取原图
- (void)getOriginalPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo,NSDictionary *info))completion {
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
        option.networkAccessAllowed = YES;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinined && result) {
                if (completion) completion(result,info);
            }
        }];
    } else if ([asset isKindOfClass:[ALAsset class]]) {
        ALAsset *alAsset = (ALAsset *)asset;
        ALAssetRepresentation *assetRep = [alAsset defaultRepresentation];
        
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            CGImageRef originalImageRef = [assetRep fullResolutionImage];
            UIImage *originalImage = [UIImage imageWithCGImage:originalImageRef scale:1.0 orientation:UIImageOrientationUp];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(originalImage,nil);
            });
        });
    }
}


- (void)getImageDataWithAsset:(id)asset completion:(void (^)(NSData *))completion
{
    if ([asset isKindOfClass:[PHAsset class]]) {
        
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            
            BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
            if (downloadFinined && imageData) {
                
                if (completion) {
                    completion(imageData);
                }
            }
        }];
        
    }else
    {
        ALAsset *alAsset = (ALAsset *)asset;
        [self.assetLibrary assetForURL:alAsset.defaultRepresentation.url resultBlock:^(ALAsset *asset) {
            ALAssetRepresentation *representation = [asset defaultRepresentation];
            NSMutableData *data = [NSMutableData data];
            NSError *error;
            long long bufferOffset = 0ll;
            NSInteger bufferSize = 10000;
            long long bytesRemaining = [representation size];
            uint8_t buffer[bufferSize];
            while (bytesRemaining > 0) {
                NSUInteger bytesRead = [representation getBytes:buffer fromOffset:bufferOffset length:bufferSize error:&error];
                if (bytesRead == 0) {
                    NSLog(@"error reading asset representation: %@", error);
                    return;
                }
                bytesRemaining -= bytesRead;
                bufferOffset   += bytesRead;
                [data appendBytes:buffer length:bytesRead];
            }
            if (completion) {
                completion(data);
            }
        } failureBlock:^(NSError *error) {
            
        }];
    }
}


#pragma mark - Private Method


- (YAlbumModel *)modelWithResult:(id)result name:(NSString *)name{
    YAlbumModel *model = [[YAlbumModel alloc] init];
    model.result = result;
    model.name = name;
    if ([result isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *fetchResult = (PHFetchResult *)result;
        model.count = fetchResult.count;
    } else if ([result isKindOfClass:[ALAssetsGroup class]]) {
        ALAssetsGroup *gruop = (ALAssetsGroup *)result;
        model.count = [gruop numberOfAssets];
    }
    return model;
}

- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
