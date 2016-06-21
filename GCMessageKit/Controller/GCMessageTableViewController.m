//
//  GCMessageTableViewController.m
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/5.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "GCMessageTableViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "GCMessageKitMacro.h"

@interface GCMessageTableViewController ()
{
    BOOL WillDisappear;
}
/**
 *  判断是否用户手指滚动
 */
@property (nonatomic, assign) BOOL isUserScrolling;

@property (nonatomic,strong)GCHeaderContainerView *headerContainerView;

@property (nonatomic,strong)GCMessageInputView *messageInputView;

@property (nonatomic,strong)GCTakePhotographHelper *takePhotographHelper;

@property (nonatomic,strong)GCOtherMessageInputView *otherMessageInputView;

@property (nonatomic,assign)GCInputViewType inputViewType;

@property (nonatomic, strong)GCAddressBookHelper *addressBookHelper;
@end

@implementation GCMessageTableViewController

#pragma mark ----- Propertys
- (UITableView *)messageTableView
{
    if (!_messageTableView) {
        
        _messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-64) style:UITableViewStylePlain]; 
        
        // 加上Frame会发生变化，不懂
//        _messageTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _messageTableView.dataSource = self;
        
        _messageTableView.delegate = self;
        
        _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _messageTableView.backgroundColor = [UIColor clearColor];

    }
    
    return _messageTableView;
}

- (NSMutableArray *)messages
{
    if (!_messages) {
     
        _messages = [[NSMutableArray alloc] init];
    }
    return _messages;
}

- (GCHeaderContainerView *)headerContainerView
{
    if (!_headerContainerView) {
        
        _headerContainerView = [[GCHeaderContainerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 20)];
        
        _headerContainerView.backgroundColor = self.messageTableView.backgroundColor;
    }
    return _headerContainerView;
}

- (GCMessageInputView *)messageInputView
{
    if (!_messageInputView) {
        
        _messageInputView = [[GCMessageInputView alloc] initWithFrame:CGRectMake(0.0f,screenHeight -64- GCInputViewHeight,self.view.frame.size.width,GCInputViewHeight)];
        
        _messageInputView.delegate = self;
    }
    
    _messageInputView.allowsSendVoice = self.allowsSendVoice;
    _messageInputView.allowsSendMultiMedia = self.allowsSendMultiMedia;
    return _messageInputView;
}

- (GCOtherMessageInputView *)otherMessageInputView
{
    if (!_otherMessageInputView) {
        _otherMessageInputView = [[GCOtherMessageInputView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), 216)];
        _otherMessageInputView.delegate = self;
        _otherMessageInputView.otherMenuItems = self.shareMenuItems;
        [self.view addSubview:_otherMessageInputView];
    }
    return _otherMessageInputView;
}

- (GCTakePhotographHelper *)takePhotographHelper
{
    if (!_takePhotographHelper) {
        
        _takePhotographHelper = [[GCTakePhotographHelper alloc] init];
    }
    return _takePhotographHelper;
}

- (GCAddressBookHelper *)addressBookHelper
{
    if (!_addressBookHelper) {
        _addressBookHelper = [[GCAddressBookHelper alloc] init];
        _addressBookHelper.delegate = self;
    }
    return _addressBookHelper;
}

- (void)setLoadingMoreMessage:(BOOL)loadingMoreMessage
{
    _loadingMoreMessage = loadingMoreMessage;
    
    if (loadingMoreMessage) {
        [self.headerContainerView startAnimation];
    }else
    {
        [self.headerContainerView stopAnimation];
    }
}

- (void)setAllowsSendVoice:(BOOL)allowsSendVoice
{
    _allowsSendVoice = allowsSendVoice;
    
//    [self.messageInputView setUpUI];
}

- (void)setAllowsSendMultiMedia:(BOOL)allowsSendMultiMedia
{
    _allowsSendMultiMedia = allowsSendMultiMedia;
    
    [self.messageInputView setUpUI];
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        [self setUp];
        
        [[YYTextKeyboardManager defaultManager] addObserver:self];
    }
    
    return self;
}

