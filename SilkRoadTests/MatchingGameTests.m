//
//  RoadGameTests.m
//  SilkRoad
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MatchingGameModel.h"

@interface MatchingGameTests : XCTestCase {
  MatchingGameModel* _gameModel;
}

@end

@implementation MatchingGameTests

- (void)setUp {
  [super setUp];
  _gameModel = [[MatchingGameModel alloc] init];
  [_gameModel initializeGameForLevel:0];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testGeneratePhrasesForLevel
{
  [_gameModel generatePhrasesForLevel:0];
  NSMutableArray* left = [[NSMutableArray alloc] init];
  left = [_gameModel getLeftSidePhrases];
  NSMutableArray* right = [[NSMutableArray alloc] init];
  right = [_gameModel getRightSidePhrases];
  
  XCTAssert([left count] == [right count]);
  //Check all generated phrases are strings, and that objects on the right != objects on the lft
  for (int i = 0; i < [left count]; ++i) {
    XCTAssert([[left objectAtIndex:i] isKindOfClass:[NSString class]]);
    XCTAssert([[right objectAtIndex:i] isKindOfClass:[NSString class]]);
    XCTAssert([left objectAtIndex:i] != [right objectAtIndex:i]);
  }
}

- (void)testShuffleArray
{
  NSMutableArray* test = [[NSMutableArray alloc] initWithCapacity:2];
  NSNumber* one = [NSNumber numberWithInt:1];
  NSNumber* two = [NSNumber numberWithInt:2];
  [test addObject:one];
  [test addObject:two];
  //In 10 trials, see if the array is shuffled at least once
  BOOL wasShuffled = NO;
  XCTAssert([test objectAtIndex:0] == one);
  XCTAssert([test objectAtIndex:1] == two);
  for (int i = 0; i < 10; i++) {
    [_gameModel shuffleArray:test];
    if ([test objectAtIndex:0] == two) {
      wasShuffled = YES;
    }
  }
  XCTAssert(wasShuffled);
}

- (void)testGetLeftSidePhrases_Level0
{
  [_gameModel generatePhrasesForLevel:0];
  NSMutableArray* left = [[NSMutableArray alloc] init];
  left = [_gameModel getLeftSidePhrases];
  XCTAssert([[left objectAtIndex:0] isEqualToString:@"Number of characters"]);
  XCTAssert([[left objectAtIndex:1] isEqualToString:@"Number of tones"]);
  XCTAssert([[left objectAtIndex:2] isEqualToString:@"Number of pronouns"]);
}

- (void)testGetLeftSidePhrases_Level1
{
  [_gameModel generatePhrasesForLevel:1];
  NSMutableArray* left = [[NSMutableArray alloc] init];
  left = [_gameModel getLeftSidePhrases];
  XCTAssert([[left objectAtIndex:0] isEqualToString:@"Most common coin in China"]);
  XCTAssert([[left objectAtIndex:1] isEqualToString:@"Most valuable currency"]);
  XCTAssert([[left objectAtIndex:2] isEqualToString:@"Number of coins made in 100 years"]);
}

- (void)testGetLeftSidePhrases_Level2
{
  [_gameModel generatePhrasesForLevel:2];
  NSMutableArray* left = [[NSMutableArray alloc] init];
  left = [_gameModel getLeftSidePhrases];
  XCTAssert([[left objectAtIndex:0] isEqualToString:@"Sanskrit"]);
  XCTAssert([[left objectAtIndex:1] isEqualToString:@"Vedas"]);
  XCTAssert([[left objectAtIndex:2] isEqualToString:@"Panini"]);
  XCTAssert([[left objectAtIndex:3] isEqualToString:@"Prakrit"]);
}

- (void)testGetLeftSidePhrases_Level3
{
  [_gameModel generatePhrasesForLevel:3];
  NSMutableArray* left = [[NSMutableArray alloc] init];
  left = [_gameModel getLeftSidePhrases];
  XCTAssert([[left objectAtIndex:0] isEqualToString:@"Metals used"]);
  XCTAssert([[left objectAtIndex:1] isEqualToString:@"Common names of coins"]);
  XCTAssert([[left objectAtIndex:2] isEqualToString:@"Trading without coins"]);
}

- (void)testGetRightSidePhrases_Level0
{
  [_gameModel generatePhrasesForLevel:0];
  NSMutableArray* right = [[NSMutableArray alloc] init];
  right = [_gameModel getRightSidePhrases];
  XCTAssert([[right objectAtIndex:0] isEqualToString:@">100"]);
  XCTAssert([[right objectAtIndex:1] isEqualToString:@"4"]);
  XCTAssert([[right objectAtIndex:2] isEqualToString:@"3"]);
}

- (void)testGetRightSidePhrases_Level1
{
  [_gameModel generatePhrasesForLevel:1];
  NSMutableArray* right = [[NSMutableArray alloc] init];
  right = [_gameModel getRightSidePhrases];
  XCTAssert([[right objectAtIndex:0] isEqualToString:@"Wushu"]);
  XCTAssert([[right objectAtIndex:1] isEqualToString:@"Gold"]);
  XCTAssert([[right objectAtIndex:2] isEqualToString:@"28 billion"]);
}

- (void)testGetRightSidePhrases_Level2
{
  [_gameModel generatePhrasesForLevel:2];
  NSMutableArray* right = [[NSMutableArray alloc] init];
  right = [_gameModel getRightSidePhrases];
  XCTAssert([[right objectAtIndex:0] isEqualToString:@"Language of the well-educated"]);
  XCTAssert([[right objectAtIndex:1] isEqualToString:@"Religious text of Hinduism"]);
  XCTAssert([[right objectAtIndex:2] isEqualToString:@"Indian grammarian who standardized the language"]);
  XCTAssert([[right objectAtIndex:3] isEqualToString:@"Any language dialect in India"]);
}

- (void)testGetRightSidePhrases_Level3
{
  [_gameModel generatePhrasesForLevel:3];
  NSMutableArray* right = [[NSMutableArray alloc] init];
  right = [_gameModel getRightSidePhrases];
  XCTAssert([[right objectAtIndex:0] isEqualToString:@"Gold and Silver"]);
  XCTAssert([[right objectAtIndex:1] isEqualToString:@"Dinara & Suvarna"]);
  XCTAssert([[right objectAtIndex:2] isEqualToString:@"Bartering"]);
}

- (void)testCheckMatchBetweenPhrases
{
  [_gameModel generatePhrasesForLevel:0];
  XCTAssert([_gameModel checkMatchBetweenLeftPhrase:@"Number of characters" andRightPhrase:@">100"]);
  XCTAssert([_gameModel checkMatchBetweenLeftPhrase:@"Number of tones" andRightPhrase:@"4"]);
  XCTAssert([_gameModel checkMatchBetweenLeftPhrase:@"Number of pronouns" andRightPhrase:@"3"]);
  XCTAssertFalse([_gameModel checkMatchBetweenLeftPhrase:@"test1" andRightPhrase:@"test2"]);
  XCTAssertFalse([_gameModel checkMatchBetweenLeftPhrase:@"Number of tones" andRightPhrase:@">100"]);
}

@end