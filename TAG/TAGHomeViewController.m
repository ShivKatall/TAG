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
#import "TAGTwitterPost.h"
#import "TAGTextCollectionView.h"
#import "TAGTextCell.h"

@interface TAGHomeViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) TAGAppDelegate *appDelegate;
@property (nonatomic, strong) TAGTwitterController *twitterController;
@property (nonatomic, strong) TAGInstagramController *instagramController;
@property (weak, nonatomic) IBOutlet UICollectionView *textCollectionView;

@property (nonatomic, strong) NSArray *currentTwitterPosts;
@property (nonatomic, strong) NSArray *currentInstagramPosts;

@end

@implementation TAGHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _appDelegate = [UIApplication sharedApplication].delegate;
    _textCollectionView.delegate = self;
    _textCollectionView.dataSource = self;
    
    [_textCollectionView registerClass:[TAGTextCell class] forCellWithReuseIdentifier:@"textCell"];
    
    
    // setup twitter
    _twitterController = _appDelegate.twitterController;
    [_twitterController fetchSearchResultsForQuery:@"KanyeWest" withCompletionBlock:^(NSMutableArray *twitterPosts) {
        [self assignViewControllerPostsFromTwitterControllerPosts:twitterPosts];
    }];
    
    [_textCollectionView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // setup instagram
    _instagramController = _appDelegate.instagramController;
    
    if (_instagramController.instagramToken) {
        [_instagramController fetchInstagramPostsForTag:@"KanyeWest" withCompletionBlock:^(NSMutableArray *instagramPosts) {
            
        }];
    }
    
    [_textCollectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)assignViewControllerPostsFromTwitterControllerPosts:(NSMutableArray *)twitterControllerPosts
{
    _currentTwitterPosts = twitterControllerPosts;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_textCollectionView reloadData];
    });
}

#pragma mark - UICollectionView Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_currentTwitterPosts count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TAGTextCell *textCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"textCell" forIndexPath:indexPath];
    TAGTwitterPost *twitterPost = [_currentTwitterPosts objectAtIndex:indexPath.row];
    textCell.fullNameLabel.text = twitterPost.fullName;
    textCell.userNameLabel.text = twitterPost.userName;
    textCell.textBody.text      = twitterPost.textBody;
    
    textCell.backgroundColor = [UIColor whiteColor];
    
    return textCell;
}

@end
