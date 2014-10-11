//
//  MatchingGameModel.m
//  SilkRoad
//
//  Created by CS121 on 10/11/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "MatchingGameModel.h"

@interface MatchingGameModel()
{
  NSMutableArray* _leftSidePhrases;
  NSMutableArray* _rightSidePhrases;
  NSMutableDictionary* _matches;
}

@end

@implementation MatchingGameModel

-(void)initializePhrasesAndMatches
{
  // Initialize both sets of phrases
  _leftSidePhrases = [NSMutableArray arrayWithObjects:@"An idiom", "@Another idiom", nil];
  _rightSidePhrases = [NSMutableArray arrayWithObjects:@"This matches something", @"So does this", nil];
  
  int matchCount = [_rightSidePhrases count];
  
  // Initialize dictionary to associate phrases
  _matches = [[NSMutableDictionary alloc] initWithCapacity:matchCount];
  
  // Associate phrases that are at the same index in their lists
  NSString* phrase1;
  NSString* phrase2;
  for (int i = 0; i < matchCount; i++) {
    phrase1 = [_leftSidePhrases objectAtIndex:i];
    phrase2 = [_rightSidePhrases objectAtIndex:i];
    [_matches setObject:phrase1 forKey:phrase2];
    [_matches setObject:phrase2 forKey:phrase1];
  }
  
  // Shuffle phrase arrays so they do not appear in order when displayed
  [self shuffleArray:_leftSidePhrases];
  [self shuffleArray:_rightSidePhrases];
}

-(void)shuffleArray:(NSMutableArray*)array
{
  NSUInteger count = [array count];
  for (NSUInteger i = 0; i < count; ++i) {
    NSInteger remainingCount = count - i;
    NSInteger exchangeIndex = i + arc4random_uniform(remainingCount);
    [array exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
  }
}

-(NSMutableArray*)getLeftSidePhrases
{
  return _leftSidePhrases;
}

-(NSMutableArray*)getRightSidePhrases
{
  return _rightSidePhrases;
}

@end
