//
//  APStoreManager.m
//  APStore
//
//  Created by ozr on 17/4/28.
//  Copyright © 2017年 673697831. All rights reserved.
//

#import "APStoreManager.h"
#import "APTestModel.h"
#import <APKeyValueStore.h>
#import <YYModel.h>

#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

static NSString *const DEFAULT_DB_NAME = @"aipai.sqlite";
static NSString *const kTableName1 = @"table1";
static NSString *const kTableName2 = @"table2";
static NSString *const kTableName3 = @"table3";

@interface APStoreManager ()

@property (nonatomic, strong) APKeyValueStore *keyValueStore;

@end

@implementation APStoreManager

- (instancetype)init
{
    if (self = [super init]) {
        _keyValueStore = [APKeyValueStore storeWithDBPath:[PATH_OF_DOCUMENT stringByAppendingPathComponent:DEFAULT_DB_NAME] encryptKey:nil];
    }
    
    return self;
}

- (void)testSetModel:(id)obj
{
    [self putObject:obj withId:@"0" intoTable:kTableName3];
}

- (id)testGetModel
{
    return [self getObjectById:@"0" fromTable:kTableName3 modelClass:[APTestModel class] afterDate:nil];
}

- (void)testInsertArray
{
    [self.keyValueStore clearTable:kTableName1];
    NSMutableArray *array = [NSMutableArray new];
    NSMutableArray *idArray = [NSMutableArray new];
    for (int i = 0; i < 100; i ++) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic[@"value"] = @(i);
        [array addObject:dic];
        [idArray addObject:@(i).stringValue];
    }
    
    [self.keyValueStore insertObjectsByIdArray:idArray
                                     withArray:array
                                     fromTable:kTableName1];
    
}

- (void)testSetArray
{
    [self.keyValueStore clearTable:kTableName2];
    NSMutableArray *array = [NSMutableArray new];
    NSMutableArray *idArray = [NSMutableArray new];
    for (int i = 0; i < 100; i ++) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic[@"value"] = @(i);
        [array addObject:dic];
        [idArray addObject:@(i)];
    }
    [self.keyValueStore putObject:array
                           withId:@"1"
                        intoTable:kTableName2];
}

- (id)getData1
{
    return [self getAllObjectFromTable:kTableName1 modelClass:nil afterDate:[NSDate dateWithTimeIntervalSinceNow:-1000]];
}

- (id)getData2
{
    return [self getObjectById:@"1" fromTable:kTableName2 modelClass:nil afterDate:[NSDate date]];
}

- (void)testClearAllBeforeDate:(NSDate *)date
{
    [self deleteObjectFromTable:kTableName1 beforeDate:date];
}

- (void)testClearCacheWithId:(NSString *)objectId
                  BeforeDate:(NSDate *)date
{
    [self deleteObjectWithObjectById:objectId fromTable:kTableName1 beforeDate:date];
}

#pragma mark - store

- (id)generatedJSONWithObj:(id)obj
{
    if ([obj isKindOfClass:[NSArray class]]) {
        NSMutableArray *jsonArray = [NSMutableArray new];
        for (id subObj in obj) {
            id subJson = [self generatedJSONWithObj:subObj];
            [jsonArray addObject:subJson];
        }
        
        return jsonArray;
    }
    
    return [obj yy_modelToJSONObject];
//    NSError *error = nil;
//    if ([obj conformsToProtocol:NSProtocolFromString(@"MTLJSONSerializing")] && [obj isKindOfClass:[MTLModel class]]) {
//        dictionary = [NSMutableDictionary dictionaryWithDictionary:[MTLJSONAdapter JSONDictionaryFromModel:obj error:&error]];
    
//    if ([obj isKindOfClass:[NSDictionary class]])
//    {
//        dictionary = [NSMutableDictionary dictionaryWithDictionary:obj];
//    }
//    
//    
//    if (error != nil) {
//        return nil;
//    }
//    
//    return dictionary;
}

- (BOOL)putObject:(id)object
           withId:(NSString *)objectId
        intoTable:(NSString *)tableName
{
    id json = [self generatedJSONWithObj:object];
    if (json == nil) {
        return NO;
    }else
    {
        return [self.keyValueStore putObject:json withId:objectId intoTable:tableName];
    }
}

- (BOOL)insertObjects:(NSArray *)objects
          withIdArray:(NSArray *)idArray
            intoTable:(NSString *)tableName
{
    NSArray *jsonArray = [self generatedJSONWithObj:objects];
    return [self.keyValueStore insertObjectsByIdArray:idArray
                                            withArray:jsonArray
                                            fromTable:tableName];
}

- (id)getObjectWithJSON:(id)json
             modelClass:(Class)modelClass
{
    if ([json isKindOfClass:[NSArray class]]) {
        NSMutableArray *objectArray = [NSMutableArray new];
        for (id subJson in json) {
            id subObj = [self getObjectWithJSON:subJson modelClass:modelClass];
            if (subObj) {
                [objectArray addObject:subObj];
            }
        }
        
        return objectArray;
    }
    
    if ([json isKindOfClass:[NSDictionary class]]) {
        if (modelClass == nil) {
            return json;
        }
        
//        NSError *error;
//        MTLModel<MTLJSONSerializing> *object = [MTLJSONAdapter modelOfClass:modelClass
//                                                         fromJSONDictionary:json
//                                                                      error:&error];
//        if (error) {
//            NSLog(@"转换model失败");
//            return nil;
//        }
//        return object;
        
        return [modelClass yy_modelWithJSON:json]?:json;
        
    }
    
    return json;
}

- (id)getObjectById:(NSString *)objectId
          fromTable:(NSString *)tableName
         modelClass:(Class)modelClass
          afterDate:(NSDate *)date
{
    id json = [self.keyValueStore getObjectById:objectId fromTable:tableName afterDate:date];
    return [self getObjectWithJSON:json modelClass:modelClass];
}

- (id)getAllObjectFromTable:(NSString *)tableName
                 modelClass:(Class)modelClass
                  afterDate:(NSDate *)date
{
    NSArray *jsonObjects = [self.keyValueStore getAllItemObjectsFromTable:tableName afterDate:date];
    return [self getObjectWithJSON:jsonObjects modelClass:modelClass];
}

- (void)deleteObjectWithObjectById:(NSString *)objectId fromTable:(NSString *)tableName beforeDate:(NSDate *)date
{
    [self.keyValueStore deleteObjectWithObjectById:objectId fromTable:tableName beforeDate:date];
}

- (void)deleteObjectFromTable:(NSString *)tableName beforeDate:(NSDate *)date
{
    [self.keyValueStore deleteObjectFromTable:tableName beforeDate:date];
}

@end
