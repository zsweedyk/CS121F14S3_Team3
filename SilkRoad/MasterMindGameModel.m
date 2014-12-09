//
//  MastermindGameModel.m
//  SilkRoad
//
//  Created by Katharine Finlay on 11/22/13.
//  Copyright (c) 2013 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MasterMindGameModel.h"

@interface MasterMindGameModel()
{
  int* _currentSolution;
  BOOL _hasBeenWon;
  int _numTurns;
}
@end

@implementation MasterMindGameModel

- (id)init {
  self = [super init];
  
  if (self) {
    // Put all the phrases in the file into an array for easy access by level
    _currentSolution = malloc(3*sizeof(int));
    _hasBeenWon = NO;
    _numTurns = 0;
    [self makeNewSolution];
  }
  
  return self;
}

-(void)makeNewSolution
{
  for (int i = 0; i < 3; i++) {
    _currentSolution[i] = (arc4random() % 3);
  }
}


-(int)getMatchesFromAttempt:(int*)attempt
{
  const int NULL_CHAR = 100;
  _numTurns++;
  int passwordCopy[3];
  int exactMatches = 0;
  for (int i = 0; i < 3; ++i) {
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
  for (int i = 0; i < 3; ++i) {
    for (int j = 0; j < 3; ++j) {
      if (attempt[i] == passwordCopy[j] && passwordCopy[j] != NULL_CHAR) {
        halfMatches++;
        passwordCopy[j] = NULL_CHAR;
        break;
      }
    }
  }
  
  NSAssert(halfMatches + exactMatches <= 3, @"Too many matches");
  
  if (exactMatches == 3) {
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
}

-(BOOL)hasBeenWon
{
  return _hasBeenWon;
}

-(void)setPassword:(int*)mockPassword
{
  for (int i = 0; i < 3; i++) {
    _currentSolution[i] = mockPassword[i];
  }
}

@end