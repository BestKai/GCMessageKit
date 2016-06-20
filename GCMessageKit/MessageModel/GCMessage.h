//
//  GCMessage.h
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/6.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCMessageKitMacro.h"
#import <CoreLocation/CoreLocation.h>
#import "GCMessageBubbleHelper.h"
#import "GCPhotoMessageHelper.h"
@interface GCMessage : NSObject

#pragma mark ----- publicProperty

@property (strong,nonatomic) UIImage *avatarImage;
@property (copy  ,nonatomic) NSString *avatarUrl;
@property (copy  ,nonatomic) NSString *senderID;
@property (assign,nonatomic) NSInteger timeStamp;
@property (copy  ,nonatomic) NSString *timeString;

@property (copy  ,nonatomic) NSString *msgID;

@property (copy  ,nonatomic) NSString *sourceString;
@property (copy  ,nonatomic) NSString *sourceUrl;



@property (assign,nonatomic) GCMessageStatus  messageStatus;
@property (assign,nonatomic) GCMessageType  messageType;
@property (assign,nonatomic) GCBubbleMessageType  bubbleMessageType;
@property (assign,nonatomic) BOOL  isAnonymous;
@property (strong,nonatomic) UIImage *bubbleImage;


@property (assign,nonatomic) BOOL  shouldShowTimeLabel;//是否显示时间轴


@property (assign,nonatomic) CGFloat cellHeight;
@property (assign,nonatomic) CGRect  avatarFrame;// 头像Frame
@property (assign,nonatomic) CGRect  bubbleFrame;// 气泡Frame
@property (assign,nonatomic) CGRect  statusFrame;// 消息状态Frame
@property (assign,nonatomic) CGRect  timeFrame;  // 时间Frame
@property (assign,nonatomic) CGRect  sourceFrame;// 来源Frame





#pragma mark ----- 文本信息
@property (copy  ,nonatomic) NSString *text;
@property (strong,nonatomic) YYTextLayout *textLayout;
@property (assign,nonatomic) CGRect  textLabelFrame;



#pragma mark ----- 图片消息
@property (strong,nonatomic) UIImage *photo;
@property (strong,nonatomic) UIImage *originImage;
@property (copy  ,nonatomic) NSString *thumbnailUrl;
@property (copy  ,nonatomic) NSString *originPhotoUrl;
@property (assign,nonatomic) CGSize photoSize;


#pragma mark ----- 视频消息
@property (strong,nonatomic) UIImage  *videoCoverPhoto;
@property (copy  ,nonatomic) NSString *videoPath;
@property (copy  ,nonatomic) NSString *videoDuration;
@property (assign,nonatomic) CGRect  videoCoverFrame;


#pragma mark ----- 语音消息
@property (strong,nonatomic) UIImage *voiceImage;
@property (copy  ,nonatomic) NSString *voicePath;
@property (copy  ,nonatomic) NSString *voiceDuration;//时长
@property (copy  ,nonatomic) NSString *durationString;//显示的时长字符串
@property (assign,nonatomic) BOOL  isRead;
@property (assign,nonatomic) CGRect  voiceImageFrame;
@property (assign,nonatomic) CGRect  unReadImageFrame;
@property (assign,nonatomic) CGRect  durationFrame;



#pragma mark ----- 位置消息
@property (copy  ,nonatomic) NSString *geolocations;
@property (strong,nonatomic) CLLocation *location;
@property (assign,nonatomic) CGRect  locationFrame;



#pragma mark ----- 名片消息
@property (copy  ,nonatomic) NSString *userID;
@property (copy  ,nonatomic) NSString *userHeadImagUrl;
@property (copy  ,nonatomic) NSString *userSex;
@property (copy  ,nonatomic) NSString *userMobile;
@property (copy  ,nonatomic) NSString *userTureName;
@property (assign,nonatomic) CGRect  nameCardFrame;
@property (assign,nonatomic) BOOL  isAddFriend;



/**
 *  初始化文本消息
 *
 *  @param text      <#text description#>
 *  @param sender    <#sender description#>
 *  @param timeStamp <#timeStamp description#>
 *  @param bubbleMessageType  消息类型  发送    接受
 *  @param isAnonymous        是否匿名
 *  @return <#return value description#>
 */
- (instancetype)initWithText:(NSString *)text
                      sender:(NSString *)sender
                   goodsInfo:(NSDictionary *)goodsInfo
                   timeStamp:(NSInteger )timeStamp
           bubbleMessageType:(GCBubbleMessageType)bubbleMessageType
                 isAnonymous:(BOOL)isAnonymous
         shouldShowTimeLabel:(BOOL)shouldShowTimeLabel;



