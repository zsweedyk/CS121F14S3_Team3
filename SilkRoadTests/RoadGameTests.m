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
  [_gameModel initGridWithFile:@"RoadTestGrid"];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConnectionIsValid
{
  // Nodes in same row
  XCTAssertTrue([_gameModel connectionIsValidForRow:8 Col:0 AndRow:8 Col:2]);
  // Nodes in same column
  XCTAssertTrue([_gameModel connectionIsValidForRow:0 Col:0 AndRow:2 Col:0]);
  // Nodes not in same row or column
   XCTAssertFalse([_gameModel connectionIsValidForRow:8 Col:0 AndRow:7 Col:3]);
  // Node should not be able to connect to self
  XCTAssertFalse([_gameModel connectionIsValidForRow:0 Col:0 AndRow:0 Col:0]);
  
  // Interrupting node located at 8, 2 - rowwise interruption
  XCTAssertFalse([_gameModel connectionIsValidForRow:8 Col:0 AndRow:8 Col:4]);
  
  // Interrupting node located at 2, 6 - columnwise
  XCTAssertFalse([_gameModel connectionIsValidForRow:0 Col:0 AndRow:4 Col:0]);
}

- (void)testGetNumAvailableConnections
{
  XCTAssertEqual([_gameModel getNumAvailableConnectionsToNodeAtRow:0 Col:1], 0);
  XCTAssertEqual([_gameModel getNumAvailableConnectionsToNodeAtRow:0 Col:0], 1);
}

- (void)testGetNumConnectionsBetweenNode
{
  XCTAssertEqual([_gameModel getNumConnectionsBetweenRow:8 Col:0 AndRow:8 Col:2], 0);
}

- (void)testAddConnectionBetweenNodes
{
  XCTAssertEqual([_gameModel getNumAvailableConnectionsToNodeAtRow:8 Col:0], 2);
  XCTAssertEqual([_gameModel getNumAvailableConnectionsToNodeAtRow:8 Col:2], 4);
  XCTAssertEqual([_gameModel getNumConnectionsBetweenRow:8 Col:0 AndRow:8 Col:2], 0);
  
  [_gameModel addConnectionBetweenRow:8 Col:0 AndRow:8 Col:2];
  
  XCTAssertEqual([_gameModel getNumAvailableConnectionsToNodeAtRow:8 Col:0], 1);
  XCTAssertEqual([_gameModel getNumAvailableConnectionsToNodeAtRow:8 Col:2], 3);
  XCTAssertEqual([_gameModel getNumConnectionsBetweenRow:8 Col:0 AndRow:8 Col:2], 1);
  
  [_gameModel addConnectionBetweenRow:8 Col:0 AndRow:8 Col:2];
  
  XCTAssertEqual([_gameModel getNumAvailableConnectionsToNodeAtRow:8 Col:0], 0);
  XCTAssertEqual([_gameModel getNumAvailableConnectionsToNodeAtRow:8 Col:2], 2);
  XCTAssertEqual([_gameModel getNumConnectionsBetweenRow:8 Col:0 AndRow:8 Col:2], 2);
}

- (void)testResetConnectionBetweenNodes
{
  [_gameModel addConnectionBetweenRow:8 Col:0 AndRow:8 Col:2];
  [_gameModel resetConnectionBetweenRow:8 Col:0 AndRow:8 Col:2];
  
  XCTAssertEqual([_gameModel getNumAvailableConnectionsToNodeAtRow:8 Col:0], 2);
  XCTAssertEqual([_gameModel getNumAvailableConnectionsToNodeAtRow:8 Col:2], 4);
  XCTAssertEqual([_gameModel getNumConnectionsBetweenRow:8 Col:0 AndRow:8 Col:2], 0);
  
  [_gameModel addConnectionBetweenRow:8 Col:0 AndRow:8 Col:2];
  [_gameModel addConnectionBetweenRow:8 Col:0 AndRow:8 Col:2];
  [_gameModel resetConnectionBetweenRow:8 Col:0 AndRow:8 Col:2];
  
  XCTAssertEqual([_gameModel getNumAvailableConnectionsToNodeAtRow:8 Col:0], 2);
  XCTAssertEqual([_gameModel getNumAvailableConnectionsToNodeAtRow:8 Col:2], 4);
  XCTAssertEqual([_gameModel getNumConnectionsBetweenRow:8 Col:0 AndRow:8 Col:2], 0);
}

