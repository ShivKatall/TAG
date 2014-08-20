//
//  TAGTwitterPost.h
//  TAG
//
//  Created by Cole Bratcher on 8/12/14.
//  Copyright (c) 2014 TAG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAGTwitterPost : NSObject

// User
@property (nonatomic, strong) NSString *profilePictureURL;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *fullName;

// Post
@property (nonatomic, strong) NSString *textBody;

@end
