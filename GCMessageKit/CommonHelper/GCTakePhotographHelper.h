//
//  GCTakePhotographHelper.h
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/12.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^didFinishTakePhotographBlock)(UIImage *image,NSDictionary *editingInfo);

@interface GCTakePhotographHelper : NSObject<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, copy) didFinishTakePhotographBlock didFinishTakeMediaCompled;

/**
 *  打开相机
 *
 *  @param SourceType           <#SourceType description#>
 *  @param parentViewController <#parentViewController description#>
 *  @param finished             <#finished description#>
 */
- (void)showImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)SourceType atViewController:(UIViewController *)parentViewController finished:(didFinishTakePhotographBlock)finished;



/**
 *  通过视频路径生成封面
 *
 *  @param videoPath video 路径
 *
 *  @return 数组 0，封面  1，时长
 */
- (NSArray *)videoConverPhotoWithVideoPath:(NSString *)videoPath;


@end
