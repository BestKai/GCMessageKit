//
//  GCMessage.m
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/6.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "GCMessage.h"
#import "GCMessageInputViewHelper.h"

@implementation GCMessage


- (BOOL)isSelf
{
    return (self.bubbleMessageType == GCBubbleMessageTypeSending);
}


#pragma mark ----- 时间头像
- (void)calcuteTimeAndAvatar
{
    if (self.shouldShowTimeLabel) {
        
        [self calculateTimeTextLayout];
        
        self.avatarFrame = [self isSelf]?CGRectMake(screenWidth-GCAvatarViewWidth, CGRectGetMaxY(self.timeFrame)+ 12, GCAvatarViewWidth, GCAvatarViewWidth):CGRectMake(0, CGRectGetMaxY(self.timeFrame)+ 12, GCAvatarViewWidth, GCAvatarViewWidth);
    }else
    {
        self.timeFrame = CGRectZero;
        
        self.avatarFrame = [self isSelf]?CGRectMake(screenWidth-GCAvatarViewWidth, GCBubbleMarginTop, GCAvatarViewWidth, GCAvatarViewWidth):CGRectMake(0, GCBubbleMarginTop, GCAvatarViewWidth, GCAvatarViewWidth);
    }
}

#pragma mark ----- 气泡
- (void)calculateMessageBubbleFrameWithSize:(CGSize)bubbleSize
{
    if (self.shouldShowTimeLabel) {
        
        self.bubbleFrame = [self isSelf]?CGRectMake((screenWidth-bubbleSize.width - GCAvatarViewWidth), CGRectGetMinY(self.avatarFrame), bubbleSize.width, bubbleSize.height):CGRectMake(GCAvatarViewWidth, CGRectGetMinY(self.avatarFrame), bubbleSize.width, bubbleSize.height);
    }else
    {
        self.bubbleFrame = [self isSelf]?CGRectMake((screenWidth-bubbleSize.width - GCAvatarViewWidth), CGRectGetMinY(self.avatarFrame), bubbleSize.width, bubbleSize.height):CGRectMake(GCAvatarViewWidth, CGRectGetMinY(self.avatarFrame), bubbleSize.width, bubbleSize.height);
    }
    
    self.textLabelFrame = [self isSelf]?CGRectMake(CGRectGetMinX(self.bubbleFrame)+ (bubbleSize.width - _textLayout.textBoundingSize.width)/2.0 - 3, CGRectGetMinY(self.bubbleFrame), _textLayout.textBoundingSize.width, CGRectGetHeight(self.bubbleFrame)):CGRectMake(CGRectGetMinX(self.bubbleFrame)+ (bubbleSize.width - _textLayout.textBoundingSize.width)/2.0 + 3, CGRectGetMinY(self.bubbleFrame), _textLayout.textBoundingSize.width, CGRectGetHeight(self.bubbleFrame));

    if (self.messageType == GCMessageTypeLocation) {
        self.bubbleImage = [GCPhotoMessageHelper cropImageWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Fav_Cell_Loc" ofType:@"png"]]WithbubbelType:self.bubbleMessageType];
    }else if(self.messageType == GCMessageTypeVideo)
    {
        self.bubbleImage = self.bubbleMessageType == GCBubbleMessageTypeSending?[YYImage imageNamed:@"senderVideoBubbleImage"]:[YYImage imageNamed:@"recevierVideoBubbleImage"];
    }else
    {
        self.bubbleImage = [GCMessageBubbleHelper bubbleImageViewWithType:self.bubbleMessageType messageType:self.messageType isAnonymous:self.isAnonymous];
    }
}

#pragma mark ----- 状态View
- (void)calculateMessageStatusViewFrame
{
    switch (self.messageType) {
        case GCMessageTypeText:
        case GCMessageTypePhoto:
        case GCMessageTypeLocation:
        case GCMessageTypeNameCard:
        {
            CGFloat statusOriginX = [self isSelf]?CGRectGetMinX(self.bubbleFrame)-10-GCMessageStatusViewWidth:CGRectGetMaxX(self.bubbleFrame)+10;
            CGFloat statisOriginY = CGRectGetMinY(self.bubbleFrame)+(CGRectGetHeight(self.bubbleFrame)-GCMessageStatusViewWidth)/2.0;
            
            self.statusFrame = CGRectMake(statusOriginX, statisOriginY, GCMessageStatusViewWidth, GCMessageStatusViewWidth);
        }
            break;
        case GCMessageTypeVideo:
        case GCMessageTypeVoice:
        {
            CGFloat statusOriginX = [self isSelf]?CGRectGetMinX(self.durationFrame)-10-GCMessageStatusViewWidth:CGRectGetMaxX(self.durationFrame)+10;
            CGFloat statisOriginY = CGRectGetMinY(self.bubbleFrame)+(CGRectGetHeight(self.bubbleFrame)-GCMessageStatusViewWidth)/2.0;
            
            self.statusFrame = CGRectMake(statusOriginX, statisOriginY, GCMessageStatusViewWidth, GCMessageStatusViewWidth);
        }
        default:
            break;
    }
    
    [self calculateSourceFrame];
}


#pragma mark ----- 来源
- (void)calculateSourceFrame
{
    if (self.sourceString) {
        CGFloat originX = self.bubbleFrame.origin.x;
        
        CGFloat originY = CGRectGetMaxY(self.bubbleFrame)+8;
        
        CGSize timeSize = [self.sourceString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]}];
        
        CGFloat width = timeSize.width>(GCMaxTextWidth + 15)?(GCMaxTextWidth + 15):timeSize.width+34;
        
        self.sourceFrame = CGRectMake(originX, originY, width, 20);
    }else
    {
        self.sourceFrame = CGRectMake(0, CGRectGetMaxY(self.bubbleFrame), 0, 0);
    }
    self.cellHeight = CGRectGetMaxY(self.sourceFrame)+GCBubbleMarginBottom;
}



