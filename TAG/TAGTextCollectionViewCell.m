//
//  TAGHomeCollectionViewCell.m
//  TAG
//
//  Created by Cole Bratcher on 8/14/14.
//  Copyright (c) 2014 TAG. All rights reserved.
//

#import "TAGTextCollectionViewCell.h"
#import "TAGTextTableView.h"

@interface TAGTextCollectionViewCell () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *textTableView;

@end

@implementation TAGTextCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark - UITableViewDelegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    
    return cell;
}

@end
