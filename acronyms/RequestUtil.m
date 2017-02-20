//
//  RequestUtil.m
//  acronyms
//
//  Created by Ahmed Zaytoun on 6/24/16.
//  Copyright © 2016 macys. All rights reserved.
//

#import "RequestUtil.h"

#define kServerURL @"http://www.nactem.ac.uk/software/acromine"
#define kDictionaryService @"/dictionary.py"


#define kGET @"GET"

@implementation RequestUtil

/*
 JSON Options
 */
+ (NSDictionary *) getJSONOptions
{
    return [NSDictionary dictionaryWithObjectsAndKeys:APPLICATION_JSON,ACCEPT,APPLICATION_JSON,CONTENT_TYPE, nil];
}

/*
 
 Request builder
 */
+ (NSURLRequest *) getRequestForService:(enum SystemServices)service withBody:(NSData *)body withParams:(NSDictionary *)params withOptions:(NSDictionary *)options
{
    
    NSString *stringUrl = [self getServiceURLString:service withParams:params];
    
    NSString *requestMethod = [self getMethodForService:service];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    if (options != nil) {
        NSArray *keys = [options allKeys];
        
        for (int i = 0; i < [keys count]; i++) {
            NSString *key = [keys objectAtIndex:i];
            
            [request setValue:[options objectForKey:key] forHTTPHeaderField:key];
        }
        
    }
    
    [request setURL:[NSURL URLWithString:stringUrl]];
    [request setHTTPBody:body];
    [request setHTTPMethod:requestMethod];
    
    return request;

}

/*
 HTTP method for system services
 */
+ (NSString *) getMethodForService:(enum SystemServices) service
{
    switch (service) {
        case MEANING_SERVICE:
        default:
            return kGET;
    }
}

/*
 Service URL Builder
 */
+ (NSString *) getServiceURLString:(enum SystemServices)service withParams:(NSDictionary *)params
{
    
    NSMutableString *URLString = [[NSMutableString alloc] init];
    
    [URLString appendString:[self getServerBaseURL]];
    
    switch(service)
    {
        case MEANING_SERVICE:
            
            [URLString appendString:kDictionaryService];
            
            break;
    }
    
    if (params != nil && params.count > 0)
    {
        NSMutableString *queryString = [[NSMutableString alloc] initWithString:@"?"];
        
        for(NSString *key in params)
        {
            id value = [params objectForKey:key];
            
            if(value != nil && [value isKindOfClass:[NSString class]])
            {
                [queryString appendFormat:@"%@=%@&",key,(NSString *)value];
            }
        }
        
        [URLString appendString:queryString];
    }
    
    return URLString;
}


+ (NSString *) getServerBaseURL
{
    return [NSString stringWithFormat:@"%@",kServerURL];
}




@end