#pragma mark ----- 文本消息
- (instancetype)initWithText:(NSString *)text sender:(NSString *)sender goodsInfo:(NSDictionary *)goodsInfo timeStamp:(NSInteger )timeStamp  bubbleMessageType:(GCBubbleMessageType)bubbleMessageType isAnonymous:(BOOL)isAnonymous shouldShowTimeLabel:(BOOL)shouldShowTimeLabel
{
    self = [super init];
    
    if (self) {
        
        self.text = text;
        self.senderID = sender;
        self.timeStamp = timeStamp;
        self.messageType = GCMessageTypeText;
        self.bubbleMessageType = bubbleMessageType;
        self.isAnonymous = isAnonymous;
        self.shouldShowTimeLabel = shouldShowTimeLabel;
        if (goodsInfo) {
            self.sourceString = [goodsInfo objectForKey:@"goodsName"];
            self.sourceUrl = [goodsInfo objectForKey:@"goodsUrl"];
        }
        
        [self calcuteTimeAndAvatar];
        
        [self calculateTextMessageFrame];
    }
    return self;
}
- (void)calculateTextMessageFrame
{
    NSMutableAttributedString *text = [self getAttributeStringWithText:self.text];
    
    GCTextLinePositionModifier *modifier = [GCTextLinePositionModifier new];
    
    modifier.font = [UIFont systemFontOfSize:GCMessageFontSize];
    
    modifier.paddingTop = GCTextMarginTop;
    
    modifier.paddingBottom = GCTextMarginBottom;
    
    YYTextContainer *container = [YYTextContainer new];
    
    container.size = CGSizeMake(GCMaxTextWidth, CGFLOAT_MAX);
    
    container.linePositionModifier = modifier;
    
    _textLayout = [YYTextLayout layoutWithContainer:container text:text];
    
    CGFloat textHeight = [modifier heightForLineCount:_textLayout.rowCount];
    CGFloat textWidth = GCTextMarginLeft + GCTextMarginRight + _textLayout.textBoundingSize.width;
    
    CGSize bubbleSize = CGSizeMake(textWidth >45?textWidth:45, textHeight >40?textHeight:40);

    [self calculateMessageBubbleFrameWithSize:bubbleSize];
    
    [self calculateMessageStatusViewFrame];
}


