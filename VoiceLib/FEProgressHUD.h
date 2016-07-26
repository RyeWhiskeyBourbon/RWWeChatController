//
//  FEProgressHUD.h
//  test2
//
//  Created by zhongyu on 16/7/21.
//  Copyright © 2016年 zhongyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FEProgressHUD : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

+ (void)show;

+ (void)dismissWithSuccess:(NSString *)str;

+ (void)dismissWithError:(NSString *)str;

+ (void)changeSubTitle:(NSString *)str;

+(void)getAnimationNumber:(float) number;

@end
