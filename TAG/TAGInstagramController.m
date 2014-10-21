//
//  TAGInstagramAPI.m
//  TAG
//
//  Created by Cole Bratcher on 8/7/14.
//  Copyright (c) 2014 TAG. All rights reserved.
//

#import "TAGInstagramController.h"
#import "TAGInstagramPost.h"

#define INSTAGRAM_CLIENT_ID @"15bfc7914cef4c2294602dbdc8a22ed2"
#define INSTAGRAM_CLIENT_SECRET @"0bd2bc39ab09413db9b29253727f8b22"
#define INSTAGRAM_OAUTH_URL @"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=code"
#define INSTAGRAM_CALLBACK_URI @"TAGiOS://auth"
#define INSTAGRAM_API_URL @"https://api.instagram.com/v1/"

@interface TAGInstagramController ()

@property (nonatomic, strong) NSURLSession *urlSession;

@end

@implementation TAGInstagramController

-(id)init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        self.urlSession = [NSURLSession sessionWithConfiguration:configuration];
        self.instagramToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"instagramoauthtoken"];
        
        if (!self.instagramToken) {
            [self performSelector:@selector(requestOAuthAccess) withObject:nil afterDelay:0.1];
        }
    }
    return self;
}

#pragma mark - OAuth Methods

-(void)requestOAuthAccess
{
    NSString *oAuthRequestString = [NSString stringWithFormat:INSTAGRAM_OAUTH_URL,INSTAGRAM_CLIENT_ID,INSTAGRAM_CALLBACK_URI];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:oAuthRequestString]];
}

-(void)gainOAuthAccessWithURL:(NSURL *)url
{
    NSString *code = [self getCodeFromCallbackURL:url];
    NSMutableURLRequest *request = [self createTokenRequestWithCode:code];
    [self postTokenDataTaskWithRequest:request];
    
}

-(NSString *)getCodeFromCallbackURL:(NSURL *)callbackURL
{
    NSString *queryFromCallbackURL = [callbackURL query];
    NSLog(@"%@", queryFromCallbackURL);
    NSArray *components = [queryFromCallbackURL componentsSeparatedByString:@"code="];
    
    return [components lastObject];
}

-(NSMutableURLRequest *)createTokenRequestWithCode:(NSString *)code
{
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
    
    NSLog(@"HTTPBody: %@", tokenRequest.HTTPBody);
    
    return tokenRequest;
}

-(void)postTokenDataTaskWithRequest:(NSMutableURLRequest *)request
{
    NSURLSessionDataTask *tokenDataTask = [self.urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"Error: %@", error.description);
        }
        
        NSLog(@"%@", response.description);
        NSString *rawToken = [self createRawTokenFromResponseData:data];
        NSString *token = [self createTokenFromRawToken:rawToken];
        [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"instagramoauthtoken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    
    [tokenDataTask resume];
}

-(NSString *)createRawTokenFromResponseData:(NSData *)data
{
    NSString *tokenResponse     = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *tokenComponents    = [tokenResponse componentsSeparatedByString:@"&"];
    NSString *tokenWithCode     = tokenComponents[0];
    NSArray *tokenArray         = [tokenWithCode componentsSeparatedByString:@":"];
    
    NSLog(@"%@", tokenArray);
    
    return tokenArray[1];
}

-(NSString *)createTokenFromRawToken:(NSString *)rawToken
{
    // This method was needed because response token data looked something like: "ACCESS_TOKEN","user"
    NSArray *rawTokenComponents = [rawToken componentsSeparatedByString:@","];
    NSString *tokenWithQuotations = rawTokenComponents[0];
    NSString *token = [tokenWithQuotations stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    return token;
}

#pragma mark API Methods

-(NSMutableURLRequest *)createRequestForTag:(NSString *)tag
{
    // set parameters
    
    NSString *requestString = [[NSString alloc] initWithFormat:@"%@tags/%@/media/recent?access_token=%@", INSTAGRAM_API_URL, tag, self.instagramToken];
    
    NSLog(@"requestString: %@", requestString);
    
    NSURL *requestURL = [[NSURL alloc] initWithString:requestString];
    _fetchURL = requestURL;
    
    NSLog(@"fetchURL: %@", _fetchURL.path);
    NSLog(@"requestURL: %@", requestURL.path);
    
    // setup request
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:requestURL];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"token %@", self.instagramToken] forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"Request: %@", request.HTTPBody);
    NSLog(@"Token: %@", self.instagramToken);
    
    return request;
};