- (void)dealloc
{
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

- (void)setUp
{
    self.delegate = self;
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.isUserScrolling = NO;

    [self.view addSubview:self.messageTableView];
    
    BOOL shouldLoadMoreMessagesScrollToTop = YES;
    
    if ([self.delegate respondsToSelector:@selector(shouldLoadMoreMessagesScrollToTop)]) {
        shouldLoadMoreMessagesScrollToTop = [self.delegate shouldLoadMoreMessagesScrollToTop];
    }
    if (shouldLoadMoreMessagesScrollToTop) {
        self.messageTableView.tableHeaderView = self.headerContainerView;
    }

    [self.view addSubview:self.messageInputView];
    
    
    [self setTableViewInsetsWithBottomValue:GCInputViewHeight];
}
#pragma mark - Scroll Message TableView Helper Method
- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom {
    
    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
    self.messageTableView.contentInset = insets;
    self.messageTableView.scrollIndicatorInsets = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        insets.top = self.topLayoutGuide.length;
    }
    
    insets.bottom = bottom;
    
    return insets;
}

#pragma mark @protocol YYTextKeyboardObserver
- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    
    if (WillDisappear) {
        return;
    }
    
    CGRect toFrame = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];

    NSLog(@"%zd",self.isBeingDismissed);
    
    if (transition.animationDuration == 0) {
        if (self.inputViewType == GCInputViewTypeText) {
            self.messageInputView.bottom = CGRectGetMinY(toFrame);
        }
        
        if (transition.toVisible) {
            self.otherMessageInputView.hidden = YES;
        }
        
        [self setTableViewInsetsWithBottomValue:self.view.frame.size.height - self.messageInputView.frame.origin.y];
        [self scrollToBottomAnimated:NO];

    } else {
        WEAKSELF
        [UIView animateWithDuration:transition.animationDuration delay:.0 options:transition.animationOption | UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            if (weakSelf.inputViewType == GCInputViewTypeText) {
                weakSelf.messageInputView.bottom = CGRectGetMinY(toFrame)>(screenHeight-64)?(screenHeight-64):CGRectGetMinY(toFrame);
            }
            if (transition.toVisible) {
                self.otherMessageInputView.hidden = YES;
            }
            [weakSelf setTableViewInsetsWithBottomValue:(screenHeight-64) - weakSelf.messageInputView.frame.origin.y];
            [weakSelf scrollToBottomAnimated:NO];

        } completion:NULL];
    }
}

#pragma mark ----- 发送消息

#pragma mark ----- GCMessageInputViewDelegate
- (void)moreButtonIsShowMore:(BOOL)isShowMore
{
    if (isShowMore) {
        
        self.inputViewType = GCInputViewTypeShareMenu;
        [self controlOtherMenuViewHidden:NO];
        
    }else
    {
        [self.messageInputView becomFirstRes];
    }
}

- (void)faceButtonisShowFace:(BOOL)isShowFace
{
    if (isShowFace) {
        self.inputViewType = GCInputViewTypeEmotion;
        [self controlOtherMenuViewHidden:NO];

    }else
    {
        [self.messageInputView becomFirstRes];
    }
}

- (void)inputTextViewWillBeginEditing:(YYTextView *)messageInputTextView
{
    self.inputViewType = GCInputViewTypeText;
}

- (void)didChangeSendVoiceAction:(BOOL)changed
{
    if (changed) {
        if (self.inputViewType == GCInputViewTypeText)
            return;
        // 在这之前，textViewInputViewType已经不是XHTextViewTextInputType
        [self controlOtherMenuViewHidden:YES];
    }
}

- (void)sendSelectedEmotion:(GCEmotion *)emotion
{
    [self.messageInputView sendGcEmotion:emotion];
}


