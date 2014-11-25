//
//  StageControllerTests.m
//  SilkRoad
//
//  Created by CS121 on 11/23/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "StageController.h"

@interface StageControllerTests : XCTestCase
{
  StageController* _stageController;
}

@end

@implementation StageControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
  
  _stageController = [[StageController alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSetStageTo {
    // This is an example of a functional test case.
  [_stageController setStageTo:0];
  //XCTAssertEqual(_stageController._currentStage, <#expression2, ...#>)
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
