//
//  YImagePickerNavController.m
//  YAssetsPickerDemo
//
//  Created by BestKai on 15/12/11.
//  Copyright © 2015年 BestKai. All rights reserved.
//

#import "YImagePickerNavController.h"

@interface YImagePickerNavController ()

@end

@implementation YImagePickerNavController

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.navigationBar.barStyle = UIBarStyleDefault;
        self.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationBar.tintColor = [UIColor blackColor];
        self.navigationBar.titleTextAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                  [UIFont boldSystemFontOfSize:17], NSFontAttributeName,
                                                  [UIColor blackColor], NSForegroundColorAttributeName,
                                                  nil];
        self.navigationBar.translucent = YES;
        
        self.viewControllers = @[[[YAlbumsViewController alloc]initWithNavController:self]];
    }
    
    return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showFirstAssetsController{
    
    YAlbumsViewController *albumsVC = (YAlbumsViewController *)[self.viewControllers firstObject];
    
    if ([albumsVC respondsToSelector:@selector(pushToAssetsController)]) {
        
        [albumsVC pushToAssetsController];
    }
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
