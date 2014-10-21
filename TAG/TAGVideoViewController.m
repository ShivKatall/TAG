//
//  TAGVideoViewController.m
//  TAG
//
//  Created by Cole Bratcher on 8/28/14.
//  Copyright (c) 2014 TAG. All rights reserved.
//


#import "TAGVideoViewController.h"
#import "TAGAppDelegate.h"
#import "TAGInstagramController.h"
#import "TAGInstagramPost.h"
#import "TAGVideoCell.h"
#import <MediaPlayer/MediaPlayer.h>


@interface TAGVideoViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) TAGAppDelegate *appDelegate;
@property (nonatomic, strong) TAGInstagramController *instagramController;
@property (nonatomic, weak) IBOutlet UICollectionView *videoCollectionView;

@property (nonatomic, strong) NSArray *currentInstagramPosts;

@end

@implementation TAGVideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _appDelegate = [UIApplication sharedApplication].delegate;
    _videoCollectionView.delegate = self;
    _videoCollectionView.dataSource = self;
    
    self.pageIndex = 0;
    
    // setup instagram
    _instagramController = _appDelegate.instagramController;
    
    if (_instagramController.instagramToken) {
        [_instagramController fetchPostsForTag:@"Video" withCompletionBlock:^(NSMutableArray *instagramPosts) {
            [self assignViewControllerPostsFromInstagramControllerPosts:instagramPosts];
        }];
    }
}

- (void)assignViewControllerPostsFromInstagramControllerPosts:(NSMutableArray *)instagramControllerPosts
{
    NSMutableArray *videoPosts = [NSMutableArray new];
    
    [instagramControllerPosts enumerateObjectsUsingBlock:^(TAGInstagramPost *post, NSUInteger idx, BOOL *stop) {
        if (post.postType == VIDEO) {
            [videoPosts addObject:post];
        }
    }];
    
    NSArray *postArray = [NSArray arrayWithArray:videoPosts];
    
    _currentInstagramPosts = postArray;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_videoCollectionView reloadData];
    });
}

#pragma mark - CollectionViewDelegate Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_currentInstagramPosts count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TAGVideoCell *videoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCell" forIndexPath:indexPath];
    TAGInstagramPost *instagramPost = [_currentInstagramPosts objectAtIndex:indexPath.row];
    
    if (instagramPost.videoThumbnail) {
        videoCell.thumbnail.image = instagramPost.videoThumbnail;
    } else {
        [instagramPost createThumbnailWithCompletionBlock:^{
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }];
    }
    return videoCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TAGInstagramPost *instagramPost = [_currentInstagramPosts objectAtIndex:indexPath.row];
    
    NSURL *videosURL = [NSURL URLWithString:instagramPost.videoURL];
    MPMoviePlayerViewController *moviePlayViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:videosURL];
    
    [self.navigationController presentMoviePlayerViewControllerAnimated:moviePlayViewController];
}
    
@end
