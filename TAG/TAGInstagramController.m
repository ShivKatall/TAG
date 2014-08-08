//
//  TAGInstagramAPI.m
//  TAG
//
//  Created by Cole Bratcher on 8/7/14.
//  Copyright (c) 2014 TAG. All rights reserved.
//

#import "TAGInstagramController.h"

#define INSTAGRAM_CLIENT_ID @"15bfc7914cef4c2294602dbdc8a22ed2"
#define INSTAGRAM_CLIENT_SECRET @"0bd2bc39ab09413db9b29253727f8b22"
#define INSTAGRAM_OAUTH_URL @"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=code"
#define INSTAGRAM_CALLBACK_URI @"TAGiOS://auth"

@interface TAGInstagramController ()

@property (nonatomic, strong) NSURLSession *URLSession;

@end

@implementation TAGInstagramController

-(void)requestOAuthAccess
{
    NSString *oAuthRequestString = [NSString stringWithFormat:INSTAGRAM_OAUTH_URL,INSTAGRAM_CLIENT_ID,INSTAGRAM_CALLBACK_URI];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:oAuthRequestString]];
}

-(NSString *)getCodeFromCallbackURL:(NSURL *)callbackURL
{
    NSString *queryFromCallbackURL = [callbackURL query];
    NSLog(@"%@", queryFromCallbackURL);
    NSArray *components = [queryFromCallbackURL componentsSeparatedByString:@"code="];
    
    return [components lastObject];
}

@end
