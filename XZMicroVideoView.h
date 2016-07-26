//
//  XZMicroVideoView.h
//  Protice
//
//  Created by ZYJY on 16/7/14.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MicroVideoDelegate <NSObject>

- (void)touchUpDone:(NSString *)savePath;
- (void)videoViewWillRemoveFromSuperView;

@end

@interface XZMicroVideoView : UIImageView
{
    UIButton        *_recordBtn;
    UIButton        *_cancelBtn;
    UIView          *_upSlidePanel;
    UIImageView     *_upSlidePic;
    UILabel         *_upSlideText;
    UIImageView     *_touchUpCancel;
    UIView          *_progressView;
    UIImageView     *_focusView;
    NSTimer         *_timer;
}

@property (nonatomic, weak) id<MicroVideoDelegate> delegate;

@property (nonatomic, strong) NSTimer *timer;

@end
