//
//  TAGInstagramAPI.h
//  TAG
//
//  Created by Cole Bratcher on 8/7/14.
//  Copyright (c) 2014 TAG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TAGTag.h"

@interface TAGInstagramController : NSObject

@property (nonatomic, strong) NSString *instagramToken;
@property (nonatomic, strong) NSURL *fetchURL;
@property (nonatomic, strong) NSArray *currentInstagramPosts;

-(void)gainOAuthAccessWithURL:(NSURL *)url;
-(void)fetchPostsForTag:(TAGTag *)tag withCompletionBlock:(void(^)(NSMutableArray *instagramPosts))completionBlock;

@end