-(void)fetchPostsForTag:(NSString *)tag withCompletionBlock:(void(^)(NSMutableArray *instagramPosts))completionBlock
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSMutableURLRequest *request = [self createRequestForTag:tag];
    
    // setup dataTask
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error: %@", error.description);
        }
        NSLog(@"%@", response.description);
        
        NSDictionary *rawDataDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:nil];
        NSArray *rawDataArray = [NSArray new];
        
        if ([rawDataDictionary objectForKey:@"data"] != [NSNull null]) {
            rawDataArray = [rawDataDictionary objectForKey:@"data"];
        }
        
        NSMutableArray *instagramPosts = [NSMutableArray new];
        
        [rawDataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            TAGInstagramPost *newInstagramPost = [TAGInstagramPost new];
            
            // User
            NSDictionary *userDictionary = [NSDictionary new];
            if ([obj objectForKey:@"user"] != [NSNull null]) {
                userDictionary = [obj objectForKey:@"user"];
            }
            if ([userDictionary objectForKey:@"username"] != [NSNull null]) {
                newInstagramPost.userName = [userDictionary objectForKey:@"username"];
            }
            if ([userDictionary objectForKey:@"full_name"] != [NSNull null]) {
                newInstagramPost.fullName = [userDictionary objectForKey:@"full_name"];
            }
            if ([userDictionary objectForKey:@"profile_picture"] != [NSNull null]) {
                newInstagramPost.profilePictureURL = [userDictionary objectForKey:@"profile_picture"];
            }
            
            // Caption
            NSDictionary *captionDictionary = [NSDictionary new];
            if ([obj objectForKey:@"caption"] != [NSNull null]) {
                captionDictionary = [obj objectForKey:@"caption"];
            }
            if ([captionDictionary objectForKey:@"text"] != [NSNull null]) {
                newInstagramPost.caption = [captionDictionary objectForKey:@"text"];
            }

            
            // Image

            if ([[obj objectForKey:@"type"] isEqualToString:@"image"]) {
                
                newInstagramPost.postType = IMAGE;
                
                NSDictionary *imageDictionary = [NSDictionary new];
                NSDictionary *standardResolutionDictionary = [NSDictionary new];
                
                if ([obj objectForKey:@"images"] != [NSNull null]) {
                    imageDictionary = [obj objectForKey:@"images"];
                }
                if ([imageDictionary objectForKey:@"standard_resolution"] != [NSNull null]) {
                    standardResolutionDictionary = [imageDictionary objectForKey:@"standard_resolution"];
                }
                if ([standardResolutionDictionary objectForKey:@"url"] != [NSNull null]) {
                    newInstagramPost.imageURL = [standardResolutionDictionary objectForKey:@"url"];
                }
                
            // Video
                
            } else if ([[obj objectForKey:@"type"] isEqualToString:@"video"]) {
                
                newInstagramPost.postType = VIDEO;
                
               
                NSDictionary *videoDictionary = [NSDictionary new];
                NSDictionary *standardResolutionDictionary = [NSDictionary new];
                
                if ([obj objectForKey:@"videos"] != [NSNull null]) {
                    videoDictionary = [obj objectForKey:@"videos"];
                }
                if ([videoDictionary objectForKey:@"standard_resolution"] != [NSNull null]) {
                    standardResolutionDictionary = [videoDictionary objectForKey:@"standard_resolution"];
                }
                if ([standardResolutionDictionary objectForKey:@"url"] != [NSNull null]) {
                    newInstagramPost.videoURL = [standardResolutionDictionary objectForKey:@"url"];
                }
            }
                
            [instagramPosts addObject:newInstagramPost];
        }];
        
        NSLog(@"Instagram Posts: %lu", (unsigned long)instagramPosts.count);
        
        completionBlock(instagramPosts);
        
    }];
    
    [dataTask resume];
}

// for more see http://instagram.com/developer/authentication/

@end
