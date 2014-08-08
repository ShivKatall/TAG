//
//  TAGViewController.m
//  TAG
//
//  Created by Cole Bratcher on 8/7/14.
//  Copyright (c) 2014 TAG. All rights reserved.
//

#import "TAGHomeVC.h"
#import "TAGTwitterController.h"


@interface TAGHomeVC ()

@property (nonatomic, strong) TAGTwitterController *twitterAPI;

@end

@implementation TAGHomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _twitterAPI = [TAGTwitterController new];
    
    [_twitterAPI fetchSearchResultsForQuery:@"#SWSeattle"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