- (NSMutableAttributedString *)getAttributeStringWithText:(NSString *)string
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    text.yy_color = (self.bubbleMessageType == GCBubbleMessageTypeSending)?[UIColor whiteColor]:[UIColor blackColor];
    
    text.yy_font = [UIFont systemFontOfSize:GCMessageFontSize];
    
    // 匹配 /表情
    NSArray *emoticonResults = [[GCMessageInputViewHelper regexEmoticon] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
    NSUInteger emoClipLength = 0;
    for (NSTextCheckingResult *emo in emoticonResults) {
        if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
        NSRange range = emo.range;
        range.location -= emoClipLength;
        
        NSString *emoString = [text.string substringWithRange:range];
        
        NSString *imagePath = [GCMessageInputViewHelper emoticonDic][emoString];
        UIImage *image = [GCMessageInputViewHelper imageWithPath:imagePath];
        if (!image) continue;
        
        NSAttributedString *emoText = [NSAttributedString yy_attachmentStringWithEmojiImage:image fontSize:GCMessageFontSize];
        [text replaceCharactersInRange:range withAttributedString:emoText];
        emoClipLength += range.length - 1;
    }
    
    return text;
}

- (void)calculateTimeTextLayout
{
    self.timeString = [self getMessageTimeWithUnixTime:self.timeStamp];
    
    CGSize timeSize = [self.timeString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]}];

    self.timeFrame = CGRectMake((screenWidth-timeSize.width-10)/2.0,  GCBubbleMarginTop+8, ceil(timeSize.width+10), 20);
}


#pragma mark ----- 图片消息
- (instancetype)initWithPhoto:(UIImage *)photo thumbnailUrl:(NSString *)thumbnailUrl originPhotoUrl:(NSString *)originPhotoUrl photoSize:(CGSize)photoSize sender:(NSString *)sender timeStamp:(NSInteger)timeStamp bubbleMessageType:(GCBubbleMessageType)bubbleMessageType isAnonymous:(BOOL)isAnonymous shouldShowTimeLabel:(BOOL)shouldShowTimeLabel
{
    self = [super init];
    
    if (self) {
        
        self.originImage = photo;
        self.thumbnailUrl = [thumbnailUrl containsString:@"http://"]?thumbnailUrl:[[self getTmpPath] stringByAppendingString:thumbnailUrl];
        self.originPhotoUrl = [originPhotoUrl containsString:@"http://"]?originPhotoUrl:[[self getTmpPath] stringByAppendingString:originPhotoUrl];
        self.photoSize = photoSize;
        self.senderID = sender;
        self.timeStamp = timeStamp;
        self.messageType = GCMessageTypePhoto;
        self.bubbleMessageType = bubbleMessageType;
        self.isAnonymous = isAnonymous;
        self.shouldShowTimeLabel = shouldShowTimeLabel;
        
        if (photo) {
//            self.photo = [GCPhotoMessageHelper cropImageWithImage:photo WithbubbelType:self.bubbleMessageType];
            self.photo = photo;
        }

        [self calcuteTimeAndAvatar];
        
        [self calculatePhotoMessageFrame];
    }
    return self;
}

- (void)calculatePhotoMessageFrame
{
    CGSize bubbleSize;
    
    CGFloat imageWidth = self.photoSize.width;
    CGFloat imageHeight = self.photoSize.height;
    
    CGFloat scale;
    
    if (imageWidth ==0 && imageHeight == 0) {
        
        bubbleSize = CGSizeMake(200, 200);
    }else
    {
        if (imageWidth>imageHeight) {
            scale = 200/imageWidth;
            bubbleSize = CGSizeMake(200, scale*imageHeight);
        }else
        {
            scale = 200/imageHeight;
            bubbleSize = CGSizeMake(scale*imageWidth, 200);
        }
    }
    
    [self calculateMessageBubbleFrameWithSize:bubbleSize];
    [self calculateMessageStatusViewFrame];
}