/**
 *  图片消息
 *
 *  @param photo               <#photo description#>
 *  @param thumbnailUrl        缩略图URL
 *  @param originPhotoUrl      原图URL
 *  @param sender              <#sender description#>
 *  @param timeStamp           <#timeStamp description#>
 *  @param bubbleMessageType   <#bubbleMessageType description#>
 *  @param isAnonymous         <#isAnonymous description#>
 *  @param shouldShowTimeLabel <#shouldShowTimeLabel description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithPhoto:(UIImage *)photo
                 thumbnailUrl:(NSString *)thumbnailUrl
               originPhotoUrl:(NSString *)originPhotoUrl
                    photoSize:(CGSize)photoSize
                       sender:(NSString *)sender
                    timeStamp:(NSInteger )timeStamp
            bubbleMessageType:(GCBubbleMessageType)bubbleMessageType
                  isAnonymous:(BOOL)isAnonymous
          shouldShowTimeLabel:(BOOL)shouldShowTimeLabel;

/**
 *  初始化语音消息
 *
 *  @param voicePath           路径
 *  @param voiceDuration       时长
 *  @param sender              <#sender description#>
 *  @param timeStamp           <#timeStamp description#>
 *  @param bubbleMessageType   <#bubbleMessageType description#>
 *  @param isAnonymous         <#isAnonymous description#>
 *  @param shouldShowTimeLabel <#shouldShowTimeLabel description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithVoicePath:(NSString *)voicePath
                    voiceDuration:(NSString *)voiceDuration
                           sender:(NSString *)sender
                           isRead:(BOOL)isRead
                        timeStamp:(NSInteger )timeStamp
                bubbleMessageType:(GCBubbleMessageType)bubbleMessageType
                      isAnonymous:(BOOL)isAnonymous
              shouldShowTimeLabel:(BOOL)shouldShowTimeLabel;


/**
 *  初始化位置信息
 *
 *  @param location            <#location description#>
 *  @param gelLocations        <#gelLocations description#>
 *  @param sender              <#sender description#>
 *  @param timeStamp           <#timeStamp description#>
 *  @param bubbleMessageType   <#bubbleMessageType description#>
 *  @param isAnonymous         <#isAnonymous description#>
 *  @param shouldShowTimeLabel <#shouldShowTimeLabel description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithLocation:(CLLocation *)location
                     geoLocation:(NSString *)geoLocations
                          sender:(NSString *)sender
                       timeStamp:(NSInteger )timeStamp
               bubbleMessageType:(GCBubbleMessageType)bubbleMessageType
                     isAnonymous:(BOOL)isAnonymous
             shouldShowTimeLabel:(BOOL)shouldShowTimeLabel;


/**
 *  发送视频消息
 *
 *  @param videoCoverImage     <#videoCoverImage description#>
 *  @param videoPath           <#videoPath description#>
 *  @param videoDuration       <#videoDuration description#>
 *  @param sender              <#sender description#>
 *  @param timeStamp           <#timeStamp description#>
 *  @param bubbleMessageType   <#bubbleMessageType description#>
 *  @param isAnonymous         <#isAnonymous description#>
 *  @param shouldShowTimeLabel <#shouldShowTimeLabel description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithVideoCoverImage:(UIImage *)videoCoverImage
                              videoPath:(NSString *)videoPath
                          videoDuration:(NSString *)videoDuration
                                 sender:(NSString *)sender
                              timeStamp:(NSInteger )timeStamp
                      bubbleMessageType:(GCBubbleMessageType)bubbleMessageType
                            isAnonymous:(BOOL)isAnonymous
                    shouldShowTimeLabel:(BOOL)shouldShowTimeLabel;

/**
 *  发送名片
 *
 *  @param userInfo            userInfo
 *  @param sender              <#sender description#>
 *  @param timestamp           <#timestamp description#>
 *  @param bubbleMessageType   <#bubbleMessageType description#>
 *  @param isAnonymous         <#isAnonymous description#>
 *  @param shouldShowTimeLabel <#shouldShowTimeLabel description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithNameCard:(NSDictionary *)userInfo
                          sender:(NSString *)sender
                       timestamp:(NSInteger)timestamp
               bubbleMessageType:(GCBubbleMessageType)bubbleMessageType
                     isAnonymous:(BOOL)isAnonymous
             shouldShowTimeLabel:(BOOL)shouldShowTimeLabel;






@end
