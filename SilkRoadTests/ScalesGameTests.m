//
//  ScalesGameTests.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 11/2/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ScalesGameModel.h"
#import "Constants.h"

@interface ScalesGameTests : XCTestCase

@end

@implementation ScalesGameTests

- (void)setUp
{
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testNewGame
{
  ScalesGameModel* testModel = [[ScalesGameModel alloc] init];
  [testModel newGame];
  
  // Impicitly test getter methods
  NSMutableArray* testTray = [testModel getCoinsInTray];
  NSMutableArray* testRight = [testModel getCoinsInRightScale];
  NSMutableArray* testLeft = [testModel getCoinsInLeftScale];
  
  // Check that there are coins in the tray and none in the scales
  XCTAssertGreaterThanOrEqual([testTray count], 8);
  XCTAssertLessThanOrEqual([testTray count], 12);
  XCTAssertEqual([testLeft count], 0);
  XCTAssertEqual([testRight count], 0);
  
  // Check that one and only one fake coin was created
  BOOL fakeExists = NO;
  BOOL dupFakes = NO;
  
  for (int i = 0; i < [testTray count]; i++) {
    ScalesGameCoin* coin = [testTray objectAtIndex:i];
    
    if (!fakeExists && [coin weight] != 1) {
      fakeExists = YES;
    }
    else if (fakeExists && [coin weight] != 1) {
      dupFakes = YES;
    }
  }
  
  XCTAssertTrue(fakeExists);
  XCTAssertFalse(dupFakes);
}

- (void)testMoveCoinsLeftToRight
{
  ScalesGameModel* testModel = [[ScalesGameModel alloc] init];
  [testModel newGame];
  
  // Impicitly test getter methods
  NSMutableArray* testTray = [testModel getCoinsInTray];
  NSMutableArray* testRight = [testModel getCoinsInRightScale];
  NSMutableArray* testLeft = [testModel getCoinsInLeftScale];
  int numCoins = (int)[testTray count];
  
  // Arbitrarily pick a coin -- there will always be between 8-12 coins in the
  // tray to start, so picking anything less than 8 should be safe
  ScalesGameCoin* coin = [testTray objectAtIndex:4];
  
  // Move this coin into the left tray
  [testModel moveCoin:coin toPlace:SCALES_LEFT];
  
  // Check that it was moved
  testTray = [testModel getCoinsInTray];
  testLeft = [testModel getCoinsInLeftScale];
  XCTAssertEqual([testTray count], numCoins - 1);
  XCTAssertEqual([testLeft count], 1);
  
  // Move this coin into the right scale
  [testModel moveCoin:coin toPlace:SCALES_RIGHT];
  
  // Check that it was moved
  testLeft = [testModel getCoinsInLeftScale];
  testRight = [testModel getCoinsInRightScale];
  XCTAssertEqual([testLeft count], 0);
  XCTAssertEqual([testRight count], 1);
  
  // Move the coin back into the tray
  [testModel moveCoin:coin toPlace:SCALES_TRAY];
  
  // Check that it was moved
  testTray = [testModel getCoinsInTray];
  testRight = [testModel getCoinsInRightScale];
  XCTAssertEqual([testTray count], numCoins);
  XCTAssertEqual([testRight count], 0);
}

- (void)testMoveCoinsRightToLeft
{
  ScalesGameModel* testModel = [[ScalesGameModel alloc] init];
  [testModel newGame];
  
  // Impicitly test getter methods
  NSMutableArray* testTray = [testModel getCoinsInTray];
  NSMutableArray* testRight = [testModel getCoinsInRightScale];
  NSMutableArray* testLeft = [testModel getCoinsInLeftScale];
  int numCoins = (int)[testTray count];
  
  // Arbitrarily pick a coin -- there will always be between 8-12 coins in the
  // tray to start, so picking anything less than 8 should be safe
  ScalesGameCoin* coin = [testTray objectAtIndex:4];
  
  // Move this coin into the right tray
  [testModel moveCoin:coin toPlace:SCALES_RIGHT];
  
  // Check that it was moved
  testTray = [testModel getCoinsInTray];
  testRight = [testModel getCoinsInRightScale];
  XCTAssertEqual([testTray count], numCoins - 1);
  XCTAssertEqual([testRight count], 1);
  
  // Move this coin into the left scale
  [testModel moveCoin:coin toPlace:SCALES_LEFT];
  
  // Check that it was moved
  testRight = [testModel getCoinsInRightScale];
  testLeft = [testModel getCoinsInLeftScale];
  XCTAssertEqual([testRight count], 0);
  XCTAssertEqual([testLeft count], 1);
  
  // Move the coin back into the tray
  [testModel moveCoin:coin toPlace:SCALES_TRAY];
  
  // Check that it was moved
  testTray = [testModel getCoinsInTray];
  testLeft = [testModel getCoinsInLeftScale];
  XCTAssertEqual([testTray count], numCoins);
  XCTAssertEqual([testRight count], 0);
}

- (void)testCheckScalesAndIdentifyFake
{
  ScalesGameModel* testModel = [[ScalesGameModel alloc] init];
  [testModel newGame];
  
  // Impicitly test getter methods
  NSMutableArray* testTray = [testModel getCoinsInTray];
  
  // At this point, the scales should be balanced
  XCTAssertEqual([testModel checkScales], 0);
  
  // Put half the coins in the left scale and half the coins in the right,
  // looking for the fake coin as we go
  int numCoins = (int)[testTray count];
  ScalesGameCoin* fakeCoin;
  int fakeLocation = 0;
  int fakeWeight = 1;
  
  // Put the coins into the left scale first
  for (int i = 0; i < numCoins/2; i++) {
    ScalesGameCoin* coin = [testTray objectAtIndex:0];
    
    if ([coin weight] != 1) {
      // This should be a fake coin!
      XCTAssertTrue([testModel checkIfCoinFake:coin]);
      fakeCoin = coin;
      fakeLocation = 1;
      fakeWeight = [coin weight];
    }
    else {
      //Otherwise this shouldn't be a fake coin!
      XCTAssertFalse([testModel checkIfCoinFake:coin]);
    }
    
    [testModel moveCoin:coin toPlace:SCALES_LEFT];
  }
  
  // At this point, the left scale should be heavier
  XCTAssertEqual([testModel checkScales], 1);
  
  // Now put the coins into the right scale
  for (int i = 0; i < numCoins/2; i++) {
    ScalesGameCoin* coin = [testTray objectAtIndex:0];
    
    if ([coin weight] != 1) {
      // This should be a fake coin!
      XCTAssertTrue([testModel checkIfCoinFake:coin]);
      fakeCoin = coin;
      fakeLocation = 2;
      fakeWeight = [coin weight];
    }
    else {
      //Otherwise this shouldn't be a fake coin!
      XCTAssertFalse([testModel checkIfCoinFake:coin]);
    }
    
    [testModel moveCoin:coin toPlace:SCALES_RIGHT];
  }
  
  // Depending on the weight of the coin and which scale it is in, we
  // expect different outputs from checking the scale
  //   If it's a lighter coin on the left or a heavier coin on the right,
  //     the right scale will be heavier
  //   Otherwise it's a heavier coin on the left or a lighter coin on the right,
  //     so the left side will be heavier
  if ((fakeLocation == 1 && fakeWeight == 0) || (fakeLocation == 2 && fakeWeight == 2)) {
    XCTAssertEqual([testModel checkScales], 2);
  }
  else {
    XCTAssertEqual([testModel checkScales], 1);
  }
  
  // If we take out the fake coin and one coin from the other side, the scales
  // should be balanced again
  [testModel moveCoin:fakeCoin toPlace:SCALES_TRAY];
  
  if (fakeLocation == 1) {
    NSMutableArray* testRight = [testModel getCoinsInRightScale];
    ScalesGameCoin* coin = [testRight objectAtIndex:0];
    [testModel moveCoin:coin toPlace:SCALES_TRAY];
  }
  else {
    NSMutableArray* testLeft = [testModel getCoinsInLeftScale];
    ScalesGameCoin* coin = [testLeft objectAtIndex:0];
    [testModel moveCoin:coin toPlace:SCALES_TRAY];
  }
  
}

@end
