//
//  TAGTextCell.h
//  TAG
//
//  Created by Cole Bratcher on 8/20/14.
//  Copyright (c) 2014 TAG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAGTextCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *textBodyLabel;

//- (void)setUserNameLabelWithAtSymbolFromUserName:(NSString *)userName;

@end
