//
//  RequestUtil.h
//  acronyms
//
//  Created by Ahmed Zaytoun on 6/24/16.
//  Copyright © 2016 macys. All rights reserved.
//

#import <Foundation/Foundation.h>

enum SystemServices
{
    MEANING_SERVICE
};

#define APPLICATION_JSON @"application/json"
#define CONTENT_TYPE @"Content-Type"
#define ACCEPT @"Accept"
#define APPLICATION_JSON @"application/json"
#define TEXT_PLAIN @"text/plain"

@interface RequestUtil : NSObject


+ (NSURLRequest *) getRequestForService:(enum SystemServices) service withBody:(NSData *)body withParams:(NSDictionary *)params withOptions:(NSDictionary *)options;

+ (NSString *) getServiceURLString:(enum SystemServices) service withParams:(NSDictionary *)params;

+ (NSString *) getMethodForService:(enum SystemServices) service;


+ (NSDictionary *) getJSONOptions;

@end
