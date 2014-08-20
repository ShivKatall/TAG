//
//  TAGHomeCollectionViewCell.m
//  TAG
//
//  Created by Cole Bratcher on 8/14/14.
//  Copyright (c) 2014 TAG. All rights reserved.
//

#import "TAGHomeTextCollectionViewCell.h"
#import "TAGTextCollectionView.h"
#import "TAGTextTableView.h"
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>

@interface TAGHomeTextCollectionViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet TAGTextCollectionView *TextCollectionView;

@end

@implementation TAGHomeTextCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark - UICollectionView Delegate Methods

//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    // total number of cells (NSArray Count)
//}

@end

