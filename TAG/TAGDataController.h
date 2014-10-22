//
//  TAGDataController.h
//  TAG
//
//  Created by Cole Bratcher on 8/7/14.
//  Copyright (c) 2014 TAG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TAGTag.h"

@interface TAGDataController : NSObject

@property (nonatomic, strong)NSMutableArray *tags;
@property (nonatomic, strong)TAGTag *currentTag;

+(TAGDataController *)sharedController;

@end
