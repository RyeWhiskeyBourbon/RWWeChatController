//
//  RWChatViewController.h
//  RWWeChatController
//
//  Created by zhongyu on 16/7/22.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWWeChatBar.h"
#import "XZMicroVideoView.h"
#import "RWMakeImageController.h"
#import <AVFoundation/AVFoundation.h>

@interface RWChatViewController : UIViewController

<
    RWWeChatBarDelegate,
    RWWeChatViewEvent,
    AVAudioPlayerDelegate,
    MicroVideoDelegate
>

@property (nonatomic,assign)CGPoint viewCenter;

@property (nonatomic,strong)AVAudioPlayer *audioPlayer;

@property (nonatomic,strong)RWWeChatBar *bar;
@property (nonatomic,strong)RWWeChatView *weChat;

@property (nonatomic,weak)RWWeChatCell *playing;
@property (nonatomic,strong)UIView *coverLayer;

@property (nonatomic,strong)NSMutableArray *messages;

@end
