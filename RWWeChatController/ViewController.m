//
//  ViewController.m
//  RWWeChatController
//
//  Created by zhongyu on 16/7/13.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "ViewController.h"
#import "RWWeiChatView.h"
#import "RWWeChatBar.h"

@interface ViewController ()

<
    RWWeChatBarDelegate,
    RWWeChatViewEvent
>

@property (nonatomic,assign)CGPoint viewCenter;

@property (nonatomic,strong)RWWeChatBar *bar;
@property (nonatomic,strong)RWWeChatView *weChat;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _viewCenter = self.view.center;
    
    _bar = [RWWeChatBar wechatBarWithAutoLayout:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.height.equalTo(@(49));
    }];
    
    _bar.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    _bar.delegate = self;
    
    [self.view addSubview:_bar];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 15; i++)
    {
        RWWeChatMessage *message = [RWWeChatMessage message:@"haha" type:RWMessageTypeText myMessage:i%2 messageDate:nil showTime:NO];
        
        [arr addObject:message];
    }
    
    for (int i = 0; i < 15; i++)
    {
        RWWeChatMessage *message = [RWWeChatMessage message:[UIImage imageNamed:@"someOne.jpg"] type:RWMessageTypeImage myMessage:i%2 messageDate:nil showTime:NO];
        
        [arr addObject:message];
    }
    
    _weChat = [RWWeChatView chatViewWithAutoLayout:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(_bar.mas_top).offset(0);
        
    } messages:arr];
    
    _weChat.eventSource = self;
    
    [self.view addSubview:_weChat];
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

- (void)wechatCell:(RWWeChatCell *)wechat eventWithType:(RWMessageType)type context:(id)context
{
    
}

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

- (void)sendTextMessage:(NSString *)message
{
    RWWeChatMessage *chatMessage = [RWWeChatMessage message:message
                                                       type:RWMessageTypeText
                                                  myMessage:YES
                                                messageDate:nil
                                                   showTime:NO];
    
    [_weChat addMessage:chatMessage];
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

- (void)chatBar:(RWWeChatBar *)chatBar selectedFunction:(RWPurposeMenu)function
{
    NSLog(@"%d",(int)function);
}

- (void)tapeEndAtChatBar:(RWWeChatBar *)chatBar
{
    
}

- (void)tapeBeginAtChatBar:(RWWeChatBar *)chatBar
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
