//
//  TAGAppDelegate.h
//  TAG
//
//  Created by Cole Bratcher on 8/7/14.
//  Copyright (c) 2014 TAG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAGTwitterController.h"
#import "TAGInstagramController.h"

@interface TAGAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) TAGTwitterController *twitterController;
@property (nonatomic, strong) TAGInstagramController *instagramController;

@end
