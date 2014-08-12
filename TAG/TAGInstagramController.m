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

// for more see http://instagram.com/developer/authentication/

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

-(NSMutableURLRequest *)createTokenRequestWithURL:(NSURL *)url;
{
    NSString *code = [self getCodeFromCallbackURL:url];
    NSString *grantType = @"authorization_code";
    NSString *parameterString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=%@&redirect_uri=%@&code=%@",INSTAGRAM_CLIENT_ID, INSTAGRAM_CLIENT_SECRET, grantType, INSTAGRAM_CALLBACK_URI, code];
    NSData *postData = [parameterString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long) [postData length]];
    
    NSMutableURLRequest *tokenRequest = [NSMutableURLRequest new];
    [tokenRequest setURL:[NSURL URLWithString:@"https://api.instagram.com/oauth/access_token"]];
    [tokenRequest setHTTPMethod:@"POST"];
    [tokenRequest setValue:postLength forHTTPHeaderField:@"context-length"];
    [tokenRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [tokenRequest setHTTPBody:postData];
    
    return tokenRequest;
}

-(void)postTokenDataTaskWithRequest:(NSMutableURLRequest *)request
{
    NSURLSessionDataTask *tokenDataTask = [self.URLSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"Error: %@", error.description);
        }
        
        NSLog(@"%@", response.description);
        NSString *token = [self createTokenFromResponseData:data];
        [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"oauthtoken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    
    [tokenDataTask resume];
}

-(NSString *)createTokenFromResponseData:(NSData *)data
{
    NSString *tokenResponse     = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSArray *tokenComponents    = [tokenResponse componentsSeparatedByString:@"&"];
    NSString *tokenWithCode     = tokenComponents[0];
    NSArray *tokenArray         = [tokenWithCode componentsSeparatedByString:@"="];
    
    NSLog(@"%@", tokenArray);
    
    return tokenArray[1];
}

@end
