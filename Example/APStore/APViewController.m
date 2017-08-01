//
//  APViewController.m
//  APStore
//
//  Created by 673697831 on 04/27/2017.
//  Copyright (c) 2017 673697831. All rights reserved.
//

#import "APViewController.h"
#import "APStoreManager.h"
#import "APTestModel.h"

@interface APViewController ()

@end

@implementation APViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"%@", NSHomeDirectory());
    APTestModel *testModel = [APTestModel new];
    testModel.nickname = @"123456";
    testModel.uid = 555;
    APStoreManager *manager = [APStoreManager new];
    [manager testSetModel:testModel];
    NSLog(@"%@", [manager testGetModel]);
}


@end
