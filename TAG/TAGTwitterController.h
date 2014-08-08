//
//  TAGTwitterAPI.h
//  TAG
//
//  Created by Cole Bratcher on 8/7/14.
//  Copyright (c) 2014 TAG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAGTwitterController : NSObject

@property (strong,nonatomic) NSString *token;

-(void)fetchSearchResultsForQuery:(NSString *)query;

@end
