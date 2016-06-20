//
//  GCTakePhotographHelper.m
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/12.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "GCTakePhotographHelper.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import "GCMessageKitMacro.h"

@implementation GCTakePhotographHelper

- (void)dealloc {
    self.didFinishTakeMediaCompled = nil;
}
- (void)showImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)SourceType atViewController:(UIViewController *)parentViewController finished:(didFinishTakePhotographBlock)finished
{
    if (![UIImagePickerController isSourceTypeAvailable:SourceType]) {
        finished(nil,nil);
        return;
    }
    
    self.didFinishTakeMediaCompled = [finished copy];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.editing = YES;
    imagePickerController.delegate = self;
    imagePickerController.sourceType = SourceType;
    // 去掉拍摄视频
//    if (SourceType == UIImagePickerControllerSourceTypeCamera) {
//        imagePickerController.mediaTypes =  [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
//    }
    
    if (SourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    
    [parentViewController presentViewController:imagePickerController animated:YES completion:NULL];
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        //无权限
        [[[UIAlertView alloc] initWithTitle:nil message:@"请在iPhone的“设置-隐私-相机”选项中，允许大白采购访问你的相机。" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil] show];
    }

}
- (void)dismissPickerViewController:(UIImagePickerController *)picker {
    
    WEAKSELF
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [picker dismissViewControllerAnimated:YES completion:^{
        weakSelf.didFinishTakeMediaCompled = nil;
    }];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    if (self.didFinishTakeMediaCompled) {
        self.didFinishTakeMediaCompled(image, editingInfo);
    }
    [self dismissPickerViewController:picker];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (self.didFinishTakeMediaCompled) {
        self.didFinishTakeMediaCompled(nil, info);
    }
    [self dismissPickerViewController:picker];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissPickerViewController:picker];
}



#pragma mark ----- 生成Video 封面
- (NSArray *)videoConverPhotoWithVideoPath:(NSString *)videoPath
{
    if (!videoPath)
        return nil;
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
    NSParameterAssert(asset);
    
    long second = 0;
    second = asset.duration.value / asset.duration.timescale;
    
    
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = 0;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
        
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    CGImageRelease(thumbnailImageRef);
    
    
    return [NSArray arrayWithObjects:thumbnailImage,[[NSString alloc] initWithFormat:@"%ld\"",second],nil];
}


@end
