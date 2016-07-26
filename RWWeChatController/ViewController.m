//
//  ViewController.m
//  RWWeChatController
//
//  Created by zhongyu on 16/7/13.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "ViewController.h"
#import "RWWeChatBar.h"
#import "XZMicroVideoView.h"
#import "RWMakeImageController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 15; i++)
    {
        RWWeChatMessage *message = [RWWeChatMessage message:@"Hello World!" type:RWMessageTypeText myMessage:i%2 messageDate:[NSDate date] showTime:NO];
        
        [arr addObject:message];
    }
    
    for (int i = 0; i < 15; i++)
    {
        RWWeChatMessage *message = [RWWeChatMessage message:[UIImage imageNamed:@"someOne.jpg"] type:RWMessageTypeImage myMessage:i%2 messageDate:nil showTime:NO];
        
        [arr addObject:message];
    }
    
    self.messages = arr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
