//
//  MeaningOperation.h
//  acronyms
//
//  Created by Ahmed Zaytoun on 6/24/16.
//  Copyright © 2016 macys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ServicesManager.h"
#import "MeaningListDataParser.h"

@protocol MeaningOperationDelegate <NSObject>

- (void) didLoadMeaningListWithResult:(NSArray *)result;
- (void) failedToLoadMeaningListWithError:(NSError *)error;

@end

@interface MeaningOperation : NSObject<ServiceManagerDelegate>
{
    ServicesManager *manager;
    MeaningListDataParser *parser;
}

@property(nonatomic,assign) id<MeaningOperationDelegate> delegate;

- (void) getMeaningForAbbreviation:(NSString *)abbreviation;

@end
