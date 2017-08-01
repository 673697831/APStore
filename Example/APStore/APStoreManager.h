//
//  APStoreManager.h
//  APStore
//
//  Created by ozr on 17/4/28.
//  Copyright © 2017年 673697831. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APStoreManager : NSObject

- (void)testSetModel:(id)obj;
- (id)testGetModel;
- (void)testInsertArray;
- (void)testSetArray;
- (id)getData1;
- (id)getData2;
- (void)testClearAllBeforeDate:(NSDate *)date;
- (void)testClearCacheWithId:(NSString *)objectId
                  BeforeDate:(NSDate *)date;

@end
