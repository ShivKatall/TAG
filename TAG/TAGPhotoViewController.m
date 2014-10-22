//
//  TAGPhotoViewController.m
//  TAG
//
//  Created by Cole Bratcher on 8/28/14.
//  Copyright (c) 2014 TAG. All rights reserved.
//

#import "TAGPhotoViewController.h"
#import "TAGAppDelegate.h"
#import "TAGInstagramController.h"
#import "TAGPhotoCell.h"
#import "TAGInstagramPost.h"
#import "TAGDataController.h"

@interface TAGPhotoViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) TAGAppDelegate *appDelegate;
@property (nonatomic, strong) TAGInstagramController *instagramController;

@property (nonatomic, weak) IBOutlet UICollectionView *photoCollectionView;
@property (nonatomic, strong) NSArray *currentInstagramPosts;

@end

@implementation TAGPhotoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _appDelegate = [UIApplication sharedApplication].delegate;
    _photoCollectionView.delegate = self;
    _photoCollectionView.dataSource = self;
    
    self.pageIndex = 0;
    
    // setup instagram
    _instagramController = _appDelegate.instagramController;
    
    if (_instagramController.instagramToken) {
        [_instagramController fetchPostsForTag:CURRENT_TAG withCompletionBlock:^(NSMutableArray *instagramPosts) {
            [self assignViewControllerPostsFromInstagramControllerPosts:instagramPosts];
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_photoCollectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)assignViewControllerPostsFromInstagramControllerPosts:(NSMutableArray *)instagramControllerPosts
{
    NSMutableArray *imagePosts = [NSMutableArray new];
    
    [instagramControllerPosts enumerateObjectsUsingBlock:^(TAGInstagramPost *post, NSUInteger idx, BOOL *stop) {
        if (post.postType == IMAGE) {
            [imagePosts addObject:post];
        }
    }];
    
    NSArray *postArray = [NSArray arrayWithArray:imagePosts];
    
    _currentInstagramPosts = postArray;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_photoCollectionView reloadData];
    });
}

#pragma mark - CollectionViewDelegate Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_currentInstagramPosts count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TAGPhotoCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    TAGInstagramPost *instagramPost = [_currentInstagramPosts objectAtIndex:indexPath.row];
    
    if (instagramPost.image) {
        photoCell.image.image = instagramPost.image;
    } else {
        [instagramPost downloadImageWithCompletionBlock:^{
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }];
    }
    
    return photoCell;
}

@end
