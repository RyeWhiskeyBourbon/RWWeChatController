//
//  UIImage+XZMicroVideoPlayer.m
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/7/22.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "UIImage+XZMicroVideoPlayer.h"
@import AVFoundation;

@implementation UIImage (XZMicroVideoPlayer)

+ (UIImage *)xz_previewImageWithVideoURL:(NSURL *)videoURL {
    
    AVAsset *asset = [AVAsset assetWithURL:videoURL];
    
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(1, asset.duration.timescale) actualTime:NULL error:nil];
    UIImage *image = [UIImage imageWithCGImage:img];
    
    CGImageRelease(img);
    return image;
}


@end
