//
//  RWWeiChatView.h
//  RWWeChatController
//
//  Created by zhongyu on 16/7/13.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

#ifndef __RWCHAT_FONT__
#define __RWCHAT_FONT__ [UIFont systemFontOfSize:15]
#endif

#ifndef __RWGET_SYSFONT
#define __RWGET_SYSFONT(size) [UIFont systemFontOfSize:(size)]
#endif

#ifndef __MAIN_SCREEN_WIDTH__
#define __MAIN_SCREEN_WIDTH__ [UIScreen mainScreen].bounds.size.width
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
#define __TEXT_LENGHT__ __MAIN_SCREEN_WIDTH__ - (__MARGINS__ + __HEADER_SIZE__ +__ARROWHEAD_SIZE__ + 5.f) * 2
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

#ifndef __RWGET_COLOR
#define __RWGET_COLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:(a)]
#endif

@class RWWeChatMessage ,RWWeChatView,RWWeChatCell;

typedef NS_ENUM(NSInteger,RWMessageType)
{
    RWMessageTypeText,
    RWMessageTypeVoice,
    RWMessageTypeImage,
    RWMessageTypeVideo
};

NSString *getKey(RWMessageType type);
NSString *getDate(NSDate *messageDate);

CGSize getFitSize(NSString *text,UIFont *font,CGFloat width,CGFloat lines);
CGSize getFitImageSize(UIImage *image);

@protocol RWWeChatViewEvent <NSObject>

- (void)wechatCell:(RWWeChatCell *)wechat eventWithType:(RWMessageType)type context:(id)context;

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

+ (instancetype)message:(id)message type:(RWMessageType)type myMessage:(BOOL)isMyMessage messageDate:(NSDate *)messageDate;

@property (nonatomic,assign)RWMessageType messageType;

@property (nonatomic,assign)BOOL isMyMessage;
@property (nonatomic,assign,readonly)BOOL showTime;
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

@interface RWWeChatCell :UITableViewCell

@property (nonatomic,assign)id<RWWeChatViewEvent> eventSource;

@property (nonatomic,strong)RWWeChatMessage *message;

@end

@interface UIImage (changeColor)

- (UIImage *)imageWithColor:(UIColor *)color;

@end
