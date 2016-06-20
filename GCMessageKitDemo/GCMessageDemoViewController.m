//
//  GCMessageDemoViewController.m
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/9.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "GCMessageDemoViewController.h"

@implementation GCMessageDemoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self setBackgroundColor:[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0]];

    self.allowsSendMultiMedia = YES;
    self.allowsSendVoice = YES;
    
    NSMutableArray *shareMenus = [[NSMutableArray alloc] init];
    NSArray *plugIcons;
    NSArray *plugTitle;
    
    plugIcons = @[@"sharemore_pic", @"sharemore_video",@"sharemore_location",@"sharemore_card"];
    plugTitle = @[@"照片", @"拍摄",@"位置",@"名片"];
    
    for (NSString *plugIcon in plugIcons) {
        GCOtherMenuItem *shareMenuItem = [[GCOtherMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:plugIcon] title:[plugTitle objectAtIndex:[plugIcons indexOfObject:plugIcon]]];
        [shareMenus addObject:shareMenuItem];
    }
    
    self.shareMenuItems = shareMenus;

    
    self.toImageUrl = @"http://tx.haiqq.com/qqtouxiang/uploads/2014-04-08/011438126.jpg";
    self.fromImageUrl = @"http://img.jiqie.com/11/6/1524mj.jpg";
    for (int i = 0;i<10 ; i++) {
        GCMessage *message = [[GCMessage alloc] initWithNameCard:nil sender:@"" timestamp:1343366655 bubbleMessageType:i%2?GCBubbleMessageTypeSending:GCBubbleMessageTypeReceiving isAnonymous:NO shouldShowTimeLabel:YES];
        message.msgID = [[NSString alloc] initWithFormat:@"%d",i];
        message.messageStatus = GCMessageStatusSent;
        [self.messages addObject:message];
    }

    [self.messageTableView reloadData];

    [self scrollToBottomAnimated:YES];
    
//            消息状态
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [self updateMessageWithMessageID:@"23" status:GCMessageStatusSent oldID:@"8"];
//    });

    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_9_0
#endif
    
    
}

- (void)didSendText:(NSString *)text fromSender:(NSString *)sender ondate:(NSDate *)date
{
    GCMessage *message = [[GCMessage alloc] initWithText:text sender:@"" goodsInfo:nil timeStamp:[date timeIntervalSince1970] bubbleMessageType:GCBubbleMessageTypeSending isAnonymous:NO shouldShowTimeLabel:YES];
    
    [self addMessage:message];
}

- (void)didSendPhoto:(UIImage *)photo thunmImage:(UIImage *)thuImage fromSender:(NSString *)sender onDate:(NSDate *)date
{
    NSData* imageData = UIImageJPEGRepresentation(photo,.8);
    
    NSData* thuImageData = UIImageJPEGRepresentation(thuImage,1);
    
    NSString *path = NSTemporaryDirectory();
    NSString *imageName =[NSString stringWithFormat:@"%f",[date timeIntervalSince1970]*1000];
    NSString *thuImageName = [imageName stringByAppendingString:@"_thu"];
    
    
    NSString *imagePath = [path stringByAppendingString:imageName];
    NSString *thuImagePath = [path stringByAppendingString:thuImageName];
    NSURL *url = [NSURL fileURLWithPath:imagePath isDirectory:YES];
    NSURL *thuUrl = [NSURL fileURLWithPath:thuImagePath isDirectory:YES];
    
    BOOL result = [imageData writeToURL:url atomically:YES];
    result = [thuImageData writeToURL:thuUrl atomically:YES];

    if (result) {
        GCMessage *message = [[GCMessage alloc] initWithPhoto:thuImage thumbnailUrl:thuImagePath originPhotoUrl:imagePath photoSize:thuImage.size sender:@"" timeStamp:[date timeIntervalSince1970] bubbleMessageType:GCBubbleMessageTypeReceiving isAnonymous:NO shouldShowTimeLabel:YES];
        
        [self addMessage:message];
    }
}

- (void)didSendVideoConverPhoto:(UIImage *)videoConverPhoto videoPath:(NSString *)videoPath videoDuration:(NSString *)videoDuration fromSender:(NSString *)sender onDate:(NSDate *)date
{
    
    GCMessage *message = [[GCMessage alloc] initWithVideoCoverImage:videoConverPhoto videoPath:videoPath videoDuration:@"2" sender:nil timeStamp:[date timeIntervalSince1970] bubbleMessageType:GCBubbleMessageTypeSending isAnonymous:NO shouldShowTimeLabel:YES];
    [self addMessage:message];
}

- (void)didSendMessages:(NSArray *)messages fromSender:(NSString *)sender onDate:(NSDate *)date
{
    NSMutableArray *msgs = [NSMutableArray new];
    for (int i = 0; i<messages.count; i++) {
        
        NSArray *aa = messages[i];
        
        GCMessage *message = [[GCMessage alloc] initWithPhoto:aa[1] thumbnailUrl:@"" originPhotoUrl:@"" photoSize:CGSizeZero sender:@"" timeStamp:[date timeIntervalSince1970] bubbleMessageType:GCBubbleMessageTypeSending isAnonymous:NO shouldShowTimeLabel:YES];
        [msgs addObject:message];
    }
    [self addMessages:msgs];
}

- (void)didSendVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration fromSender:(NSString *)sender onDate:(NSDate *)date
{
    GCMessage *message = [[GCMessage alloc] initWithVoicePath:voicePath voiceDuration:@"2" sender:@"" isRead:NO  timeStamp:[date timeIntervalSince1970] bubbleMessageType:GCBubbleMessageTypeSending isAnonymous:NO shouldShowTimeLabel:YES];
    [self addMessage:message];
}

