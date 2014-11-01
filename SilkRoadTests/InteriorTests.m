//
//  InteriorTests.m
//  SilkRoad
//
//  Created by Melissa Galonsky on 11/1/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "InteriorModel.h"

@interface InteriorTests : XCTestCase

@end

@implementation InteriorTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

//Tests to see if the model inits and returns any dialogue.
- (void)testInit;
{
    InteriorModel* model = [[InteriorModel alloc] init];
    [model initializeAllDialogue];
    [model initForStage:0 andHouse:0];
    NSString* firstLineOfDialogue = [model getNextLineOfDialogue];
    XCTAssertTrue([firstLineOfDialogue length] != 0, @"Doesn't return any dialogue for stage 0 house 0");
}

//Returns no more dialogue at the correct point in time
- (void)testDialogueFinished
{
    InteriorModel* model = [[InteriorModel alloc] init];
    [model initializeAllDialogue];
    [model initForStage:0 andHouse:0];
    while ([model dialogueFinished]) {
        (void)[model getNextLineOfDialogue];
    }
    XCTAssertTrue([model remainingLinesOfDialogue] == 0, @"The interior model claims it has no more dialogue at the wrong time, %d", [model remainingLinesOfDialogue]);
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end
