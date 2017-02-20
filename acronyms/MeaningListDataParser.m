//
//  MeaningListDataParser.m
//  acronyms
//
//  Created by Ahmed Zaytoun on 6/24/16.
//  Copyright © 2016 macys. All rights reserved.
//

#import "MeaningListDataParser.h"

#import "AbbreviationEntity.h"

#define kSFKey @"sf"
#define kLFKey @"lf"
#define kFrequencyKey @"freq"
#define kSinceKey @"since"
#define kAbbreviationsKey @"lfs"


@implementation MeaningListDataParser

- (NSArray *) parseMeaningListData:(id)dataObject
{
    
    if(dataObject != nil && [dataObject isKindOfClass:[NSArray class]])
    {
        
        NSMutableArray *dataList = [[NSMutableArray alloc] init];
        
        for (id item  in (NSArray *)dataObject) {
            
            MeaningsEntity *dataEntity = [self parseMeaningsDataObject:item];
            
            if(dataEntity != nil)
            {
                [dataList addObject:dataEntity];
            }
        }
        
        return dataList;
    }
    
    return nil;
}

- (MeaningsEntity *) parseMeaningsDataObject:(id)dataObject
{
    
    if(dataObject != nil && [dataObject isKindOfClass:[NSDictionary class]])
    {
        
        NSDictionary *dataDictionary = (NSDictionary *)dataObject;
        
        MeaningsEntity *entity = [[MeaningsEntity alloc] init];
        
        entity.sf = [self getStringData:dataDictionary forKey:kSFKey];
        
        entity.abbreviations = [self parseAbbreviationsArrayData:[dataDictionary objectForKey:kAbbreviationsKey]];
        
        return entity;
    }
    
    return nil;
}


- (NSArray *) parseAbbreviationsArrayData:(id)dataObject
{
    if(dataObject != nil && [dataObject isKindOfClass:[NSArray class]])
    {
        
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        
        for(id item in (NSArray *)dataObject)
        {
            AbbreviationEntity * entity = [self parserAbbreviationDataObject:item];
            
            [dataArray addObject:entity];
        }
        
        return dataArray;
    }
    
    return nil;
}

- (AbbreviationEntity *) parserAbbreviationDataObject:(id)dataObject
{
    if(dataObject != nil && [dataObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dataDictionary = (NSDictionary *)dataObject;
        
        AbbreviationEntity *entity = [[AbbreviationEntity alloc] init];
        
        entity.lf = [self getStringData:dataDictionary forKey:kLFKey];
        
        entity.frequency = [self getNumberData:(NSDictionary *)dataObject forKey:kFrequencyKey];
        
        entity.since = [self getNumberData:(NSDictionary *)dataObject forKey:kSinceKey];
        
        return entity;
    }
    
    return nil;
}


- (NSString *) getStringData:(NSDictionary *)dic forKey:(NSString *)key
{
    
    if(dic == nil || [dic isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    
    NSObject *data = [dic objectForKey:key];
    
    if(data != nil && [data isKindOfClass:[NSString class]])
    {
        
        NSString *strData = (NSString *)data;
        
        return strData;
    }
    
    return nil;
}

- (NSNumber *) getNumberData:(NSDictionary *)dic forKey:(NSString *)key
{
    if(dic == nil || [dic isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    
    NSObject *data = [dic objectForKey:key];
    
    if(data != nil && [data isKindOfClass:[NSNumber class]])
    {
        return (NSNumber *)data;
    }
    
    return nil;
}


@end
