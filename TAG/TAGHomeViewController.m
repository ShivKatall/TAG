//
//  TAGViewController.m
//  TAG
//
//  Created by Cole Bratcher on 8/7/14.
//  Copyright (c) 2014 TAG. All rights reserved.
//

#import "TAGAppDelegate.h"
#import "TAGHomeViewController.h"
#import "TAGTwitterController.h"
#import "TAGInstagramController.h"
#import "TAGInstagramPost.h"


@interface TAGHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) TAGAppDelegate *appDelegate;
@property (nonatomic, strong) TAGTwitterController *twitterController;
@property (nonatomic, strong) TAGInstagramController *instagramController;

@end

@implementation TAGHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _appDelegate = [UIApplication sharedApplication].delegate;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // setup twitter
    _twitterController = _appDelegate.twitterController;
    [_twitterController fetchSearchResultsForQuery:@"KanyeWest"];
    
    // setup instagram
    _instagramController = _appDelegate.instagramController;
    
    if (_instagramController.instagramToken) {
        [_instagramController fetchInstagramPostsForTag:@"KanyeWest" withCompletionBlock:^(NSMutableArray *instagramPosts) {
            
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

@end