- (void)testHasBeenWon
{
  XCTAssertEqual([_gameModel hasBeenWon], NO);
  [_gameModel addConnectionBetweenRow:0 Col:0 AndRow:2 Col:0];
  [_gameModel addConnectionBetweenRow:2 Col:0 AndRow:4 Col:0];
  [_gameModel addConnectionBetweenRow:8 Col:0 AndRow:8 Col:2];
  [_gameModel addConnectionBetweenRow:8 Col:0 AndRow:8 Col:2];
  [_gameModel addConnectionBetweenRow:8 Col:2 AndRow:8 Col:4];
  [_gameModel addConnectionBetweenRow:8 Col:2 AndRow:8 Col:4];
  XCTAssertEqual([_gameModel hasBeenWon], YES);
}

- (void)testNumConnectionsAfterUpdate
{
  XCTAssertEqual([_gameModel numConnectionsAfterUpdateForRow:8 Col:0 AndRow:8 Col:2], 1);
  [_gameModel addConnectionBetweenRow:8 Col:0 AndRow:8 Col:2];
  XCTAssertEqual([_gameModel numConnectionsAfterUpdateForRow:8 Col:0 AndRow:8 Col:2], 2);
  [_gameModel addConnectionBetweenRow:8 Col:0 AndRow:8 Col:2];
  XCTAssertEqual([_gameModel numConnectionsAfterUpdateForRow:8 Col:0 AndRow:8 Col:2], 0);
  
  XCTAssertEqual([_gameModel numConnectionsAfterUpdateForRow:0 Col:0 AndRow:2 Col:0], 1);
  [_gameModel addConnectionBetweenRow:0 Col:0 AndRow:2 Col:0];
  XCTAssertEqual([_gameModel numConnectionsAfterUpdateForRow:0 Col:0 AndRow:2 Col:0], 0);
}

- (void)testAddConnectionToNode
{
  XCTAssertEqual([_gameModel getNumAvailableConnectionsToNodeAtRow:0 Col:0], 1);
  [_gameModel addConnectionToNodeAtRow:0 Col:0];
  XCTAssertEqual([_gameModel getNumAvailableConnectionsToNodeAtRow:0 Col:0], 0);
  
  XCTAssertEqual([_gameModel getNumAvailableConnectionsToNodeAtRow:8 Col:0], 2);
  [_gameModel addConnectionToNodeAtRow:8 Col:0];
  XCTAssertEqual([_gameModel getNumAvailableConnectionsToNodeAtRow:8 Col:0], 1);
  [_gameModel addConnectionToNodeAtRow:8 Col:0];
  XCTAssertEqual([_gameModel getNumAvailableConnectionsToNodeAtRow:8 Col:0], 0);
}
- (void)testResetNode
{
  [_gameModel addConnectionToNodeAtRow:0 Col:0];
  [_gameModel resetNodeAtRow:0 Col:0 ByValue:1];
  XCTAssertEqual([_gameModel getNumAvailableConnectionsToNodeAtRow:0 Col:0], 1);
  
  [_gameModel addConnectionToNodeAtRow:8 Col:0];
  [_gameModel addConnectionToNodeAtRow:8 Col:0];
  [_gameModel resetNodeAtRow:8 Col:0 ByValue:2];
  XCTAssertEqual([_gameModel getNumAvailableConnectionsToNodeAtRow:8 Col:0], 2);
}

- (void)testSetNumConnectionsBetweenNodes
{
  XCTAssertEqual([_gameModel getNumConnectionsBetweenRow:8 Col:0 AndRow:8 Col:2], 0);
  [_gameModel setNumConnectionsBetweenRow:8 Col:0 AndRow:8 Col:2 ToValue:2];
  XCTAssertEqual([_gameModel getNumConnectionsBetweenRow:8 Col:0 AndRow:8 Col:2], 2);
}

- (void)testResetGame
{
  XCTAssertEqual([_gameModel getNumConnectionsBetweenRow:8 Col:0 AndRow:8 Col:2], 0);
  XCTAssertEqual([_gameModel getNumAvailableConnectionsToNodeAtRow:8 Col:0], 2);
  [_gameModel setNumConnectionsBetweenRow:8 Col:0 AndRow:8 Col:2 ToValue:2];
  XCTAssertEqual([_gameModel getNumAvailableConnectionsToNodeAtRow:8 Col:0], 2);
  
  [_gameModel resetGame];
  XCTAssertEqual([_gameModel getNumConnectionsBetweenRow:8 Col:0 AndRow:8 Col:2], 0);
  XCTAssertEqual([_gameModel getNumAvailableConnectionsToNodeAtRow:8 Col:0], 2);
}
@end
