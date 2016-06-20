//
//  GCMessageTableViewController.h
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/5.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCHeaderContainerView.h"
#import "GCTextMessageTableViewCell.h"
#import "GCPhotoMessageTableViewCell.h"
#import "GCVoiceMessageTableViewCell.h"
#import "GCLocationMessageTableViewCell.h"
#import "GCNameCardMessageTableViewCell.h"

#import "GCMessage.h"
#import "GCMessageInputView.h"
#import "GCOtherMessageInputView.h"
#import "GCTakePhotographHelper.h"
#import "YImagePickerNavController.h"
#import "GCDisplayLocationViewController.h"

#import "GCVoiceRecordHelper.h"
#import "GCAddressBookHelper.h"
@protocol GCMessageTableViewControllerDelegate <NSObject>

@optional 
/**
 *  协议回掉是否支持用户手动滚动
 *
 *  @return 返回YES or NO
 */
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling;


/**
 *  删除消息
 *
 *  @param row <#row description#>
 */
- (void)didDeleteMessageAtIndex:(NSInteger)row;

/**
 *  发送文本
 *
 *  @param text   消息内容
 *  @param sender 发送者名字
 *  @param date   发送时间
 */
- (void)didSendText:(NSString *)text fromSender:(NSString *)sender ondate:(NSDate *)date;


/**
 *  发送图片消息的回调方法
 *
 *  @param photo  目标图片对象，后续有可能会换 原图
 *  @param thuImage  缩略图
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendPhoto:(UIImage *)photo thunmImage:(UIImage* )thuImage fromSender:(NSString *)sender onDate:(NSDate *)date;

/**
 *  发送视频消息的回调方法
 *
 *  @param videoConverPhoto 目标视频的封面图
 *  @param videoPath        目标视频本地路径
 *  @param videoDuration    目标视频时长
 *  @param sender           发送者的名字
 *  @param date             发送时间
 */
- (void)didSendVideoConverPhoto:(UIImage *)videoConverPhoto videoPath:(NSString *)videoPath videoDuration:(NSString *)videoDuration fromSender:(NSString *)sender onDate:(NSDate *)date;

/**
 *  发送语音消息的回调方法
 *
 *  @param voicePath        目标语音本地路径
 *  @param voiceDuration    目标语音时长
 *  @param sender           发送者的名字
 *  @param date             发送时间
 */
- (void)didSendVoice:(NSString *)voicePath voiceDuration:(NSString*)voiceDuration fromSender:(NSString *)sender onDate:(NSDate *)date;

/**
 *  发送地理位置的回调方法
 *
 *  @param geoLocationsPhoto 目标显示默认图
 *  @param geolocations      目标地理信息
 *  @param location          目标地理经纬度
 *  @param sender            发送者
 *  @param date              发送时间
 */
- (void)didSendGeoLocationsPhoto:(UIImage *)geoLocationsPhoto geolocations:(NSString *)geolocations location:(CLLocation *)location fromSender:(NSString *)sender onDate:(NSDate *)date;

/**
 *  一次性发送多张图片
 *
 *  @param messages @[@[originImage,thuImage],@[]]
 *  @param sender   <#sender description#>
 *  @param date     <#date description#>
 */
- (void)didSendMessages:(NSArray *)messages fromSender:(NSString *)sender onDate:(NSDate *)date;


/**
 *  发送名片
 *
 *  @param name   <#name description#>
 *  @param tel    <#tel description#>
 *  @param header <#header description#>
 */
- (void)didSendPersonWithName:(NSString *)name tel:(NSString *)tel headerImage:(UIImage *)header;

/**
 *  判断是否支持下拉加载更多消息
 *
 *  @return 返回BOOL值，判定是否拥有这个功能
 */
- (BOOL)shouldLoadMoreMessagesScrollToTop;

/**
 *  下拉加载更多消息，只有在支持下拉加载更多消息的情况下才会调用。
 */
- (void)loadMoreMessagesScrollTotop;

@end




@interface GCMessageTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,GCMessageInputViewDelegate,YYTextKeyboardObserver,GCMessageTableViewControllerDelegate,YImageNavControllerDelegate,GCMessageTableCellDelegate,GCOtherMessageInputViewDelegate,GCSystemAddressBookViewControllerDelegate>

@property (assign,nonatomic) id<GCMessageTableViewControllerDelegate>  delegate;

@property (nonatomic,strong)NSMutableArray *messages;

@property (nonatomic,strong)UITableView *messageTableView;

@property (nonatomic, strong)   NSString* fromImageUrl;
@property (nonatomic, strong)   NSString* toImageUrl;
@property (nonatomic, strong)   UIImage* fromImage;
@property (nonatomic, strong)   UIImage* toImage;


/**
 *  第三方接入的功能，也包括系统自身的功能，比如拍照、发送地理位置
 */
@property (nonatomic, strong) NSArray *shareMenuItems;
     
/**
 *  是否正在加载更多旧的消息数据
 */
@property (nonatomic, assign) BOOL loadingMoreMessage;

/**
 *  是否允许发送语音
 */
@property (nonatomic, assign) BOOL allowsSendVoice; // default is YES


/**
 *  是否允许发送多媒体
 */
@property (nonatomic, assign) BOOL allowsSendMultiMedia; // default is YES



/**
 *  添加一条新消息
 *
 *  @param message <#message description#>
 */
- (void)addMessage:(GCMessage *)message;

/**
 *  添加多条消息
 *
 *  @param messages <#messages description#>
 */
- (void)addMessages:(NSArray *)messages;

/**
 *  插入旧消息数据到头部，仿微信的做法
 *
 *  @param oldMessages 目标的旧消息数据
 */
- (void)insertOldMessages:(NSArray *)oldMessages completion:(void (^)())completion;

/**
 *  更新消息
 *
 *  @param messageID     <#messageID description#>
 *  @param messageStatus <#messageStatus description#>
 *  @param oldID         <#oldID description#>
 */
- (void)updateMessageWithMessageID:(NSString *)messageID status:(GCMessageStatus)status oldID:(NSString *)oldID;

/**
 *  更新某条消息
 *
 *  @param indexRow <#indexRow description#>
 *  @param message  <#message description#>
 */
- (void)updateMessageAtIndexRow:(NSInteger)indexRow withMessage:(GCMessage *)message;


/**
 *  消息通知
 *
 *  @param newID  新的消息ID
 *  @param status 消息状态
 *  @param oldID  旧的消息ID
 */
-(void)updateDataSource:(NSString* )newID status:(NSInteger)status oldID:(NSString* )oldID;


/**
 *  设置View、tableView的背景颜色
 *
 *  @param color 背景颜色
 */
- (void)setBackgroundColor:(UIColor *)color;

/**
 *  设置消息列表的背景图片
 *
 *  @param backgroundImage 目标背景图片
 */
- (void)setBackgroundImage:(UIImage *)backgroundImage;

/**
 *  是否滚动到底部
 *
 *  @param animated YES Or NO
 */
- (void)scrollToBottomAnimated:(BOOL)animated;

/**
 *  滚动到哪一行
 *
 *  @param indexPath 目标行数变量
 *  @param position  UITableViewScrollPosition 整形常亮
 *  @param animated  是否滚动动画，YES or NO
 */
- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath
              atScrollPosition:(UITableViewScrollPosition)position
                      animated:(BOOL)animated;

@end
