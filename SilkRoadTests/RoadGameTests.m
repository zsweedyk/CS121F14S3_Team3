//
//  RoadGameTests.m
//  SilkRoad
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "RoadGameModel.h"

@interface RoadGameTests : XCTestCase {
  RoadGameModel* _gameModel;
}

@end

@implementation RoadGameTests

- (void)setUp {
    [super setUp];
  _gameModel = [[RoadGameModel alloc] init];
  [_gameModel initGridWithFile:@"RoadPuzzle1"];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConnectionValidBetweenNodesInSameRow
{
  XCTAssertTrue([_gameModel connectionIsValidForRow:0 Col:7 AndRow:0 Col:8]);
}

- (void)testConnectionValidBetweenNodesInSameCol
{
  XCTAssertTrue([_gameModel connectionIsValidForRow:7 Col:0 AndRow:8 Col:0]);
}

- (void)testConnectionInvalidBetweenNodeAndItself
{
  XCTAssertFalse([_gameModel connectionIsValidForRow:0 Col:0 AndRow:0 Col:0]);
}

- (void)testConnectionInvalidBetweenNonadjacentNodes
{
  // Interrupting node located at 8, 2 - rowwise interruption
  XCTAssertFalse([_gameModel connectionIsValidForRow:8 Col:0 AndRow:8 Col:4]);
  
  // Interrupting node located at 2, 6 - columnwise
  XCTAssertFalse([_gameModel connectionIsValidForRow:0 Col:6 AndRow:6 Col:6]);
}

- (void)testGetNumConnections
{
  XCTAssertEqual([_gameModel getNumConnectionsToNodeAtRow:0 Col:1], 0);
  XCTAssertEqual([_gameModel getNumConnectionsToNodeAtRow:0 Col:0], 1);
}

- (void)testIncreasingNumConnectionsOfNode
{
  // Number of connections of node 0,0 is 1 at beginning
  XCTAssertEqual([_gameModel getNumConnectionsToNodeAtRow:0 Col:0], 1);
  
  // Number of available connections to make should be 0
  XCTAssertEqual([_gameModel addConnectionToNodeAtRow:0 Col:0], 0);
}

- (void)testResetingNumConnectionsOfNode
{
  // Number of connections of node 0,0 is 1 at beginning
  XCTAssertEqual([_gameModel getNumConnectionsToNodeAtRow:0 Col:0], 1);

  XCTAssertEqual([_gameModel addConnectionToNodeAtRow:0 Col:0], 0);
  
  // Reset back to 1
  XCTAssertEqual([_gameModel resetNodeAtRow:0 Col:0], 1);
}

- (void)testAddingOneConnectionBetweenNodes
{
  XCTAssertEqual([_gameModel addConnectionBetweenRow:8 Col:0 AndRow:8 Col:2], 1);
}

- (void)testAddingTwoConnectionsBetweenNodes
{
  [_gameModel addConnectionBetweenRow:8 Col:0 AndRow:8 Col:2];
  XCTAssertEqual([_gameModel addConnectionBetweenRow:8 Col:0 AndRow:8 Col:2], 2);
}

// Node 8,0 and 8,2 both can have 4 connections between them.
// If a player tries to connect them three times, should reset back to 0
-(void)testResettingConnectionBetweenNodes
{
  [_gameModel addConnectionBetweenRow:8 Col:0 AndRow:8 Col:2];
  [_gameModel addConnectionBetweenRow:8 Col:0 AndRow:8 Col:2];
  XCTAssertEqual([_gameModel addConnectionBetweenRow:8 Col:0 AndRow:8 Col:2], 0);
}

// Node 0, 0 only has one connection, so trying to add another connection to
// 8,0 after one has been established should reset it
-(void)testResettingConnectionBetweenNodesOfValueOne
{
  [_gameModel addConnectionBetweenRow:0 Col:0 AndRow:8 Col:0];
  XCTAssertEqual([_gameModel addConnectionBetweenRow:0 Col:0 AndRow:8 Col:0], 0);
}

@end
