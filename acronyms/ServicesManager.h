//
//  ServicesManager.h
//  acronyms
//
//  Created by Ahmed Zaytoun on 6/24/16.
//  Copyright © 2016 macys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RequestManager.h"

@protocol ServiceManagerDelegate <NSObject>

- (void) didLoadServiceDataRquestWithObjectResponse:(id)responseObject forService:(enum SystemServices)service withURLResponse:(NSURLResponse *) response;
- (void) failedToServiceLoadDataRquestWithError:(NSError *)error forService:(enum SystemServices)service withURLResponse:(NSURLResponse *) response;

@end


@interface ServicesManager : NSObject<RequestManagerDelegate>
{
    RequestManager *requestManager;
}


- (void) getAcronymForAbbreviation:(NSString *)abbreviation;

@property(nonatomic,assign) id<ServiceManagerDelegate> delegate;

@end
