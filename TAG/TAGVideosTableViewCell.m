//
//  TAGVideosTableViewCell.m
//  TAG
//
//  Created by Cole Bratcher on 8/13/14.
//  Copyright (c) 2014 TAG. All rights reserved.
//

#import "TAGVideosTableViewCell.h"

@implementation TAGVideosTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
