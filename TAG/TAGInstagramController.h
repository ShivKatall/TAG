//
//  TAGInstagramAPI.h
//  TAG
//
//  Created by Cole Bratcher on 8/7/14.
//  Copyright (c) 2014 TAG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAGInstagramController : NSObject

@property (nonatomic, strong) NSString *instagramToken;
@property (nonatomic, strong) NSURL *fetchURL;

-(void)gainOAuthAccessWithURL:(NSURL *)url;
-(void)fetchInstagramPostsForTag:(NSString *)tag withCompletionBlock:(void(^)(NSMutableArray *instagramPosts))completionBlock;


@end