#pragma mark ----- GCOtherMessageInputViewDelegate
#pragma mark ----- 拍照
- (void)clickPhotographView
{
    WEAKSELF
    [self.takePhotographHelper showImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera atViewController:self finished:^(UIImage *image, NSDictionary *editingInfo) {
        if (image) {
            [weakSelf didSendMessageWithOrginPhoto:image andThuPhoto:image];
        } else {
            if (!editingInfo)
                return ;
            NSString *mediaType = [editingInfo objectForKey: UIImagePickerControllerMediaType];
            NSString *videoPath;
            NSURL *videoUrl;
            if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
                videoUrl = (NSURL*)[editingInfo objectForKey:UIImagePickerControllerMediaURL];
                videoPath = [videoUrl path];
                
                NSArray *videoArray = [self.takePhotographHelper videoConverPhotoWithVideoPath:videoPath];
                
                UIImage *thumbnailImage = [videoArray objectAtIndex:0];
                
                [weakSelf didSendMessageWithVideoCoverPhto:thumbnailImage videoPath:videoPath videoDuration:[videoArray objectAtIndex:1]];
                
            } else {
                
                [weakSelf didSendMessageWithOrginPhoto:[editingInfo valueForKey:UIImagePickerControllerOriginalImage] andThuPhoto:[GCPhotoMessageHelper compressOriginImage:[editingInfo valueForKey:UIImagePickerControllerOriginalImage] withLength:500]];
            }
        }
    }];
}
#pragma mark ----- 相册
//- (void)clickToOpenAlbumView
//{
//    self.imagePickerNavController.maxSelectNumber = 9;
//    
//    [self presentViewController:self.imagePickerNavController animated:YES completion:nil];
//    
//    [self.imagePickerNavController showFirstAssetsController];
//}
#pragma mark ----- 定位
//- (void)clickGetAddressView
//{
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
//                [weakSelf didSendGeolocationsMessageWithGeolocaltions:geoLocations location:location];
//            }
//        }
//    };
//    [self.navigationController pushViewController:displayLocationViewController animated:YES];
//}

#pragma mark ----- 名片
- (void)clickOpenBusinessCardView
{
    [self.addressBookHelper showSystemAddressBookAtViewController:self];
}

- (void)systemAddressBookDidSelectPerson:(GCPerson *)person
{
    [self didSendBussinessCardWithPerson:person];
}

#pragma mark ----- 语音消息
- (void)sentVoicePath:(NSString *)voicePath WithRecordDuration:(NSString *)recordDuration
{
    [self didSendMessageWithVoicePath:voicePath voiceDuration:recordDuration];
}

- (void)sendButtonTypeText:(NSString *)text
{
    [self didSendTextAction:self.messageInputView.textView.text];
}

//文本
- (void)didSendTextAction:(NSString *)text
{
    if (text.length) {
        if ([self.delegate respondsToSelector:@selector(didSendText:fromSender:ondate:)]) {
            
            self.messageInputView.textView.text = nil;
            [self.delegate didSendText:text fromSender:@"" ondate:[NSDate date]];
        }
    }
 }
//图片
- (void)didSendMessageWithOrginPhoto:(UIImage *)originPhoto andThuPhoto:(UIImage *)thuPhoto
{
    if ([self.delegate respondsToSelector:@selector(didSendPhoto:thunmImage:fromSender:onDate:)]) {
        [self.delegate didSendPhoto:originPhoto thunmImage:thuPhoto fromSender:@"" onDate:[NSDate date]];
    }
}

- (void)didsendMessages:(NSArray *)images
{
    if ([self.delegate respondsToSelector:@selector(didSendPhoto:thunmImage:fromSender:onDate:)]) {
        
        [self.delegate didSendPhoto:images[0] thunmImage:images[1] fromSender:@"" onDate:[NSDate date]];
    }
}

//视频
- (void)didSendMessageWithVideoCoverPhto:(UIImage *)coverPhoto videoPath:(NSString *)videoPath videoDuration:(NSString *)videoDuration
{
    if ([self.delegate respondsToSelector:@selector(didSendVideoConverPhoto:videoPath:videoDuration:fromSender:onDate:)]) {
        
        [self.delegate didSendVideoConverPhoto:coverPhoto videoPath:videoPath videoDuration:videoDuration fromSender:@"" onDate:[NSDate date]];
    }
}
//语音
- (void)didSendMessageWithVoicePath:(NSString *)voicePath voiceDuration:(NSString*)voiceDuration {
    
    if ([self.delegate respondsToSelector:@selector(didSendVoice:voiceDuration:fromSender:onDate:)]) {
        [self.delegate didSendVoice:voicePath voiceDuration:voiceDuration fromSender:@"" onDate:[NSDate date]];
    }
}
//位置
- (void)didSendGeolocationsMessageWithGeolocaltions:(NSString *)geolcations location:(CLLocation *)location {
    if ([self.delegate respondsToSelector:@selector(didSendGeoLocationsPhoto:geolocations:location:fromSender:onDate:)]) {
        [self.delegate didSendGeoLocationsPhoto:[UIImage imageNamed:@"Fav_Cell_Loc"] geolocations:geolcations location:location fromSender:@"" onDate:[NSDate date]];
    }
}

- (void)didSendBussinessCardWithPerson:(GCPerson *)person
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSendPersonWithName:tel:headerImage:)]) {
        [self.delegate didSendPersonWithName:person.name tel:person.phoneNumber headerImage:person.headerImage];
    }
}

