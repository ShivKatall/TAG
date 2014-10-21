//
//  TAGInstagramPost.h
//  TAG
//
//  Created by Cole Bratcher on 8/12/14.
//  Copyright (c) 2014 TAG. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum postType {IMAGE, VIDEO} PostType;

@interface TAGInstagramPost : NSObject

// User
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *profilePictureURL;

// Post
@property (nonatomic, assign) PostType postType;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSString *videoURL;
@property (nonatomic, strong) UIImage *videoThumbnail;

- (void)downloadImageWithCompletionBlock:(void (^)())completion;
- (void)createThumbnailWithCompletionBlock:(void (^)())completion;

@end