#pragma mark ----- 语音消息
- (instancetype)initWithVoicePath:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration sender:(NSString *)sender isRead:(BOOL)isRead timeStamp:(NSInteger)timeStamp bubbleMessageType:(GCBubbleMessageType)bubbleMessageType isAnonymous:(BOOL)isAnonymous shouldShowTimeLabel:(BOOL)shouldShowTimeLabel
{
    self = [super init];
    
    if (self) {
        
        self.voicePath = voicePath;
        self.voiceDuration = voiceDuration;
        self.senderID = sender;
        self.timeStamp = timeStamp;
        self.messageType = GCMessageTypeVoice;
        self.bubbleMessageType = bubbleMessageType;
        self.isAnonymous = isAnonymous;
        self.shouldShowTimeLabel = shouldShowTimeLabel;
        self.isRead = isRead;
        
        [self calcuteTimeAndAvatar];
        [self calculateVoiceBubbleFrame];
    }
    return self;
}

- (void)calculateVoiceBubbleFrame
{
    self.voiceImage =[self isSelf]?[UIImage imageNamed:@"SenderVoiceNodePlaying003"]:[UIImage imageNamed:@"ReceiverVoiceNodePlaying003"];
    
    float gapDuration = (!self.voiceDuration || self.voiceDuration.length == 0 ? -1 : [self.voiceDuration floatValue] - 1.0f);
    CGSize voiceSize = CGSizeMake(80 + (gapDuration > 0 ? (120.0 / (60 - 1) * gapDuration) : 0), 42);
    
    [self calculateMessageBubbleFrameWithSize:voiceSize];
    
    CGFloat voiceImageOrignY = CGRectGetMinY(self.bubbleFrame)+(CGRectGetHeight(self.bubbleFrame) - 20)/2.0;
    CGFloat voiceImageOrignX = [self isSelf]?screenWidth - CGRectGetWidth(self.avatarFrame)-40:CGRectGetMaxX(self.avatarFrame)+20;
    
    self.voiceImageFrame = CGRectMake(voiceImageOrignX,voiceImageOrignY, 20, 20);
    
    
    self.durationString = [[NSString alloc] initWithFormat:@"%.1fs",[self.voiceDuration floatValue]];
    
    CGSize durationSize = [self.durationString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]}];
    
    CGFloat durationOrignX = [self isSelf]?CGRectGetMinX(self.bubbleFrame)-durationSize.width-4:CGRectGetMaxX(self.bubbleFrame)+4;
    CGFloat durationOrignY = CGRectGetMinY(self.bubbleFrame)+(CGRectGetHeight(self.bubbleFrame) - durationSize.height)/2.0;
    
    self.durationFrame = CGRectMake(durationOrignX, durationOrignY, durationSize.width, durationSize.height);
    
    
    CGFloat unReadOrignY = CGRectGetMinY(self.bubbleFrame)+(CGRectGetHeight(self.bubbleFrame) - 8)/2.0;
    CGFloat unReadOrignX = [self isSelf]?CGRectGetMinX(self.bubbleFrame)+10:CGRectGetMaxX(self.durationFrame)+8;
    
    self.unReadImageFrame = CGRectMake(unReadOrignX, unReadOrignY, 8, 8);

    
    [self calculateMessageStatusViewFrame];
}

