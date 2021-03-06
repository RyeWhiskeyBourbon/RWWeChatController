//
//  RWChatViewController.m
//  RWWeChatController
//
//  Created by zhongyu on 16/7/22.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWChatViewController.h"

@implementation RWChatViewController

#pragma mark - chatView - delegate

- (void)wechatCell:(RWWeChatCell *)wechat event:(RWMessageEvent)event context:(id)context
{
    switch (event)
    {
        case RWMessageEventTapImage:
        {
            [_bar.makeTextMessage.textView resignFirstResponder];
            
            if (_bar.faceResponceAccessory == RWChatBarButtonOfExpressionKeyboard)
            {
                self.view.center = _viewCenter;
                
                [UIView animateWithDuration:1.f animations:^{
                    
                    _bar.inputView.frame = __KEYBOARD_FRAME__;
                    
                    [_bar.inputView removeFromSuperview];
                }];
            }
            else if (_bar.faceResponceAccessory == RWChatBarButtonOfOtherFunction)
            {
                self.view.center = _viewCenter;
                
                [UIView animateWithDuration:1.f animations:^{
                    
                    _bar.purposeMenu.frame = __KEYBOARD_FRAME__;
                    
                    [_bar.purposeMenu removeFromSuperview];
                }];
            }
            
            [RWPhotoAlbum photoAlbumWithImage:context];
            
            break;
        }
        case RWMessageEventTapVoice:
        {
            if (_audioPlayer)
            {
                [_audioPlayer stop];
                
                if (_audioPlayer.data == context)
                {
                    _audioPlayer = nil;
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [wechat.voiceButton.playAnimation stopAnimating];
                    });
                    
                    return;
                }
                
                if (_playing)
                {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        if (_playing.voiceButton.playAnimation.isAnimating)
                        {
                            [_playing.voiceButton.playAnimation stopAnimating];
                        }
                        
                        _playing = nil;
                        
                        CFRunLoopRef runLoopRef = CFRunLoopGetCurrent();
                        CFRunLoopStop(runLoopRef);
                    });
                    
                    CFRunLoopRun();
                }
                
                _audioPlayer = nil;
            }
            
            _audioPlayer = [[AVAudioPlayer alloc] initWithData:context error:nil];
            _audioPlayer.delegate = self;
            
            _playing = wechat;
            [_audioPlayer play];
            
            break;
        }
            
        default:
            break;
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    _audioPlayer = nil;
}

- (void)touchSpaceAtwechatView:(RWWeChatView *)wechatView
{
    [_bar.makeTextMessage.textView resignFirstResponder];
    
    if (_bar.faceResponceAccessory == RWChatBarButtonOfExpressionKeyboard)
    {
        self.view.center = _viewCenter;
        
        [UIView animateWithDuration:1.f animations:^{
            
            _bar.inputView.frame = __KEYBOARD_FRAME__;
            
            [_bar.inputView removeFromSuperview];
        }];
    }
    else if (_bar.faceResponceAccessory == RWChatBarButtonOfOtherFunction)
    {
        self.view.center = _viewCenter;
        
        [UIView animateWithDuration:1.f animations:^{
            
            _bar.purposeMenu.frame = __KEYBOARD_FRAME__;
            
            [_bar.purposeMenu removeFromSuperview];
        }];
    }
}

#pragma mark - bar - delegate - FitSize

- (void)keyBoardWillShowWithSize:(CGSize)size
{
    if (self.view.center.y != _viewCenter.y) { return; }
    
    CGPoint pt = self.view.center;
    
    pt.y -= size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.view.center = pt;
    }];
}

- (void)keyBoardWillHidden
{
    [UIView animateWithDuration:0.5 animations:^{
        
        self.view.center = _viewCenter;
    }];
}

- (void)openAccessoryInputViewAtChatBar:(RWWeChatBar *)chatBar
{
    if (chatBar.purposeMenu.superview)
    {
        self.view.center = _viewCenter;
        chatBar.purposeMenu.frame = __KEYBOARD_FRAME__;
        
        [chatBar.purposeMenu removeFromSuperview];
    }
    
    [self.view.window addSubview:chatBar.inputView];
    
    if (self.view.center.y != _viewCenter.y)
    {
        self.view.center = _viewCenter;
        chatBar.inputView.frame = __KEYBOARD_FRAME__;
        
        [chatBar.inputView removeFromSuperview];
        
        return;
    }
    
    CGPoint pt = self.view.center , inputViewPt = chatBar.inputView.center;
    
    pt.y -= chatBar.inputView.frame.size.height;
    inputViewPt.y -= chatBar.inputView.frame.size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        chatBar.inputView.center = inputViewPt;
        self.view.center = pt;
    }];
}

