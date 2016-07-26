//
//  FEButton.m
//  test1
//
//  Created by zhongyu on 16/7/13.
//  Copyright © 2016年 zhongyu. All rights reserved.
//

#import "FEButton.h"
#import "Mp3Recorder.h"
#import "Masonry.h"
#import "FEProgressHUD.h"

@interface FEButton()   <Mp3RecorderDelegate>
{
    BOOL isbeginVoiceRecord;
    
    Mp3Recorder *MP3;
    
    NSInteger playTime;
    
    NSTimer *playTimer;
        
    UILabel *placeHold;
    
}

@end


@implementation FEButton



-(id)initWithSuperView:(UIView *)superView setBackgroundImage:(UIImage *)backgroundImage
{
    self=[super initWithFrame:superView.bounds];
    
    if (self)
    {
        self=[self createButtonWithBackgroundImage:backgroundImage];
        
         MP3 = [[Mp3Recorder alloc]initWithDelegate:self];
     
    }
    
    return self;
}
    
- (FEButton *)createButtonWithBackgroundImage:(UIImage *)backgroundImage
{
    
//    if (backgroundImage==nil)
//    {
//        [self setBackgroundImage:[UIImage imageNamed:@"chat_message_back"] forState:(UIControlStateNormal)];
//    }
//    else
//    {
//        [self setBackgroundImage:backgroundImage forState:(UIControlStateNormal)];
//    }
    
//    
//    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    
//    [self setTitleColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
//    
//    [self setTitle:@"开始录音" forState:UIControlStateNormal];
//    
//    [self setTitle:@"松开发送" forState:UIControlStateHighlighted];
    
    [self addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
    
    [self addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    
    [self addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
    
    [self addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    self.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
   
 
    return self;
}


#pragma mark - 录音touch事件
- (void)beginRecordVoice:(UIButton *)button
{
    button.backgroundColor = __BORDER_COLOR__;
    
    [button setTitle:@"松开  发送" forState:UIControlStateNormal];
    [button setTitleColor:self.superview.backgroundColor
                 forState:UIControlStateNormal];
    
    [MP3 startRecord];
    playTime = 0;
    playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
    [FEProgressHUD show];
    [MP3 addObserver:self forKeyPath:@"power" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
    
}

- (void)endRecordVoice:(UIButton *)button
{
    button.backgroundColor = self.superview.backgroundColor;
    
    [button setTitle:@"按住  说话"  forState:UIControlStateNormal];
    
    [button setTitleColor:__BORDER_COLOR__ forState:UIControlStateNormal];
    
    self.userInteractionEnabled=YES;
    if (playTimer) {
        [MP3 stopRecord];
        [playTimer invalidate];
        playTimer = nil;
    }
}

- (void)cancelRecordVoice:(UIButton *)button
{
    button.backgroundColor = self.superview.backgroundColor;
    
    [button setTitle:@"按住  说话"  forState:UIControlStateNormal];
    
    [button setTitleColor:__BORDER_COLOR__ forState:UIControlStateNormal];
    
    self.userInteractionEnabled=YES;
    if (playTimer) {
        [MP3 cancelRecord];
        [playTimer invalidate];
        playTimer = nil;
    }
    [FEProgressHUD dismissWithError:@"取消发送"];
}

- (void)RemindDragExit:(UIButton *)button
{
    [self setTitle:@"松开取消录音" forState:(UIControlStateNormal)];
    
    self.userInteractionEnabled=NO;
    
    [FEProgressHUD changeSubTitle:@"松开取消录音"];
}

- (void)RemindDragEnter:(UIButton *)button
{
    [FEProgressHUD changeSubTitle:@"滑动取消录音"];
}


- (void)countVoiceTime
{
    playTime ++;
    if (playTime>=59) {
        [self endRecordVoice:nil];
    }
}
#pragma mark - Mp3RecorderDelegate

//回调录音资料
- (void)endConvertWithData:(NSData *)voiceData
{
    [self.delegate sendVoice:voiceData time:playTime+1];
    [FEProgressHUD dismissWithSuccess:@"发送成功"];
    
    //缓冲消失时间 (最好有block回调消失完成)
    self.enabled = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.enabled = YES;
    });
}

- (void)failRecord
{
    [FEProgressHUD dismissWithSuccess:@"时间太短"];
    
    //缓冲消失时间 (最好有block回调消失完成)
    self.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    self.enabled = YES;
    });
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"power"]) {
        
        [FEProgressHUD getAnimationNumber:[[change objectForKey:@"new"] floatValue]];
        
    }
    
}
-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"power"];//移除监听
}
-(void)beginConvert{
    
    
}
@end
