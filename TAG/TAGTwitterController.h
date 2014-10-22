//
//  TAGTwitterAPI.h
//  TAG
//
//  Created by Cole Bratcher on 8/7/14.
//  Copyright (c) 2014 TAG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TAGTag.h"

@interface TAGTwitterController : NSObject

@property (nonatomic, strong) NSString *token;

-(void)fetchSearchResultsForTag:(TAGTag *)tag withCompletionBlock:(void(^)(NSMutableArray *twitterPosts))completionBlock;

@end