//
//  RWWeiChatView.h
//  RWWeChatController
//
//  Created by zhongyu on 16/7/13.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "XZMicroVideoPlayerView.h"

#ifndef __RWCHAT_FONT__
#define __RWCHAT_FONT__ [UIFont systemFontOfSize:15]
#endif

#ifndef __RWGET_SYSFONT
#define __RWGET_SYSFONT(size) [UIFont systemFontOfSize:(size)]
#endif

#ifndef __MAIN_SCREEN_WIDTH__
#define __MAIN_SCREEN_WIDTH__ [UIScreen mainScreen].bounds.size.width
#endif

#ifndef __MAIN_SCREEN_HEIGHT__
#define __MAIN_SCREEN_HEIGHT__ [UIScreen mainScreen].bounds.size.height
#endif

#ifndef __MARGINS__
#define __MARGINS__ 10.f
#endif

#ifndef __TIME_MARGINS__
#define __TIME_MARGINS__ 3.f
#endif

#ifndef __TEXT_MARGINS__
#define __TEXT_MARGINS__ 10.f
#endif

#ifndef __HEADER_SIZE__
#define __HEADER_SIZE__ 40.f
#endif

#ifndef __ARROWHEAD_SIZE__
#define __ARROWHEAD_SIZE__ 10.f
#endif

#ifndef __CELL_LENGTH__
#define __CELL_LENGTH__ 60.f
#endif

#ifdef __MAIN_SCREEN_WIDTH__
#ifdef __MARGINS__
#ifdef __HEADER_SIZE__
#ifdef __ARROWHEAD_SIZE__
#ifndef __TEXT_LENGHT__
#define __TEXT_LENGHT__ (__MAIN_SCREEN_WIDTH__ - (__MARGINS__ + __HEADER_SIZE__ +__ARROWHEAD_SIZE__ + 5.f) * 2)
#endif
#endif
#endif
#endif
#endif

#ifdef __TEXT_LENGHT__
#ifndef __PICxVID_MAX_WIDTH__
#define __PICxVID_MAX_WIDTH__ __TEXT_LENGHT__
#endif
#endif

#ifndef __PICxVID_MAX_HEIGHT__
#define __PICxVID_MAX_HEIGHT__ 180.0f
#endif

#ifdef __MAIN_SCREEN_WIDTH__
#ifdef __MAIN_SCREEN_HEIGHT__
#ifndef __VIDEO_ORIGINAL_SIZE__
#define __VIDEO_ORIGINAL_SIZE__ CGSizeMake(__MAIN_SCREEN_WIDTH__, __MAIN_SCREEN_HEIGHT__ /3)
#endif
#endif
#endif

#ifdef __TEXT_LENGHT__
#ifndef __VOICE_MAX_OFFSET__
#define __VOICE_MAX_OFFSET__ __TEXT_LENGHT__ + __MARGINS__ + __HEADER_SIZE__ + __ARROWHEAD_SIZE__ + 5.f - 60.f
#endif
#ifndef __VOICE_LENTH
#define __VOICE_LENTH(scale) __TEXT_LENGHT__ * (1.0f - scale)
#endif
#endif

#ifndef __RWGET_COLOR
#define __RWGET_COLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:(a)]
#endif

@class RWWeChatMessage ,RWWeChatView,RWWeChatCell;
typedef NS_ENUM(NSInteger,RWTextMenuType);

typedef NS_ENUM(NSInteger,RWMessageType)
{
    RWMessageTypeText,
    RWMessageTypeVoice,
    RWMessageTypeImage,
    RWMessageTypeVideo
};

typedef NS_ENUM(NSInteger,RWMessageEvent)
{
    RWMessageEventPressText,
    RWMessageEventPressImage,
    RWMessageEventPressVoice,
    RWMessageEventPressVideo,
    RWMessageEventTapImage,
    RWMessageEventTapVoice,
    RWMessageEventTapVideo
};

NSString *getKey(RWMessageType type);
NSString *getDate(NSDate *messageDate);

CGSize getFitSize(NSString *text,UIFont *font,CGFloat width,CGFloat lines);
CGSize getFitImageSize(UIImage *image);
CGFloat getArrowheadX(RWWeChatCell *cell);
CGRect getFitVideoSize(CGSize originalSize,BOOL isMyMessage);

@protocol RWWeChatViewEvent <NSObject>
@optional

