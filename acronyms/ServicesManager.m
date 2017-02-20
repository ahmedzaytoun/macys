//
//  ServicesManager.m
//  acronyms
//
//  Created by Ahmed Zaytoun on 6/24/16.
//  Copyright © 2016 macys. All rights reserved.
//

#import "ServicesManager.h"


@implementation ServicesManager

@synthesize delegate;

- (id) init
{
    if(self = [super init])
    {
        requestManager = [[RequestManager alloc] init];
        requestManager.delegate = self;
    }
    
    return self;
}

/*
 Acronym Servive for abbreviation search
 */
- (void) getAcronymForAbbreviation:(NSString *)abbreviation
{
    if(requestManager != nil)
    {
        
        //call requst manageer
        [requestManager getDataForService:MEANING_SERVICE withBody:nil withParams:@{@"sf" : abbreviation} withOptions:[RequestUtil getJSONOptions]];
    }
    else if(self.delegate != nil && [self.delegate respondsToSelector:@selector(failedToServiceLoadDataRquestWithError:forService:withURLResponse:)])
    {
        [self.delegate failedToServiceLoadDataRquestWithError:[[NSError alloc] initWithDomain:@"Service Layer - Rquest Manager not available" code:600 userInfo:nil] forService:MEANING_SERVICE withURLResponse:nil];
    }
}


#pragma mark - Request Manager Delegate

- (void) didLoadDataRquestWithObjectResponse:(id)responseObject forService:(enum SystemServices)service withURLResponse:(NSURLResponse *)response
{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(didLoadServiceDataRquestWithObjectResponse:forService:withURLResponse:)])
    {
        [self.delegate didLoadServiceDataRquestWithObjectResponse:responseObject forService:service withURLResponse:response];
    }
}

- (void) failedToLoadDataRquestWithError:(NSError *)error forService:(enum SystemServices)service withURLResponse:(NSURLResponse *)response
{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(failedToServiceLoadDataRquestWithError:forService:withURLResponse:)])
    {
        [self.delegate failedToServiceLoadDataRquestWithError:error forService:service withURLResponse:response];
    }
}

@end
