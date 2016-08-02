//
//  UIImage+XZMicroVideoPlayer.h
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/7/22.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVAsset;


@interface UIImage (XZMicroVideoPlayer)

+ (UIImage *)xz_previewImageWithVideoURL:(NSURL *)videoURL;

@end
