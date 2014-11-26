//
//  MastermindGameModel.m
//  SilkRoad
//
//  Created by Katharine Finlay on 11/22/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MasterMindGameModel.h"

@interface MasterMindGameModel()
{
  int* _currentSolution;
  BOOL _hasBeenWon;
  NSMutableArray* _turns;
  int _numTurns;
}
@end

@implementation MasterMindGameModel

- (id)init {
  self = [super init];
  
  if (self) {
    // Put all the phrases in the file into an array for easy access by level
    _currentSolution = malloc(4*sizeof(int));
    _hasBeenWon = NO;
    _numTurns = 0;
    _turns = [[NSMutableArray alloc] init];
    [self makeNewSolution];
  }
  
  return self;
}

-(void)makeNewSolution
{
  for (int i = 0; i < 4; i++) {
    _currentSolution[i] = (arc4random() % 4);
  }
}


-(int)getMatchesFromAttempt:(int*)attempt
{
  const int NULL_CHAR = 100;
  _numTurns++;
  int passwordCopy[4];
  //memcpy(passwordCopy, _currentSolution, 4*sizeof(int));
  int exactMatches = 0;
  for (int i = 0; i < 4; ++i) {
    //put this attempt in the turns array
    NSNumber* numToInput = [NSNumber numberWithInt:attempt[i]];
    [_turns addObject:numToInput];

    NSAssert(attempt[i] <= 3, @"attempt out of bounds");
    //count and mark exact matches as seen with NULL_CHAR
    if (attempt[i] == _currentSolution[i]) {
      attempt[i] = NULL_CHAR;
      passwordCopy[i] = NULL_CHAR;
      exactMatches++;
    } else {
      passwordCopy[i] = _currentSolution[i];
    }
  }
  
  //iterate through the answer again, counting the half matches
  int halfMatches = 0;
  for (int i = 0; i < 4; ++i) {
    for (int j = 0; j < 4; ++j) {
      if (attempt[i] == passwordCopy[j] && passwordCopy[i] != NULL_CHAR) {
        halfMatches++;
        break;
      }
    }
  }
  
  NSAssert(halfMatches + exactMatches <= 4, @"Too many matches");
  
  if (exactMatches == 4) {
    _hasBeenWon = YES;
  }
  
  //exact matches in the 10s place and half matches in the 1s, such that
  // 1 exact match and 3 half matches would be represented as 13, etc.
  return exactMatches*10 + halfMatches;
}

-(void)resetGame
{
  [self makeNewSolution];
  _numTurns = 0;
  [_turns removeAllObjects];
}

-(BOOL)hasBeenWon
{
  return _hasBeenWon;
}

-(void)setPassword:(int*)mockPassword
{
  for (int i = 0; i < 4; i++) {
    _currentSolution[i] = mockPassword[i];
  }
  //_currentSolution = mockPassword;
}

@end