#pragma mark ----- 位置消息
- (instancetype)initWithLocation:(CLLocation *)location geoLocation:(NSString *)geoLocations sender:(NSString *)sender timeStamp:(NSInteger)timeStamp bubbleMessageType:(GCBubbleMessageType)bubbleMessageType isAnonymous:(BOOL)isAnonymous shouldShowTimeLabel:(BOOL)shouldShowTimeLabel
{
    self = [super init];
    
    if (self) {
        self.location = location;
        self.geolocations = geoLocations;
        self.senderID = sender;
        self.timeStamp = timeStamp;
        self.messageType = GCMessageTypeLocation;
        self.bubbleMessageType = bubbleMessageType;
        self.isAnonymous = isAnonymous;
        self.shouldShowTimeLabel = shouldShowTimeLabel;
//        self.sourceString = @"世界工厂网";
        
        [self calcuteTimeAndAvatar];
        
        [self calculateLocationFrame];
    }
    
    return self;
}

- (void)calculateLocationFrame
{
    CGSize locationSize = CGSizeMake(220, 120);
    
    [self calculateMessageBubbleFrameWithSize:locationSize];
    
    CGFloat locationOriginY = CGRectGetMaxY(self.bubbleFrame)-44;
    
    CGFloat locationOriginX = [self isSelf]?CGRectGetMinX(self.bubbleFrame)+4:CGRectGetMinX(self.bubbleFrame)+GCBubbleAngleWidth+4;
    self.locationFrame = CGRectMake(locationOriginX, locationOriginY, CGRectGetWidth(self.bubbleFrame)-GCBubbleAngleWidth-8, 44);
    
    [self calculateMessageStatusViewFrame];
}
#pragma mark ----- 发送视频消息
- (instancetype)initWithVideoCoverImage:(UIImage *)videoCoverImage videoPath:(NSString *)videoPath videoDuration:(NSString *)videoDuration sender:(NSString *)sender timeStamp:(NSInteger)timeStamp bubbleMessageType:(GCBubbleMessageType)bubbleMessageType isAnonymous:(BOOL)isAnonymous shouldShowTimeLabel:(BOOL)shouldShowTimeLabel
{
    self = [super init];
    
    if (self) {
        
        self.videoPath = videoPath;
        self.videoDuration = videoDuration;
        self.senderID = sender;
        self.messageType = GCMessageTypeVideo;
        self.timeStamp = timeStamp;

        self.bubbleMessageType = bubbleMessageType;
        self.isAnonymous = isAnonymous;
        self.shouldShowTimeLabel = shouldShowTimeLabel;
        
        self.videoCoverPhoto = [GCPhotoMessageHelper cropImageWithImage:videoCoverImage WithbubbelType:self.bubbleMessageType];
        
        [self calcuteTimeAndAvatar];
        
        [self calculateVideoFrame];
    }
    return self;
}

- (void)calculateVideoFrame
{
    CGSize videoSize;
    
    CGFloat imageWidth = self.videoCoverPhoto.size.width;
    CGFloat imageHeight = self.videoCoverPhoto.size.height;
    
    CGFloat scale;
    if (imageWidth || imageHeight) {
        if (imageWidth>imageHeight) {
            scale = 200/imageWidth;
            videoSize = CGSizeMake(200, scale*imageHeight);
        }else
        {
            scale = 200/imageHeight;
            videoSize = CGSizeMake(scale*imageWidth, 200);
        }
    }else
    {
        videoSize = CGSizeMake(156, 103);
    }
    
    [self calculateMessageBubbleFrameWithSize:videoSize];
    
    CGFloat videoOriginX = CGRectGetMinX(self.bubbleFrame)+ (CGRectGetWidth(self.bubbleFrame)-40)/2.0;
    CGFloat videoOriginY = CGRectGetMinY(self.bubbleFrame)+(CGRectGetHeight(self.bubbleFrame) - 40)/2.0;
    
    self.videoCoverFrame = CGRectMake(videoOriginX, videoOriginY, 40, 40);
    
    CGSize durationSize = [self.videoDuration sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]}];
    
    CGFloat durationOrignX = [self isSelf]?CGRectGetMinX(self.bubbleFrame)-durationSize.width-10:CGRectGetMaxX(self.bubbleFrame)+10;
    
    CGFloat durationOrignY = CGRectGetMinY(self.bubbleFrame)+(CGRectGetHeight(self.bubbleFrame) - durationSize.height)/2.0;
    
    self.durationFrame = CGRectMake(durationOrignX, durationOrignY, durationSize.width, durationSize.height);
    
    [self calculateMessageStatusViewFrame];
}


