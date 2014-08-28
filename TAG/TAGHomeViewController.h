//
//  TAGHomeViewController.h
//  TAG
//
//  Created by Cole Bratcher on 8/27/14.
//  Copyright (c) 2014 TAG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAGTextViewController.h"

@interface TAGHomeViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;

@end
