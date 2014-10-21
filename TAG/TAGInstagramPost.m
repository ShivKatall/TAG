//
//  TAGInstagramPost.m
//  TAG
//
//  Created by Cole Bratcher on 8/12/14.
//  Copyright (c) 2014 TAG. All rights reserved.
//

#import "TAGInstagramPost.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>

@implementation TAGInstagramPost

- (void)downloadImageWithCompletionBlock:(void (^)())completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSURL *imageURL = [NSURL URLWithString:_imageURL];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        _image = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion();
        });
    });
}

- (void)createThumbnailWithCompletionBlock:(void (^)())completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSURL *videoURL = [NSURL URLWithString:_videoURL];
        
        // Code by Jim Tierney for getting thumbnail: http://stackoverflow.com/a/19126159/3871050
        
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
        AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        generator.appliesPreferredTrackTransform = YES;
        NSError *error = NULL;
        CMTime time = CMTimeMake(1, 2);
        CGImageRef imageReference = [generator copyCGImageAtTime:time
                                                      actualTime:NULL
                                                           error:&error];
        UIImage *image = [[UIImage alloc] initWithCGImage:imageReference];
        _videoThumbnail = image;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion();
        });
    });
}

@end