- (void)refreshInputviewSize:(CGSize)newSize {
    
    CGRect newFrame;
    newFrame = self.messageInputView.frame;
    newFrame.origin.y -= (newSize.height + 14 - newFrame.size.height);
    newFrame.size.height = newSize.height + 14;
    self.messageInputView.frame = newFrame;
    
}

#pragma mark ---- UITableViewDelegate  &&  UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCMessage *message = self.messages[indexPath.row];
    
    switch (message.messageType) {
        case GCMessageTypeText:
        {
            static NSString *textCell = @"textCell";
            GCTextMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textCell];
            
            if (!cell) {
                
                cell = [[GCTextMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCell];
            }
            cell.messageDelegate = self;
            cell.message = message;
            [cell.avatarView loadAvatarWithUrl:message.bubbleMessageType == GCBubbleMessageTypeSending?self.fromImageUrl:self.toImageUrl withBubbleType:message.bubbleMessageType];
            return cell;
        }
            break;
        case GCMessageTypeVideo:
        case GCMessageTypePhoto:
        {
            static NSString *photoCell = @"photoCell";
            GCPhotoMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:photoCell];
            
            if (!cell) {
                
                cell = [[GCPhotoMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:photoCell];
            }
            cell.messageDelegate = self;
            cell.message = message;
            [cell.avatarView loadAvatarWithUrl:message.bubbleMessageType == GCBubbleMessageTypeSending?self.fromImageUrl:self.toImageUrl withBubbleType:message.bubbleMessageType];

            return cell;
        }
            break;
        case GCMessageTypeVoice:
        {
            static NSString *voiceCell = @"voiceCell";
            GCVoiceMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:voiceCell];
            
            if (!cell) {
                
                cell = [[GCVoiceMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:voiceCell];
            }
            cell.messageDelegate = self;
            cell.message = message;
            [cell.avatarView loadAvatarWithUrl:message.bubbleMessageType == GCBubbleMessageTypeSending?self.fromImageUrl:self.toImageUrl withBubbleType:message.bubbleMessageType];

            return cell;

        }
            break;
            case GCMessageTypeLocation:
        {
            static NSString *locationCell = @"locationCell";
            GCLocationMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:locationCell];
            
            if (!cell) {
                
                cell = [[GCLocationMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:locationCell];
            }
            cell.messageDelegate = self;
            cell.message = message;
            [cell.avatarView loadAvatarWithUrl:message.bubbleMessageType == GCBubbleMessageTypeSending?self.fromImageUrl:self.toImageUrl withBubbleType:message.bubbleMessageType];

            return cell;
        }
            break;
            case GCMessageTypeNameCard:
        {
            static NSString *nameCardCell = @"nameCardCell";
            GCNameCardMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nameCardCell];
            
            if (!cell) {
                
                cell = [[GCNameCardMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nameCardCell];
            }
            cell.messageDelegate = self;
            cell.message = message;
            [cell.avatarView loadAvatarWithUrl:message.bubbleMessageType == GCBubbleMessageTypeSending?self.fromImageUrl:self.toImageUrl withBubbleType:message.bubbleMessageType];

            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCMessage *message = self.messages[indexPath.row];
    
    return message.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.messageInputView.textView isFirstResponder]) {
        [self.view endEditing:YES];
    }
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }

    
    if (self.inputViewType == GCInputViewTypeShareMenu || self.inputViewType == GCInputViewTypeEmotion) {
        
        [self controlOtherMenuViewHidden:YES];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

#pragma mark ----- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(shouldLoadMoreMessagesScrollToTop)]) {
        BOOL shouldLoadMoreMessages = [self.delegate shouldLoadMoreMessagesScrollToTop];
        if (shouldLoadMoreMessages) {
            if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= 44) {
                if (!self.loadingMoreMessage) {
                    if ([self.delegate respondsToSelector:@selector(loadMoreMessagesScrollTotop)]) {
                        [self.delegate loadMoreMessagesScrollTotop];
                    }
                }
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isUserScrolling = YES;
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }
    
//    if (self.textViewInputViewType != GCInputViewTypeNormal) {
//        [self layoutOtherMenuViewHiden:YES];
//    }
    [self controlOtherMenuViewHidden:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.isUserScrolling = NO;
}
#pragma mark ----- GCMessageTableViewControllerDelegate
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling
{
    return YES;
}


#pragma mark - PreviteFunction
- (BOOL)shouldAllowScroll {
    if (self.isUserScrolling) {
        if ([self.delegate respondsToSelector:@selector(shouldPreventScrollToBottomWhileUserScrolling)]
            && [self.delegate shouldPreventScrollToBottomWhileUserScrolling]) {
            return NO;
        }
    }
    
    return YES;
}

- (void)exChangeMessageAsynchousQuene:(void(^)())quene
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), quene);
}

