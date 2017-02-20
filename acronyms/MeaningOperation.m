//
//  MeaningOperation.m
//  acronyms
//
//  Created by Ahmed Zaytoun on 6/24/16.
//  Copyright © 2016 macys. All rights reserved.
//

#import "MeaningOperation.h"

@implementation MeaningOperation


- (id)init
{
    if(self = [super init])
    {
        manager = [[ServicesManager alloc] init];
        manager.delegate = self;
        parser = [[MeaningListDataParser alloc] init];
    }
    
    return self;
}

- (void) getMeaningForAbbreviation:(NSString *)abbreviation
{
    if(manager != nil)
    {
        [manager getAcronymForAbbreviation:abbreviation];
    }
    else if(self.delegate != nil && [self.delegate respondsToSelector:@selector(failedToLoadMeaningListWithError:)]){
        
        [self.delegate failedToLoadMeaningListWithError:[NSError errorWithDomain:@"Failed to load service manager" code:700 userInfo:nil]];
    }
}

- (void) didLoadServiceDataRquestWithObjectResponse:(id)responseObject forService:(enum SystemServices)service withURLResponse:(NSURLResponse *)response

{
    NSArray *dataArray = [parser parseMeaningListData:responseObject];
    
    if(dataArray != nil)
    {
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(didLoadMeaningListWithResult:)])
        {
            [self.delegate didLoadMeaningListWithResult:dataArray];
        }
    }
    else if(self.delegate != nil && [self.delegate respondsToSelector:@selector(failedToLoadMeaningListWithError:)])
    {
        
        [self.delegate failedToLoadMeaningListWithError:[[NSError alloc]initWithDomain:@"Unable to load data" code:800 userInfo:nil]];
    }
}

- (void) failedToServiceLoadDataRquestWithError:(NSError *)error forService:(enum SystemServices)service withURLResponse:(NSURLResponse *)response
{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(failedToLoadMeaningListWithError:)])
    {
        [self.delegate failedToLoadMeaningListWithError:error];
    }
}

@end
