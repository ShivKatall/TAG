//
//  TAGHomeViewController.m
//  TAG
//
//  Created by Cole Bratcher on 8/27/14.
//  Copyright (c) 2014 TAG. All rights reserved.
//

#import "TAGHomeViewController.h"
#import "TAGMenuViewController.h"

@interface TAGHomeViewController ()

@property (nonatomic) BOOL menuShown;

@property (nonatomic, strong) TAGMenuViewController *menuViewController;

@end

@implementation TAGHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"pageViewController"];
    _pageViewController.dataSource = self;
    _menuViewController = [TAGMenuViewController new];
    
    TAGHomeContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [_pageViewController setViewControllers:viewControllers
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    _pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [_pageViewController didMoveToParentViewController:self];
    
    _menuShown = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(TAGHomeContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    TAGHomeContentViewController *contentViewController = [TAGHomeContentViewController new];
    
    if (index == 0) {
        TAGHomeContentViewController *imageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"imageViewController"];
        contentViewController = imageViewController;
        
    } else if (index == 1) {
        TAGTextViewController *textViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"textViewController"];
        contentViewController = textViewController;
        
    } else if (index == 2) {
        TAGHomeContentViewController *videoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"videoViewController"];
        contentViewController = videoViewController;
        
    } else {
        contentViewController = nil;
    }
    
    return contentViewController;
}



- (IBAction)toggleMenu:(id)sender
{
    if (_menuShown == YES) {
        
        [[_menuViewController view] removeFromSuperview];
        
        _menuViewController = nil;
        
        _menuShown = NO;
        
    } else {
        [[self view] addSubview: [_menuViewController view]];
        
        CGRect frame = [[self view] frame];
    
        frame.origin.y = [[self view] frame].size.height;
        [[_menuViewController view] setFrame: frame];
        frame.origin.y = 0.0 - [[self view] frame].size.height;
        
        
        [UIView animateWithDuration: 1.0
                              delay: 0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [[self view] setFrame: frame];
                         }
                         completion: ^(BOOL finished) {
                             
                         }
         ];
        
        _menuShown = YES;
    }
}

#pragma mark - PageViewController DataSource

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TAGHomeContentViewController *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TAGHomeContentViewController *) viewController).pageIndex;
    
    if (index == 3 || index == NSNotFound) {
        return nil;
    }
    
    index++;
    return [self viewControllerAtIndex:index];
}

@end
