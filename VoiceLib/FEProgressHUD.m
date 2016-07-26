//
//  FEProgressHUD.m
//  test2
//
//  Created by zhongyu on 16/7/21.
//  Copyright © 2016年 zhongyu. All rights reserved.
//


#import "FEProgressHUD.h"
#import "Masonry.h"

@interface FEProgressHUD ()
{
    
    int angle;
    
    float numberValue;
    
    
}
@property(nonatomic,strong)UIView * feBackegroundView;
@property(nonatomic,strong) UILabel *centerLabel;
@property (nonatomic, strong, readonly) UIWindow *overlayWindow;
@property(nonatomic,strong)UIImageView * vordimageView;
@property(nonnull,strong) NSTimer * myTimer;
@end

@implementation FEProgressHUD

@synthesize overlayWindow;
@synthesize centerLabel;
@synthesize vordimageView;
@synthesize feBackegroundView;

+ (FEProgressHUD*)sharedView {
    static dispatch_once_t once;
    static FEProgressHUD *sharedView;
    dispatch_once(&once, ^ {
        
        sharedView = [[FEProgressHUD alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        //        sharedView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        
    });
    return sharedView;
}

+ (void)show {
    [[FEProgressHUD sharedView] show];
}

- (void)show {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        numberValue=60;
        if(!self.superview)
            [self.overlayWindow addSubview:self];
        
        if(!feBackegroundView){
            feBackegroundView=[[UILabel alloc]init];
        }
        
        if (!centerLabel){
            centerLabel=[[UILabel alloc]init];
            //            centerLabel.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.2];
        }
        
        if (!self.subTitleLabel){
            self.subTitleLabel = [[UILabel alloc]init];
            
        }
        if (!self.titleLabel){
            
            self.titleLabel = [[UILabel alloc]init];
            
        }
        if (!self.vordimageView) {
            vordimageView =[[UIImageView alloc]init];
            vordimageView.contentMode=UIViewContentModeScaleAspectFit;
            vordimageView.image=[UIImage imageNamed:@"microphone1"];
        }
        
        
        feBackegroundView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
        feBackegroundView.layer.masksToBounds= YES ;
        feBackegroundView.layer.cornerRadius=20.f;
        
        
        self.subTitleLabel.text = @"滑动取消录音";
        self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.subTitleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.subTitleLabel.textColor = [UIColor whiteColor];
        
        
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.titleLabel.textColor = [UIColor whiteColor];
        
        
        
        centerLabel.textAlignment = NSTextAlignmentCenter;
        centerLabel.font = [UIFont systemFontOfSize:20];
        centerLabel.textColor = [UIColor yellowColor];
        
        
        
        
        [self addSubview:feBackegroundView];
        [self addSubview:self.subTitleLabel];
        [self addSubview:self.titleLabel];
        [self addSubview:vordimageView];
        [self addSubview:centerLabel];
        
        __weak typeof(self) weakSelf = self;
        [feBackegroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.centerY.equalTo(weakSelf).offset(-50);
            make.left.equalTo(weakSelf.mas_left).offset(90);
            make.height.equalTo(@(weakSelf.frame.size.height/4));
        }];
        [centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.centerY.equalTo(weakSelf).offset(-50);
            make.left.equalTo(weakSelf.mas_left).offset(120);
            make.height.equalTo(@(weakSelf.frame.size.height/5));
        }];
        
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(feBackegroundView);
            make.top.equalTo(feBackegroundView.mas_top).offset(10);
            make.left.equalTo(feBackegroundView.mas_left).offset(15);
            make.height.equalTo(@(30));
        }];
        
        [vordimageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(feBackegroundView);
            make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(5);
            make.left.equalTo(weakSelf.titleLabel.mas_left);
            make.bottom.equalTo(weakSelf.subTitleLabel.mas_top).offset(-5);
        }];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(feBackegroundView);
            make.height.equalTo(@(30));
            make.left.equalTo(weakSelf.titleLabel.mas_left).offset(5);
            make.bottom.equalTo(feBackegroundView.mas_bottom).offset(-10);
        }];
        
        if (_myTimer)
            
            [_myTimer invalidate];
        _myTimer = nil;
        
        
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                    target:self
                                                  selector:@selector(startAnimation)
                                                  userInfo:nil
                                                   repeats:YES];
        
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             feBackegroundView.alpha = 1;
                         }
                         completion:^(BOOL finished){
                         }];
        
        [self setNeedsDisplay];
    });
}
-(void) startAnimation
{
    
    float second = numberValue;
    
    numberValue-=0.1;
    
    self.titleLabel.text = [NSString stringWithFormat:@"时间限制 %.1f秒",second-0.1];
    
    
    
}

+ (void)changeSubTitle:(NSString *)str
{
    [[FEProgressHUD sharedView] setState:str];
}

- (void)setState:(NSString *)str
{
    self.subTitleLabel.text = str;
}

+ (void)dismissWithSuccess:(NSString *)str {
    [[FEProgressHUD sharedView] dismiss:str];
}

+ (void)dismissWithError:(NSString *)str {
    [[FEProgressHUD sharedView] dismiss:str];
}

- (void)dismiss:(NSString *)state {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_myTimer invalidate];
        
        _myTimer = nil;
        
        self.subTitleLabel.text = nil;
        
        self.titleLabel.text = nil;
        
        [vordimageView removeFromSuperview];
        
        centerLabel.text = state;
        
        centerLabel.textColor = [UIColor whiteColor];
        
        
        CGFloat timeLonger;
        if ([state isEqualToString:@"时间太短"]) {
            timeLonger = 1;
        }else{
            timeLonger = 0.6;
        }
        [UIView animateWithDuration:timeLonger
                              delay:0
                            options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             
                             feBackegroundView.alpha=0;
                         }
                         completion:^(BOOL finished){
                             if(feBackegroundView.alpha==0) {
                                 
                                 [self.subTitleLabel removeFromSuperview];
                                 self.subTitleLabel = nil;
                                 [feBackegroundView removeFromSuperview];
                                 feBackegroundView=nil;
                                 [vordimageView removeFromSuperview];
                                 vordimageView=nil;
                                 [centerLabel removeFromSuperview];
                                 centerLabel = nil;
                                 NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[UIApplication sharedApplication].windows];
                                 [windows removeObject:overlayWindow];
                                 overlayWindow = nil;
                                 
                                 [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
                                     if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
                                         [window makeKeyWindow];
                                         *stop = YES;
                                     }
                                 }];
                             }
                         }];
    });
}

- (UIWindow *)overlayWindow {
    if(!overlayWindow) {
        overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayWindow.userInteractionEnabled = NO;
        [overlayWindow makeKeyAndVisible];
    }
    return overlayWindow;
    
}
+(void)getAnimationNumber:(float)number{
    
    [[FEProgressHUD sharedView] changeImage:number];
    
    
}
/**
 *改变语音图片
 * 分贝由 -160~0不等
 
 */

-(void)changeImage:(float) number{
    
    if (number<(-128)&&number>(-160)) {
        vordimageView.image=[UIImage imageNamed:@"microphone1"];
        
    }
    else if (number<(-96)&&number>(-128)) {
        vordimageView.image=[UIImage imageNamed:@"microphone2"];
        
    }
    else if (number<(-64)&&number>(-96)) {
        vordimageView.image=[UIImage imageNamed:@"microphone3"];
        
    }
    else if (number<=(-32)&&number>=(-64)) {
        vordimageView.image=[UIImage imageNamed:@"microphone4"];
        
    }
    else  {
        vordimageView.image=[UIImage imageNamed:@"microphone5"];
        
    }
    
    
}



@end