- (void)openMultiPurposeMenuAtChatBar:(RWWeChatBar *)chatBar
{
    if (chatBar.inputView.superview)
    {
        self.view.center = _viewCenter;
        chatBar.inputView.frame = __KEYBOARD_FRAME__;
        
        [chatBar.inputView removeFromSuperview];
    }
    
    [self.view.window addSubview:chatBar.purposeMenu];
    
    if (self.view.center.y != _viewCenter.y)
    {
        self.view.center = _viewCenter;
        chatBar.purposeMenu.frame = __KEYBOARD_FRAME__;
        
        [chatBar.purposeMenu removeFromSuperview];
        
        return;
    }
    
    CGPoint pt = self.view.center , purposeMenuPt = chatBar.purposeMenu.center;
    
    pt.y -= chatBar.purposeMenu.frame.size.height;
    purposeMenuPt.y -= chatBar.purposeMenu.frame.size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        chatBar.purposeMenu.center = purposeMenuPt;
        self.view.center = pt;
    }];
}

#pragma mark - bar - textView

- (void)beginEditingTextAtChatBar:(RWWeChatBar *)chatBar
{
    if (chatBar.faceResponceAccessory == RWChatBarButtonOfExpressionKeyboard)
    {
        self.view.center = _viewCenter;
        chatBar.inputView.frame = __KEYBOARD_FRAME__;
        
        [chatBar.inputView removeFromSuperview];
    }
    else if (chatBar.faceResponceAccessory == RWChatBarButtonOfOtherFunction)
    {
        self.view.center = _viewCenter;
        chatBar.purposeMenu.frame = __KEYBOARD_FRAME__;
        
        [chatBar.purposeMenu removeFromSuperview];
    }
}

#pragma mark - bar - PurposeMenu

- (void)chatBar:(RWWeChatBar *)chatBar selectedFunction:(RWPurposeMenu)function
{
    NSLog(@"%d",(int)function);
    
    switch (function)
    {
        case RWPurposeMenuOfPhoto:
        {
            RWMakeImageController *makeImage = [RWMakeImageController makeImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary didSelectedImage:^(UIImage *image) {
                
                [self sendMessage:image type:RWMessageTypeImage];
            }];
            
            if (makeImage)
            {
                [self presentViewController:makeImage animated:YES completion:nil];
            }
            else
            {
                // alert
            }
            
            break;
        }
        case RWPurposeMenuOfCamera:
        {
            RWMakeImageController *makeImage = [RWMakeImageController makeImageWithSourceType:UIImagePickerControllerSourceTypeCamera didSelectedImage:^(UIImage *image) {
                
                [self sendMessage:image type:RWMessageTypeImage];
                
                [makeImage dismissViewControllerAnimated:YES completion:nil];
            }];
            
            if (makeImage)
            {
                [self presentViewController:makeImage animated:YES completion:nil];
            }
            else
            {
                // alert
            }
            
            break;
        }
        case RWPurposeMenuOfMyCard:break;
        case RWPurposeMenuOfCollect:break;
        case RWPurposeMenuOfLocation:break;
        case RWPurposeMenuOfVideoCall:break;
        case RWPurposeMenuOfSmallVideo: [self makeSmallVideo]; break;
            
        default:
            break;
    }
    
    self.view.center = _viewCenter;
    chatBar.purposeMenu.frame = __KEYBOARD_FRAME__;
    
    [chatBar.purposeMenu removeFromSuperview];
}

#pragma mark - video

- (void)makeSmallVideo
{
    [self.view addSubview:_coverLayer];
    
    CGFloat selfWidth  = self.view.bounds.size.width;
    CGFloat selfHeight = self.view.bounds.size.height;
    XZMicroVideoView *microVideoView = [[XZMicroVideoView alloc] initWithFrame:CGRectMake(0, selfHeight/3, selfWidth, selfHeight * 2/3)];
    microVideoView.delegate = self;
    
    [self.view addSubview:microVideoView];
}

#pragma mark - video - MicroVideoDelegate

- (void)touchUpDone:(NSString *)savePath
{
    RWWeChatMessage *chatMessage = [RWWeChatMessage message:savePath
                                                       type:RWMessageTypeVideo
                                                  myMessage:YES
                                                messageDate:[NSDate date]
                                                   showTime:NO];
    [_weChat addMessage:chatMessage];
}

- (void)videoViewWillRemoveFromSuperView
{
    [_coverLayer removeFromSuperview];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _viewCenter = self.view.center;
    _coverLayer = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _coverLayer.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    
    _bar = [RWWeChatBar wechatBarWithAutoLayout:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.height.equalTo(@(49));
    }];
    
    _bar.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    _bar.delegate = self;
    
    [self.view addSubview:_bar];
    
    _weChat = [RWWeChatView chatViewWithAutoLayout:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(_bar.mas_top).offset(0);
        
    } messages:_messages];
    
    _weChat.eventSource = self;
    
    [self.view addSubview:_weChat];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

- (void)setMessages:(NSMutableArray *)messages
{
    _messages = messages;
    
    if (_weChat)
    {
        _weChat.messages = _messages;
    }
}

#pragma mark - send message

- (void)sendMessage:(id)message type:(RWMessageType)type
{
    RWWeChatMessage *chatMessage = [RWWeChatMessage message:message
                                                       type:type
                                                  myMessage:YES
                                                messageDate:[NSDate date]
                                                   showTime:NO];
    
    [_weChat addMessage:chatMessage];
}

@end
