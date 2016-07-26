//
//  FEButton.h
//  test1
//
//  Created by zhongyu on 16/7/13.
//  Copyright © 2016年 zhongyu. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef __BORDER_COLOR__
#define __BORDER_COLOR__ [UIColor grayColor]
#endif

@protocol FEButtonViewDelegate <NSObject>
/**
 *  语音回调方法
 *  @param voice  语音片段
 *  @param second 语音时间
 */
- (void) sendVoice:(NSData *)voice time:(NSInteger)second;


@end

@interface FEButton : UIButton



@property(nonatomic,assign)id<FEButtonViewDelegate>delegate;
/**
 *  创建录音框
 *
 *  @param superView       将要加载的视图
 *  @param backgroundIamge 北京图片，没有可设为nil
 *
 */


-(id)initWithSuperView:(UIView *)superView setBackgroundImage:(UIImage *)backgroundImage;

@end
