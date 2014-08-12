//
//  TAGTwitterAPI.m
//  TAG
//
//  Created by Cole Bratcher on 8/7/14.
//  Copyright (c) 2014 TAG. All rights reserved.
//

#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "TAGTwitterController.h"

@interface TAGTwitterController ()

@property (nonatomic, strong) ACAccountStore *accountStore;

@end

@implementation TAGTwitterController

-(id)init
{
    self = [super init];
    
    if (self) {
        _accountStore = [ACAccountStore new];
    }
    
    return self;
}

-(BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

-(void)fetchSearchResultsForQuery:(NSString *)query
{
    NSString *hashtagQuery = [self createHashtagQueryFromQuery:query];
    
    if ([self userHasAccessToTwitter]) {
        {
            //  Step 1:  Obtain access to the user's Twitter accounts
            ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier: ACAccountTypeIdentifierTwitter];
            
            [self.accountStore requestAccessToAccountsWithType:twitterAccountType
                                                       options:NULL
                                                    completion:^(BOOL granted, NSError *error) {
                if (granted) {
                    // Encode query
                    NSString *encodedQuery = [hashtagQuery stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSLog(@"Encoded Query: %@", encodedQuery);
                    
                    //  Create a request
                    NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:twitterAccountType];
                    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
                    NSDictionary *params = @{@"q": encodedQuery};
                    SLRequest *queryRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                 requestMethod:SLRequestMethodGET
                                                                           URL:url
                                                                    parameters:params];
                    NSLog(@"Query Request: %@", queryRequest.URL);
                    
                    //  Attach an account to the request
                    [queryRequest setAccount:[twitterAccounts lastObject]];
                    
                    //  Execute the request
                    [queryRequest performRequestWithHandler:
                     ^(NSData *responseData,
                       NSHTTPURLResponse *urlResponse,
                       NSError *error) {
                         
                         if (responseData) {
                             if (urlResponse.statusCode == 200) {
                                 
                                 NSError *jsonError;
                                 NSDictionary *searchData =
                                 [NSJSONSerialization JSONObjectWithData:responseData
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&jsonError];
                                 if (searchData) {
                                     NSLog(@"Search Response: %@\n", searchData);
                                 } else {
                                     // Our JSON deserialization went awry
                                     NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                                 }
                             } else {
                                 // The server did not respond ... were we rate-limited?
                                 NSLog(@"The response status code is %ld", (long)urlResponse.statusCode);
                             }
                         }
                     }];
                } else {
                    // Access was not granted, or an error occurred
                    NSLog(@"%@", [error localizedDescription]);
                }
            }];
        }
    }
}

-(NSString *)createHashtagQueryFromQuery:(NSString *)query
{
    NSString *hashtagQuery = [NSString stringWithFormat:@"#%@", query];
  
    return hashtagQuery;
}
                               
                               
@end
