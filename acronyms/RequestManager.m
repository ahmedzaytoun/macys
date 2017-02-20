//
//  RequestManager.m
//  acronyms
//
//  Created by Ahmed Zaytoun on 6/23/16.
//  Copyright © 2016 macys. All rights reserved.
//

#import "RequestManager.h"
#import <AFNetworking.h>
#import "RequestUtil.h"

@implementation RequestManager

@synthesize delegate;


/*
 
 Call server and get data reponse
 
 */
- (void) getDataForService:(enum SystemServices) service withBody:(NSData *)body withParams:(NSDictionary *)params withOptions:(NSDictionary *)options
{
    
    //create request
    NSURLRequest *request =  [RequestUtil getRequestForService:service withBody:body withParams:params withOptions:options];
    
    //create session configeration
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //create AFURLSessionManager with configeration
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    
    
    //create data download tast
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        //check if error
        if (error) {
            
            //log error
            NSLog(@"Error: %@", error);
            
            //pass error response to delegate
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(failedToLoadDataRquestWithError:forService:withURLResponse:)])
            {
                [self.delegate failedToLoadDataRquestWithError:error forService:service withURLResponse:response];
            }
            
        
        }
        //Data download succedded
        else {
            
            //pass response to delegate
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(didLoadDataRquestWithObjectResponse:forService:withURLResponse:)])
            {
                [self.delegate didLoadDataRquestWithObjectResponse:responseObject forService:service withURLResponse:response];
            }
        }
    }];
    
    [dataTask resume];
    
}


@end
