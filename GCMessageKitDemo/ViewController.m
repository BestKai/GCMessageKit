//
//  ViewController.m
//  GCMessageKitDemo
//
//  Created by BestKai on 16/6/20.
//  Copyright © 2016年 BestKai. All rights reserved.
//

#import "ViewController.h"
#import "GCMessageDemoViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a
}

- (IBAction)goToChatVC:(id)sender {
    
    GCMessageDemoViewController *demoVC = [[GCMessageDemoViewController alloc] init];

    [self.navigationController pushViewController:demoVC animated:YES];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