- (void)exMainQueue:(void (^)())queue {
    dispatch_async(dispatch_get_main_queue(), queue);
}


#pragma mark ----- publicFunction
- (void)setBackgroundColor:(UIColor *)color {
    
    self.view.backgroundColor = color;
    self.messageTableView.backgroundColor = color;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    
    self.messageTableView.backgroundView = nil;
    self.messageTableView.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    
    if (![self shouldAllowScroll])
        return;
    
    NSInteger rows = [self.messageTableView numberOfRowsInSection:0];
    
    if (rows > 0) {
        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows-1  inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath
              atScrollPosition:(UITableViewScrollPosition)position
                      animated:(BOOL)animated {
    if (![self shouldAllowScroll])
        return;
    
    [self.messageTableView scrollToRowAtIndexPath:indexPath
                                 atScrollPosition:position
                                         animated:animated];
}

- (void)addMessage:(GCMessage *)message
{
//    WEAKSELF
//    [self exChangeMessageAsynchousQuene:^{
//        NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:1];
//        [self.messages addObject:message];
//        NSInteger row = self.messages.count - 1;
//        [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:0]];
//        [weakSelf exMainQueue:^{
//            @try {
//                [self.messageTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//            }
//            @catch (NSException *exception) {
//                [self.messageTableView reloadData];
//            }
//            [self scrollToBottomAnimated:YES];
//        }];
//    }];
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:1];
    [self.messages addObject:message];
    
    [indexPaths addObject:[NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0]];
    NSInteger row = self.messages.count - 1;
//    NSLog(@"%ld",row);
    @try {
        [self.messageTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    @catch (NSException *exception) {
        [self.messageTableView reloadData];
    }
    [self scrollToBottomAnimated:YES];

}


- (void)addMessages:(NSArray *)messages
{
//    WEAKSELF
//    [self exChangeMessageAsynchousQuene:^{
//        [self.messages addObjectsFromArray:messages];
//        
//        NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:messages.count];
//        for (NSInteger x = 1; x <= messages.count; x ++) {
//            [indexPaths addObject:[NSIndexPath indexPathForRow:self.messages.count - x inSection:0]];
//        }
//        [weakSelf exMainQueue:^{
//            @try {
//                [self.messageTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//            }
//            @catch (NSException *exception) {
//                [self.messageTableView reloadData];
//            }
//            [self scrollToBottomAnimated:YES];
//        }];
//    }];

    
    [self.messages addObjectsFromArray:messages];
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:messages.count];
    for (NSInteger x = 1; x <= messages.count; x ++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:self.messages.count - x inSection:0]];
    }
    
    @try {
        [self.messageTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
    @catch (NSException *exception) {
        [self.messageTableView reloadData];
    }

    
    [self scrollToBottomAnimated:YES];
}




static CGPoint  delayOffset = {0.0};
- (void)insertOldMessages:(NSArray *)oldMessages completion:(void (^)())completion
{
    WEAKSELF
    [self exChangeMessageAsynchousQuene:^{
        
        NSMutableArray *messages = [NSMutableArray arrayWithArray:oldMessages];
        [messages addObjectsFromArray:weakSelf.messages];
        
        delayOffset = weakSelf.messageTableView.contentOffset;
        NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:oldMessages.count];
        [oldMessages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            GCMessage *message = obj;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [indexPaths addObject:indexPath];
            delayOffset.y += message.cellHeight;
        }];
        
        [weakSelf exMainQueue:^{
            [UIView setAnimationsEnabled:NO];
            [weakSelf.messageTableView beginUpdates];
            weakSelf.messages = messages;
            [weakSelf.messageTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            [weakSelf.messageTableView setContentOffset:delayOffset animated:NO];
            [weakSelf.messageTableView endUpdates];
            [UIView setAnimationsEnabled:YES];
            completion();
        }];
    }];
}

- (void)updateMessageWithMessageID:(NSString *)messageID status:(GCMessageStatus)status oldID:(NSString *)oldID
{
    WEAKSELF
    [self exChangeMessageAsynchousQuene:^{
        for (NSInteger i = weakSelf.messages.count-1; i>=0; i--) {
            GCMessage *message = weakSelf.messages[i];            
            if ([message.msgID isEqualToString:oldID]) {
                if (status == GCMessageStatusSent) {
                    message.msgID = messageID;
                }
                message.messageStatus = status;
                [weakSelf.messages replaceObjectAtIndex:i withObject:message];
                return;
            }
        }
    }];
}

-(void)updateDataSource:(NSString* )newID status:(NSInteger)status oldID:(NSString* )oldID{
    WEAKSELF
    [self exChangeMessageAsynchousQuene:^{
        [weakSelf.messages enumerateObjectsUsingBlock:^(GCMessage*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.msgID isEqualToString:oldID]) {
                if (status == GCMessageStatusSent) {
                    obj.msgID = newID;
                }
                obj.messageStatus = status;
                [weakSelf.messages replaceObjectAtIndex:idx withObject:obj];
                *stop = YES;
            }
        }];
    }];
}