- (void)didSendGeoLocationsPhoto:(UIImage *)geoLocationsPhoto geolocations:(NSString *)geolocations location:(CLLocation *)location fromSender:(NSString *)sender onDate:(NSDate *)date
{
    GCMessage *message = [[GCMessage alloc] initWithLocation:location geoLocation:geolocations sender:@"" timeStamp:[date timeIntervalSince1970] bubbleMessageType:GCBubbleMessageTypeSending isAnonymous:NO shouldShowTimeLabel:YES];
    
    [self addMessage:message];
}

- (BOOL)shouldLoadMoreMessagesScrollToTop
{
    return NO;
}


- (void)loadMoreMessagesScrollTotop
{
    if (self.messages.count ==0 || self.loadingMoreMessage) {
        return;
    }
    self.loadingMoreMessage = YES;
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSMutableArray *oldMessages = [NSMutableArray new];
            for (int i = 0; i<10; i++) {
                
                GCMessage *message = [[GCMessage alloc] initWithText:@"taohuaansdjfnasldnkfsakndflaksndkfnjaksjdnfkajnsdkfjnasldknjf;asdf;ansd;kfna;sdjbnf;abdsnf;kba" sender:@""goodsInfo:nil timeStamp:14848383838 bubbleMessageType:i%2==0?GCBubbleMessageTypeSending:GCBubbleMessageTypeReceiving isAnonymous:NO shouldShowTimeLabel:YES];
                
                [oldMessages addObject:message];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf insertOldMessages:oldMessages completion:^{
                    weakSelf.loadingMoreMessage = NO;
                }];
            });
        });
    });
}

#pragma mark ----- GCMessageTableViewCellDelegate
- (void)didSelectedOnCell:(GCMessageBaseTableViewCell *)cell
{
    UIViewController *disPlayViewController;

    GCMessage *message = cell.message;
    switch (message.messageType) {
        case GCMessageTypeText:
        {
            GCDisplayTextViewController *displayTextVC = [[GCDisplayTextViewController alloc] init];
            
            displayTextVC.messageText = message.text;
            
            [self.navigationController pushViewController:displayTextVC animated:YES];
        }
            break;
        case GCMessageTypePhoto:
        {
//            GCPhotoMessageTableViewCell *photoCell = (GCPhotoMessageTableViewCell *)cell;
            
            
//            UIImageView *fromView = nil;
//            
//            NSMutableArray *items = [NSMutableArray new];
//            
//            
//            for (int i = 0; i < 1; i++) {
//                
//                UIImageView *imageView = (UIImageView *)photoCell.photoImageView;
//                
//                YYPhotoGroupItem *item = [YYPhotoGroupItem new];
//                
//                
//                item.thumbView = imageView;
//                
//                item.originImage = message.originImage;
//                
//                item.largeImageURL = nil;
//                
//                [items addObject:item];
//                
//                fromView = imageView;
//            }
//            
//            YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
//            
//            [v presentFromImageView:fromView toContainer:self.navigationController.view animated:YES completion:nil];

        }
            break;
        case GCMessageTypeVideo:
        {
            GCDisplayMediaViewController *mediaVC = [[GCDisplayMediaViewController alloc] init];
            
            mediaVC.message = message;
            
            [self.navigationController pushViewController:mediaVC animated:YES];
        }
            break;
        case GCMessageTypeVoice:
        {
            GCVoiceMessageTableViewCell *currentCell =(GCVoiceMessageTableViewCell *)cell;
            //声音
            message.isRead = YES;
            currentCell.unReadDotImageView.hidden = YES;
            
            [[GCAudioPlayerHelper shareInstance] setDelegate:(id<NSFileManagerDelegate>)self];
            if (_currentSelectedCell) {
                [[_currentSelectedCell animationVoiceImageView] stopAnimating];
            }
            if (_currentSelectedCell == currentCell) {
                [currentCell.animationVoiceImageView stopAnimating];
                [[GCAudioPlayerHelper shareInstance] stopAudio];
                self.currentSelectedCell = nil;
            } else {
                self.currentSelectedCell = cell;
                [currentCell.animationVoiceImageView startAnimating];
                
                [[GCAudioPlayerHelper shareInstance] managerAudioWithFileName:message.voicePath toPlay:YES];
               }
        }
            break;
        case GCMessageTypeLocation:
        {
//            GCDisplayLocationViewController *locationVC = [[GCDisplayLocationViewController alloc] init];
////            locationVC.message = message;
//            disPlayViewController = locationVC;
        }
            break;
        case GCMessageTypeNameCard:
        {
            NSLog(@"namecard");
            NSLog(@"%@",cell);

        }
        default:
            break;
    }
    
    if (disPlayViewController) {
        [self.navigationController pushViewController:disPlayViewController animated:YES];
    }
}


- (void)clickGetAddressView
{
//    GCDisplayLocationViewController *displayLocationViewController = [[GCDisplayLocationViewController alloc] init];
//
//    displayLocationViewController.needLocation = YES;
//
//    WEAKSELF
//    displayLocationViewController.DidGetGeolocationsCompledBlock = ^(NSString *result,CLLocation *location)
//    {
//        if (result) {
//            NSString *geoLocations = result;
//            if (geoLocations) {
//                [weakSelf didSendGeoLocationsPhoto:[UIImage imageNamed:@"Fav_Cell_Loc"] geolocations:result location:location fromSender:@"" onDate:[NSDate date]];
//            }
//        }
//    };
//    [self.navigationController pushViewController:displayLocationViewController animated:YES];

}

- (void)avatarImageViewTapped
{
    NSLog(@"点击了头像");
}





@end
