//
//  RequestManager.h
//  acronyms
//
//  Created by Ahmed Zaytoun on 6/23/16.
//  Copyright © 2016 macys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RequestUtil.h"

@protocol RequestManagerDelegate <NSObject>

- (void) didLoadDataRquestWithObjectResponse:(id)responseObject forService:(enum SystemServices)service withURLResponse:(NSURLResponse *) response;
- (void) failedToLoadDataRquestWithError:(NSError *)error forService:(enum SystemServices)service withURLResponse:(NSURLResponse *) response;

@end

@interface RequestManager : NSObject

@property(nonatomic,assign) id<RequestManagerDelegate> delegate;

- (void) getDataForService:(enum SystemServices) service withBody:(NSData *)body withParams:(NSDictionary *)params withOptions:(NSDictionary *)options;


@end
