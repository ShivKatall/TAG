//
//  TAGTextCell.h
//  TAG
//
//  Created by Cole Bratcher on 8/20/14.
//  Copyright (c) 2014 TAG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAGTextCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *textBody;

@end
