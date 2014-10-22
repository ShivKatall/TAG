//
//  TAGDataController.m
//  TAG
//
//  Created by Cole Bratcher on 8/7/14.
//  Copyright (c) 2014 TAG. All rights reserved.
//

#import "TAGDataController.h"

@implementation TAGDataController

+(TAGDataController *)sharedController
{
    static dispatch_once_t pred;
    static TAGDataController *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[TAGDataController alloc] init];
    });
    return shared;
}

@end
