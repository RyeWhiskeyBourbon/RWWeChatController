//
//  RWWeChatBar.h
//  RWWeChatController
//
//  Created by zhongyu on 16/7/15.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

#ifndef __RWGET_SYSFONT
#define __RWGET_SYSFONT(size) [UIFont systemFontOfSize:(size)]
#endif

#ifndef __BORDER_COLOR__
#define __BORDER_COLOR__ [UIColor grayColor]
#endif

#ifndef __MAIN_SCREEN_WIDTH__
#define __MAIN_SCREEN_WIDTH__ [UIScreen mainScreen].bounds.size.width
#endif

#ifndef __MAIN_SCREEN_HEIGHT__
#define __MAIN_SCREEN_HEIGHT__ [UIScreen mainScreen].bounds.size.height
#endif

#ifndef __SCREEN_320x480_INCH__
#define __SCREEN_320x480_INCH__ (__MAIN_SCREEN_WIDTH__ == 320 && __MAIN_SCREEN_HEIGHT__ == 480)
#endif
#ifndef __SCREEN_320x568_INCH__
#define __SCREEN_320x568_INCH__ (__MAIN_SCREEN_WIDTH__ == 320 && __MAIN_SCREEN_HEIGHT__ == 568)
#endif
#ifndef __SCREEN_375x667_INCH__
#define __SCREEN_375x667_INCH__ (__MAIN_SCREEN_WIDTH__ == 375 && __MAIN_SCREEN_HEIGHT__ == 667)
#endif
#ifndef __SCREEN_414x763_INCH__
#define __SCREEN_414x763_INCH__ (__MAIN_SCREEN_WIDTH__ == 414 && __MAIN_SCREEN_HEIGHT__ == 763)
#endif
#ifndef __SCREEN_768x1024_INCH__
#define __SCREEN_768x1024_INCH__ (__MAIN_SCREEN_WIDTH__ == 768 && __MAIN_SCREEN_HEIGHT__ == 1024)
#endif
#ifndef __SCREEN_1024x1366_INCH__
#define __SCREEN_1024x1366_INCH__ (__MAIN_SCREEN_WIDTH__ == 1024 && __MAIN_SCREEN_HEIGHT__ == 1366)
#endif

#ifndef __KEYBOARD_HEIGHT__
#define __KEYBOARD_HEIGHT__
#endif

#ifndef __KEYBOARD_SIZE__
#define __KEYBOARD_SIZE__ CGSizeMake(__MAIN_SCREEN_WIDTH__, 216.f)
#endif

#ifndef __KEYBOARD_POINT__
#define __KEYBOARD_POINT__ CGPointMake(0.f,__MAIN_SCREEN_HEIGHT__)
#endif

#ifndef __RWGET_FRAME
#define __RWGET_FRAME(point,size) CGRectMake(point.x, point.y, size.width, size.height)
#endif

#ifndef __KEYBOARD_FRAME__
#define __KEYBOARD_FRAME__ __RWGET_FRAME(__KEYBOARD_POINT__,__KEYBOARD_SIZE__)
#endif

@class RWWeChatBar,RWTextField;
@class RWAccessoryInputView,RWAccessoryPurposeMenu;

typedef NS_ENUM(NSInteger,RWChatBarButton)
{
    RWChatBarButtonNone = 0,
    
    RWChatBarButtonOfMessageType = 1,
    RWChatBarButtonOfExpressionKeyboard = 2,
    RWChatBarButtonOfOtherFunction = 3
};

@protocol RWWeChatBarDelegate <NSObject>
@optional

- (void)tapeBeginAtChatBar:(RWWeChatBar *)chatBar;
- (void)tapeEndAtChatBar:(RWWeChatBar *)chatBar;

- (void)beginEditingTextAtChatBar:(RWWeChatBar *)chatBar;
- (void)sendTextMessage:(NSString *)message;

- (void)openAccessoryInputViewAtChatBar:(RWWeChatBar *)chatBar;
- (void)openMultiPurposeMenuAtChatBar:(RWWeChatBar *)chatBar;

- (void)keyBoardWillShowWithSize:(CGSize)size;
- (void)keyBoardWillHidden;

@end

@interface RWWeChatBar : UIView

+ (instancetype)wechatBarWithAutoLayout:(void(^)(MASConstraintMaker *))autoLayout;

- (void)setAutoLayout:(void (^)(MASConstraintMaker *))autoLayout;

@property (nonatomic,assign,readonly)BOOL isTextMessage;

@property (nonatomic,strong)RWAccessoryPurposeMenu *purposeMenu;
@property (nonatomic,strong)RWAccessoryInputView *inputView;

@property (nonatomic,assign,readonly)RWChatBarButton faceResponceAccessory;

@property (nonatomic,assign)id<RWWeChatBarDelegate> delegate;
@property (nonatomic,strong)RWTextField *makeTextMessage;

@end

@interface RWTextField : UIView

+ (instancetype)textFieldWithAutoLayout:(void(^)(MASConstraintMaker *))autoLayout margins:(CGFloat)margins;

@property (nonatomic,strong)UITextView *textView;

@property (nonatomic,assign,readonly)CGFloat margins;
@property (nonatomic,copy,readonly)void (^autoLayout)(MASConstraintMaker *);

@property (nonatomic,assign)id<RWWeChatBarDelegate> delegate;

- (void)setMargins:(CGFloat)margins;
- (void)setAutoLayout:(void (^)(MASConstraintMaker *))autoLayout;

@end

typedef NS_ENUM(NSInteger,RWPurposeMenu)
{
    RWPurposeMenuOf
};

@protocol RWAccessoryDelegate <NSObject>
@optional

- (void)accessoryInputView:(RWAccessoryInputView *)inputView selectedItem:(NSString *)item indexPath:(NSIndexPath *)indexPath;

- (void)accessoryPurposeMenu:(RWAccessoryPurposeMenu *)purposeMenu selectedFunction:(RWPurposeMenu)function;

@end

@interface RWAccessoryBaseView : UIView

<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic,strong)UICollectionView *inputView;

@property (nonatomic,strong)UIPageControl *pageView;

@property (nonatomic,assign)id<RWAccessoryDelegate> delegate;

@end

@interface RWAccessoryInputView : RWAccessoryBaseView

+ (instancetype)accessoryInputViewWithFrame:(CGRect)frame;

@property (nonatomic,strong)NSArray *resource;

@end

@interface RWAccessoryPurposeMenu : RWAccessoryBaseView

+ (instancetype)accessoryPurposeMenuWithFrame:(CGRect)frame;

@property (nonatomic,strong)NSArray *resource;

@end

@interface RWInputViewCell : UICollectionViewCell

@property (nonatomic,strong)UILabel *item;
@end

@interface RWPurposeMenuCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UILabel *title;
@end
