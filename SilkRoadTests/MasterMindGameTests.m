//
//  RoadGameTests.m
//  SilkRoad
//
//  Created by CS121 on 11/2/13.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MasterMindGameModel.h"

@interface MasterMindGameTests : XCTestCase {
  MasterMindGameModel* _gameModel;
}

@end

@implementation MasterMindGameTests

- (void)setUp
{
  [super setUp];
  _gameModel = [[MasterMindGameModel alloc] init];
  // Put setup code here. Tpasswordhis method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

-(void)testMakeNewSolution
{
  int password[3] = {0, 0, 0};
  [_gameModel setPassword:password];
  [_gameModel makeNewSolution];
  int oldPassword[3] = {0,0,0};
  XCTAssertNotEqual([_gameModel getMatchesFromAttempt:oldPassword], 30);
}

-(void)testResetGame
{
  int password[3] = {0, 0, 0};
  [_gameModel setPassword:password];
  [_gameModel resetGame];
  int oldPassword[3] = {0,0,0};
  XCTAssertNotEqual([_gameModel getMatchesFromAttempt:oldPassword], 30);
  XCTAssert(![_gameModel hasBeenWon]);
}

-(void)testGetMatchesFromAttempt_ThreeColorPassword
{
  int password[3] = {0, 1, 2};
  [_gameModel setPassword:password];
  int password1[3] = {0, 1, 2};
  XCTAssertEqual([_gameModel getMatchesFromAttempt:password1], 30);
  int password2[3] = {0, 1, 0};
  XCTAssertEqual([_gameModel getMatchesFromAttempt:password2], 20);
  int password3[3] = {0, 0, 0};
  XCTAssertEqual([_gameModel getMatchesFromAttempt:password3], 10);
  int password4[3] = {1, 2, 0};
  XCTAssertEqual([_gameModel getMatchesFromAttempt:password4], 3);
  int password5[3] = {1, 2, 1};
  XCTAssertEqual([_gameModel getMatchesFromAttempt:password5], 2);
  int password6[3] = {0, 2, 1};
  XCTAssertEqual([_gameModel getMatchesFromAttempt:password6], 12);
}

-(void)testGetMatchesFromAttempt_TwoColorPassword
{
  int password[3] = {0, 1, 1};
  [_gameModel setPassword:password];
  int password1[3] = {0, 1, 1};
  XCTAssertEqual([_gameModel getMatchesFromAttempt:password1], 30);
  int password2[3] = {0, 1, 0};
  XCTAssertEqual([_gameModel getMatchesFromAttempt:password2], 20);
  int password3[3] = {0, 0, 0};
  XCTAssertEqual([_gameModel getMatchesFromAttempt:password3], 10);
  int password4[3] = {1, 2, 0};
  XCTAssertEqual([_gameModel getMatchesFromAttempt:password4], 2);
  int password5[3] = {1, 2, 2};
  XCTAssertEqual([_gameModel getMatchesFromAttempt:password5], 1);
  int password6[3] = {2, 2, 2};
  XCTAssertEqual([_gameModel getMatchesFromAttempt:password6], 0);
  int password7[3] = {1, 1, 2};
  XCTAssertEqual([_gameModel getMatchesFromAttempt:password7], 11);
  int password8[3] = {1, 0, 1};
  XCTAssertEqual([_gameModel getMatchesFromAttempt:password8], 12);
}

-(void)testGetMatchesFromAttempt_OneColorPassword
{
  int password[3] = {1, 1, 1};
  [_gameModel setPassword:password];
  int password1[3] = {1, 1, 1};
  XCTAssertEqual([_gameModel getMatchesFromAttempt:password1], 30);
  int password2[3] = {0, 0, 0};
  XCTAssertEqual([_gameModel getMatchesFromAttempt:password2], 0);
  int password3[3] = {1, 0, 0};
  XCTAssertEqual([_gameModel getMatchesFromAttempt:password3], 10);
  int password4[3] = {1, 1, 0};
  XCTAssertEqual([_gameModel getMatchesFromAttempt:password4], 20);
}

-(void)testHasBeenWon
{
  int password1[3] = {0, 1, 1};
  [_gameModel setPassword:password1];
  XCTAssertEqual([_gameModel getMatchesFromAttempt:password1], 30);
  XCTAssert([_gameModel hasBeenWon]);
}


@end