#pragma mark ----- 名片信息
- (instancetype)initWithNameCard:(NSDictionary *)userInfo sender:(NSString *)sender timestamp:(NSInteger)timestamp bubbleMessageType:(GCBubbleMessageType)bubbleMessageType isAnonymous:(BOOL)isAnonymous shouldShowTimeLabel:(BOOL)shouldShowTimeLabel
{
    self = [super init];
    
    if (self) {
        self.userHeadImagUrl = userInfo[@"imgUrl"];
        self.userMobile = userInfo[@"mobile"];
        self.userTureName = userInfo[@"trueName"];
        self.isAddFriend = [userInfo[@"add"] integerValue];
        self.timeStamp = timestamp;
        self.messageType = GCMessageTypeNameCard;
        self.bubbleMessageType = bubbleMessageType;
        self.isAnonymous = isAnonymous;
        self.shouldShowTimeLabel = shouldShowTimeLabel;
        
        [self calcuteTimeAndAvatar];
     
        [self calculateNameCardFrame];
    }
    return self;
}

- (void)calculateNameCardFrame
{
    CGSize nameCardSize = CGSizeMake(215, 100);
    
    [self calculateMessageBubbleFrameWithSize:nameCardSize];
    
    self.nameCardFrame = [self isSelf]?CGRectMake(CGRectGetMinX(self.bubbleFrame), CGRectGetMinY(self.bubbleFrame), CGRectGetWidth(self.bubbleFrame)-GCBubbleAngleWidth, CGRectGetHeight(self.bubbleFrame)):CGRectMake(CGRectGetMinX(self.bubbleFrame)+GCBubbleAngleWidth, CGRectGetMinY(self.bubbleFrame), CGRectGetWidth(self.bubbleFrame)-GCBubbleAngleWidth, CGRectGetHeight(self.bubbleFrame));
    [self calculateMessageStatusViewFrame];
}

- (NSString *)getTmpPath
{
    return NSTemporaryDirectory();
}

- (NSString *)getMessageTimeWithUnixTime:(NSInteger)unixTime
{
    NSDate *nowDate = [NSDate date];
    NSInteger nowTimestamp = [nowDate timeIntervalSince1970];
    
    NSInteger currentStart = nowTimestamp-(nowTimestamp+8*3600)%(24*3600);
    
    NSInteger timeGap = currentStart-unixTime;
    
    NSString *reaultStr;
    
    NSDateFormatter* YMD = [[NSDateFormatter alloc]init];

    if(timeGap <= 0) {
        
        [YMD setDateFormat:@"HH:mm"];

        NSDate* confromPostTime = [NSDate dateWithTimeIntervalSince1970:unixTime];
        
        reaultStr= [YMD stringFromDate:confromPostTime];
        
    }else if (timeGap >0 && timeGap<=24*3600) {
        
        [YMD setDateFormat:@"HH:mm"];
        NSDate* confromPostTime = [NSDate dateWithTimeIntervalSince1970:unixTime];
        NSString *hourStr = [YMD stringFromDate:confromPostTime];
        reaultStr = [NSString stringWithFormat:@"昨天 %@",hourStr];
    }else if (timeGap>24*3600 && timeGap<=2*24*3600) {
        
        [YMD setDateFormat:@"HH:mm"];
        NSDate* confromPostTime = [NSDate dateWithTimeIntervalSince1970:unixTime];
        NSString *hourStr = [YMD stringFromDate:confromPostTime];
        reaultStr = [NSString stringWithFormat:@"前天 %@",hourStr];
    }else{
        
        [YMD setDateFormat:@"M月d日 HH:mm"];
        NSDate* confromPostTime = [NSDate dateWithTimeIntervalSince1970:unixTime];
        reaultStr = [YMD stringFromDate:confromPostTime];
    }
    return reaultStr;
}


@end
