//
//  TAGInstagramPost.h
//  TAG
//
//  Created by Cole Bratcher on 8/12/14.
//  Copyright (c) 2014 TAG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAGInstagramPost : NSObject

// User
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *profilePictureURL;

// Post
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *caption;

@end
