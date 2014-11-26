//
//  RoadGameTests.m
//  SilkRoad
//
//  Created by CS121 on 11/2/14.
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
  //int* passWord = new int[4];
  int password[4] = {0, 1, 1, 1};
  [_gameModel setPassword:password];
  //[_gameModel initializeGameForLevel:0];
  // Put setup code here. Tpasswordhis method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}


-(void)testGetMatchesFromAttempt
{
  int password1[4] = {0, 1, 1, 0};
  XCTAssertEqual([_gameModel getMatchesFromAttempt:password1], 30);
  int password2[4] = {0, 1, 0, 2};
  XCTAssertEqual([_gameModel getMatchesFromAttempt:password2], 22);
}

//for testing
//-(void)setPassword:(int*)mockPassword;


@end