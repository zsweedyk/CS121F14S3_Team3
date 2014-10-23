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
  NSArray* _phrases;
  NSMutableArray* _leftSidePhrases;
  NSMutableArray* _rightSidePhrases;
  NSMutableDictionary* _matches;
}

@end

@implementation MatchingGameModel

- (id)init {
  self = [super init];
  
  if (self) {
    // Put all the phrases in the file into an array for easy access by level
    NSString *path;
    NSError *error;
    
    path = [[NSBundle mainBundle] pathForResource:@"MatchingGamePhrases" ofType:@"txt"];
    
    NSString *phrasesString = [[NSString alloc] initWithContentsOfFile:path
                                encoding:NSUTF8StringEncoding error:&error];
    _phrases = [phrasesString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
  }
  
  return self;
}

-(void)initializeGameForLevel:(int)level
{
  // Generate the phrases for this level
  [self generatePhrasesForLevel:level];
  
  // Shuffle phrase arrays so they do not appear in order when displayed
  [self shuffleArray:_leftSidePhrases];
  [self shuffleArray:_rightSidePhrases];
}

-(void)generatePhrasesForLevel:(int)level
{
  NSString *phraseString = [_phrases objectAtIndex:level];
  
  // Initialize all arrays
  _leftSidePhrases = [[NSMutableArray alloc] init];
  _rightSidePhrases = [[NSMutableArray alloc] init];
  _matches = [[NSMutableDictionary alloc] init];
  
  // Initialize string indices for the phrases
  int startLeft = 0;
  int lenLeft = 0;
  int startRight = 0;
  int lenRight = 0;
  
  // Parse the string and put the phrases into the correct array
  // Associate same phrases in the matches string
  while ([phraseString length] > 0) {
    // If we see an open parens, we can start parsing for left and right phrases
    if ([phraseString characterAtIndex:0] == '(') {
      // Start at 2 to account for the quotation mark
      startLeft = 2;
      
      lenLeft = 0;
      // Loop through looking for a quotation mark, which marks the end of the left phrase
      while ([phraseString characterAtIndex:startLeft + lenLeft] != '"') {
        lenLeft++;
      }

      startRight = startLeft + lenLeft + 1;
      // Loop through looking for a quotation mark, which marks the start of the right phrase
      while ([phraseString characterAtIndex:startRight] != '"') {
        startRight++;
      }
      // Increment one more to get past the quotation mark
      startRight++;
      
      lenRight = 0;
      // Loop through looking for a quotation mark, which marks the end of the right phrase
      while ([phraseString characterAtIndex:startRight + lenRight] != '"') {
        lenRight++;
      }
      
      // Get these phrases and add them to the appropriate arrays
      // Also associate them in the matches array
      NSString *leftPhrase = [phraseString substringWithRange:NSMakeRange(startLeft, lenLeft)];
      NSString *rightPhrase = [phraseString substringWithRange:NSMakeRange(startRight, lenRight)];
      
      [_leftSidePhrases addObject:leftPhrase];
      [_rightSidePhrases addObject:rightPhrase];
      [_matches setObject:rightPhrase forKey:leftPhrase];
      
      // Cut this set of phrases off the string
      phraseString = [phraseString substringFromIndex:startRight+lenRight];
    }
    else {
      // If it's not an open parens, then we just parsed the phrases and there's extra
      //    chars at the end -- just cut them off until we find another open parens
      phraseString = [phraseString substringFromIndex:1];
    }
  }
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

-(BOOL)checkMatchBetweenLeftPhrase:(NSString*)leftPhrase andRightPhrase:(NSString*)rightPhrase
{
  NSString *correctRightPhrase = [_matches objectForKey:leftPhrase];
  NSLog(@"The correct match for %@ is %@, the user put %@", leftPhrase, correctRightPhrase, rightPhrase);
  return [rightPhrase isEqualToString:correctRightPhrase];
}

@end