- (void)wechatCell:(RWWeChatCell *)wechat event:(RWMessageEvent)event context:(id)context;

- (void)touchSpaceAtwechatView:(RWWeChatView *)wechatView;

@end

@interface RWWeChatView : UITableView

+ (instancetype)chatViewWithAutoLayout:(void (^)(MASConstraintMaker *))autoLayout messages:(NSArray *)messages;

@property (nonatomic,strong)NSMutableArray *messages;

@property (nonatomic,assign)id<RWWeChatViewEvent> eventSource;

- (void)setAutoLayout:(void (^)(MASConstraintMaker *))autoLayout;

- (void)addMessage:(RWWeChatMessage *)message;
- (void)removeMessage:(RWWeChatMessage *)message;

@end

@interface RWWeChatMessage : NSObject

+ (instancetype)message:(id)message type:(RWMessageType)type myMessage:(BOOL)isMyMessage messageDate:(NSDate *)messageDate showTime:(BOOL)showTime;

@property (nonatomic,assign)RWMessageType messageType;

@property (nonatomic,assign)BOOL isMyMessage;
@property (nonatomic,assign)BOOL showTime;
@property (nonatomic,assign,readonly)CGFloat itemHeight;

@property (nonatomic,strong)NSDate *messageDate;
@property (nonatomic,strong,readonly)NSString *dateString;

@property (nonatomic,strong)NSDictionary<NSString *,id> *message;

@end

@interface RWMarginsLabel : UIView

@property (nonatomic,strong)UILabel *textLabel;
@property (nonatomic,assign)CGFloat margins;

@property (nonatomic,copy,readonly)void(^autoLayout)(MASConstraintMaker *make);

- (void)setAutoLayout:(void(^)(MASConstraintMaker *make))autoLayout;

@end

@interface RWVoicePlayButton : UIButton

@property (nonatomic,strong,readonly)UIImageView *playAnimation;
@property (nonatomic,strong)UILabel *second;

@property (nonatomic,copy,readonly)void(^autoLayout)(MASConstraintMaker *make);
@property (nonatomic,assign)BOOL isMyMessage;

- (void)setAutoLayout:(void(^)(MASConstraintMaker *make))autoLayout isMyMessage:(BOOL)isMyMessage;

@end

@interface RWWeChatCell :UITableViewCell

@property (nonatomic,assign)id<RWWeChatViewEvent> eventSource;

@property (nonatomic,strong)RWWeChatMessage *message;

@property (nonatomic,strong,readonly)RWMarginsLabel *contentLabel;
@property (nonatomic,strong,readonly)RWVoicePlayButton *voiceButton;
@property (nonatomic,strong,readonly)UIImageView *contentImage;
@property (nonatomic,strong,readonly)XZMicroVideoPlayerView *videoPlayer;


@end

@interface RWChatMenuView : UIView

+ (instancetype)menuWithFrame:(CGRect)frame order:(void (^)(RWTextMenuType type))order message:(RWWeChatMessage *)message arrowheadDistance:(CGFloat)arrowheadDistance;

@property (nonatomic,strong)RWWeChatMessage *message;

@end

typedef NS_ENUM(NSInteger,RWTextMenuType)
{
    RWTextMenuTypeOfCopy,
    RWTextMenuTypeOfRelay,
    RWTextMenuTypeOfCollect,
    RWTextMenuTypeOfDelete
};

@interface RWTextMenu : UICollectionView

+ (instancetype)textMenuWithFrame:(CGRect)frame responseOrder:(void (^)(RWTextMenuType type))order isText:(BOOL)isText;

@property (nonatomic,assign)BOOL isText;

@end

@interface RWTextMenuCell : UICollectionViewCell

@property (nonatomic,strong)UILabel *textLabel;

@end

@interface UIImage (changeColor)

- (UIImage *)imageWithColor:(UIColor *)color;

@end

@interface RWPhotoAlbum : UICollectionView

+ (instancetype)photoAlbumWithImage:(UIImage *)image;

@property (nonatomic,strong)UIImage *faceImage;

@end

@protocol RWPhotoAlbumCellDelegate <NSObject>

- (void)closeFaceView;

@end

@interface RWPhotoAlbumCell : UICollectionViewCell

@property (nonatomic,strong)UIImage *image;
@property (nonatomic,assign)id<RWPhotoAlbumCellDelegate> delegate;

@end

