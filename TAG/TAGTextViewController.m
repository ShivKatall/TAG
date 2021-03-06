//
//  TAGViewController.m
//  TAG
//
//  Created by Cole Bratcher on 8/7/14.
//  Copyright (c) 2014 TAG. All rights reserved.
//

#import "TAGAppDelegate.h"
#import "TAGTextViewController.h"
#import "TAGTwitterController.h"
#import "TAGTwitterPost.h"
#import "TAGTextCell.h"
#import "TAGDataController.h"

@interface TAGTextViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) TAGAppDelegate *appDelegate;
@property (nonatomic, strong) TAGTwitterController *twitterController;
@property (weak, nonatomic) IBOutlet UICollectionView *textCollectionView;

@property (nonatomic, strong) NSArray *currentTwitterPosts;

@end

@implementation TAGTextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _appDelegate = [UIApplication sharedApplication].delegate;
    _textCollectionView.delegate = self;
    _textCollectionView.dataSource = self;
    
    self.pageIndex = 1;
    
    // setup twitter
    _twitterController = _appDelegate.twitterController;
    [_twitterController fetchSearchResultsForTag:CURRENT_TAG withCompletionBlock:^(NSMutableArray *twitterPosts) {
        [self assignViewControllerPostsFromTwitterControllerPosts:twitterPosts];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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
    TAGTextCell *textCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TextCell" forIndexPath:indexPath];
    TAGTwitterPost *twitterPost = [_currentTwitterPosts objectAtIndex:indexPath.row];
    
    // text
    textCell.fullNameLabel.text = [NSString stringWithFormat:@"%@", twitterPost.fullName];
    textCell.userNameLabel.text = [NSString stringWithFormat:@"@%@", twitterPost.userName];
    textCell.textBodyLabel.text = [NSString stringWithFormat:@"%@", twitterPost.textBody];
 
    // profile picture
    textCell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:twitterPost.profilePictureURL]]];
//    textCell.imageView.layer.cornerRadius = textCell.imageView.image.size.width / 1.5;
    textCell.imageView.layer.cornerRadius = 32;

    textCell.imageView.layer.masksToBounds = YES;
    
    textCell.backgroundColor = [UIColor whiteColor];
    
    return textCell;
}

@end