- (void)updateMessageAtIndexRow:(NSInteger)indexRow withMessage:(GCMessage *)message
{
    WEAKSELF
    [self exChangeMessageAsynchousQuene:^{
        
        if (indexRow<weakSelf.messages.count) {
            
//            [weakSelf.messages replaceObjectAtIndex:indexRow withObject:message];
            
            [weakSelf exMainQueue:^{
                
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:indexRow inSection:0];
                
                if ([self.messageTableView.visibleCells containsObject: [self.messageTableView cellForRowAtIndexPath:indexpath]]) {
                    
                    [weakSelf.messageTableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }];
        }
    }];
}


#pragma mark ----- 控制其他视图，，，，发送表情。。。
- (void)controlOtherMenuViewHidden:(BOOL)hide
{
    [self.messageInputView resignFirstRes];
    
    WEAKSELF
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        __block CGRect inputViewFrame = self.messageInputView.frame;
        __block CGRect otherMenuViewFrame;
        
        void (^InputViewAnimation)(BOOL hide) = ^(BOOL hide) {
            
            inputViewFrame.origin.y = hide ? (CGRectGetHeight(weakSelf.view.bounds) - CGRectGetHeight(inputViewFrame)) : (CGRectGetMinY(otherMenuViewFrame) - CGRectGetHeight(inputViewFrame));
            weakSelf.messageInputView.frame = inputViewFrame;
        };
        
        void (^ShareMenuViewAnimation)(BOOL hide) = ^(BOOL hide) {
            otherMenuViewFrame = weakSelf.otherMessageInputView.frame;
            otherMenuViewFrame.origin.y = (hide ? CGRectGetHeight(weakSelf.view.frame) : (CGRectGetHeight(weakSelf.view.frame) - CGRectGetHeight(otherMenuViewFrame)));
            weakSelf.otherMessageInputView.frame = otherMenuViewFrame;
            weakSelf.otherMessageInputView.hidden = hide;
            if (!hide) {
                [weakSelf.otherMessageInputView setIsShowEmotionView:(weakSelf.inputViewType == GCInputViewTypeEmotion)];
            }
        };
        
        if (hide) {
            switch (self.inputViewType) {
                case GCInputViewTypeEmotion:
                case GCInputViewTypeShareMenu: {
                    ShareMenuViewAnimation(hide);
                    break;
                }
                default:
                    break;
            }
        } else {
            // 这里需要注意block的执行顺序，因为otherMenuViewFrame是公用的对象，所以对于被隐藏的Menu的frame的origin的y会是最大值
            switch (self.inputViewType) {
                case GCInputViewTypeEmotion:
                case GCInputViewTypeShareMenu: {
                    // 2、再显示和自己相关的View
                    ShareMenuViewAnimation(hide);
                    break;
                }
                default:
                    break;
            }
        }
        
        InputViewAnimation(hide);
        
        [self setTableViewInsetsWithBottomValue:self.view.frame.size.height - self.messageInputView.frame.origin.y];
        
        [self scrollToBottomAnimated:NO];
        
    } completion:^(BOOL finished) {
        if (hide) {
            self.inputViewType = GCInputViewTypeNormal;
        }
    }];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
   WillDisappear = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    WillDisappear = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
