//
//  GCDisplayMediaViewController.m
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/13.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "GCDisplayMediaViewController.h"
#import <MediaPlayer/MediaPlayer.h>


@interface GCDisplayMediaViewController ()

@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;

@property (nonatomic, weak) UIImageView *photoImageView;

@end


@implementation GCDisplayMediaViewController


- (MPMoviePlayerController *)moviePlayerController {
    if (!_moviePlayerController) {
        _moviePlayerController = [[MPMoviePlayerController alloc] init];
        _moviePlayerController.repeatMode = MPMovieRepeatModeNone;
        _moviePlayerController.scalingMode = MPMovieScalingModeAspectFill;
        _moviePlayerController.view.frame = self.view.frame;
        [self.view addSubview:_moviePlayerController.view];
    }
    return _moviePlayerController;
}

- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        photoImageView.clipsToBounds = YES;
        [self.view addSubview:photoImageView];
        _photoImageView = photoImageView;
    }
    return _photoImageView;
}

- (void)setMessage:(GCMessage *)message {
    _message = message;
    if ([message messageType] == GCMessageTypeVideo) {
        self.title =  @"详细视频";
        if ([message videoPath]) {
            if ([[message videoPath] containsString:@"http://"]) {
                
                self.moviePlayerController.contentURL = [NSURL URLWithString:[[message videoPath] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }else
            {
                NSString *aaa;
                
                if ([[message videoPath] containsString:@"/private"]) {
                    
                    aaa = [[[message videoPath] componentsSeparatedByString:@"tmp/"] objectAtIndex:1];
                }else
                {
                    aaa = [message videoPath];
                }
                
                NSString *path = NSTemporaryDirectory();
                
                NSString *imagepath = [path stringByAppendingFormat:@"%@",aaa];
                self.moviePlayerController.contentURL = [NSURL fileURLWithPath:imagepath];
            }
            
        }else
        {
            if ([[message videoPath] containsString:@"http://"]) {
                self.moviePlayerController.contentURL = [NSURL URLWithString:[message videoPath]];
            }else
            {
                NSString *path = NSTemporaryDirectory();
                
                NSString *imagepath = [path stringByAppendingString:[message videoPath]];
                
                self.moviePlayerController.contentURL = [NSURL URLWithString:imagepath];
            }
        }
        [self.moviePlayerController play];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backImage"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

- (void)dealloc {
    
    [_moviePlayerController stop];
    _moviePlayerController = nil;
    
    _photoImageView = nil;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
