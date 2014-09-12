//
//  TAGInstagramPost.m
//  TAG
//
//  Created by Cole Bratcher on 8/12/14.
//  Copyright (c) 2014 TAG. All rights reserved.
//

#import "TAGInstagramPost.h"

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

@end
