//
//  StageTests.m
//  SilkRoad
//
//  Created by Melissa Galonsky on 11/1/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StageModel.h"

@interface StageTests : XCTestCase {
    StageModel* _stageModel;
}
@end

@implementation StageTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _stageModel = [[StageModel alloc] initForStage:0];
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//Tests if the visit house and visited houses methods work.
-(void)testVisitHouse
{
    [_stageModel visitHouse:0];
    BOOL hasVisitedHouses = [_stageModel visitedAllHouses];
    XCTAssertTrue(hasVisitedHouses == NO, @"hasVisitedHouses improperly returns true");
    
    for (int i = 0; i < 4; ++i) {
        [_stageModel visitHouse:i];
    }
    
    hasVisitedHouses = [_stageModel visitedAllHouses];
    XCTAssertTrue(hasVisitedHouses == YES, @"hasVisitedHouses improperly returns false");
}

//Tests adding a house
-(void)testAddHouse
{
    NSString* newHouse = @"Melissa, 500, 500, IndiaHouse_400, 4";
    [_stageModel addHouse:newHouse];
    NSMutableArray* houses = [_stageModel getHouses];
    XCTAssertTrue([houses count] == 5, @"addHouse doesn't correctly add houses");
    
}

- (void)testExample
{
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}



@end
