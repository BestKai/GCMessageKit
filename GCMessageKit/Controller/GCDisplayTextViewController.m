//
//  GCDisplayTextViewController.m
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/14.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "GCDisplayTextViewController.h"


@interface GCDisplayTextViewController()

@property (nonatomic,strong)UITextView *displayTextView;

@end

@implementation GCDisplayTextViewController


- (UITextView *)displayTextView {
    if (!_displayTextView) {
        UITextView *displayTextView = [[UITextView alloc] initWithFrame:self.view.frame];
        displayTextView.font = [UIFont systemFontOfSize:16.0f];
        displayTextView.textColor = [UIColor blackColor];
        displayTextView.userInteractionEnabled = YES;
        displayTextView.editable = NO;
        displayTextView.backgroundColor = [UIColor clearColor];
        displayTextView.dataDetectorTypes = UIDataDetectorTypeAll;
        [self.view addSubview:displayTextView];
        _displayTextView = displayTextView;
    }
    return _displayTextView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"文本消息";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backImage"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}


- (void)setMessageText:(NSString *)messageText
{
    _messageText = messageText;
    
    self.displayTextView.text = messageText;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
