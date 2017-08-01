//
//  APBaseModel.m
//  APStore
//
//  Created by ozr on 17/4/28.
//  Copyright © 2017年 673697831. All rights reserved.
//

#import "APBaseModel.h"
#import <YYModel.h>

@implementation APBaseModel

- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
- (NSUInteger)hash { return [self yy_modelHash]; }
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }
- (NSString *)description { return [self yy_modelDescription]; }

@end
