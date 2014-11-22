//
//  ScalesGameModel.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/20/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "ScalesGameModel.h"
#import "StageModel.h"
#import "Constants.h"

@interface ScalesGameModel()
{
  NSMutableArray *_leftScaleCoins;
  NSMutableArray *_rightScaleCoins;
  NSMutableArray *_trayCoins;
  ScalesGameCoin *_fakeCoinGuess;
  
  int _numGuesses;
}
@end

@implementation ScalesGameModel

- (id)init
{
  self = [super init];
  
  if (self) {
    // Initialize the arrays
    _leftScaleCoins = [[NSMutableArray alloc] init];
    _rightScaleCoins = [[NSMutableArray alloc] init];
    _trayCoins = [[NSMutableArray alloc] init];
  }
  
  return self;
}

-(void)newGame
{
  // Reset the number of guesses
  _numGuesses = 2;
  
  // Reset the trays
  [_leftScaleCoins removeAllObjects];
  [_rightScaleCoins removeAllObjects];
  [_trayCoins removeAllObjects];
  
  // Choose the number of coins and create them
  int minNumOfCoins = SCALES_MINNUMCOINS;
  int maxNumOfCoins = SCALES_MAXNUMCOINS;
  int numCoins = minNumOfCoins + arc4random() % (maxNumOfCoins - minNumOfCoins);
  
  for (int i = 0; i < numCoins; i++) {
    ScalesGameCoin *newCoin = [[ScalesGameCoin alloc] init];
    // All coins start in the tray
    [_trayCoins addObject:newCoin];
  }
  
  // Choose a random coin to be the fake one
  // Also choose whether the coin is heavier (1) or lighter (0) than the others
  int fakeCoinNumber = arc4random_uniform(numCoins);
  int fakeWeight = arc4random_uniform(2);
  
  ScalesGameCoin *fakeCoin = [_trayCoins objectAtIndex:fakeCoinNumber];
  
  if (fakeWeight == 1) {
    [fakeCoin setWeight:2];
  }
  else {
    [fakeCoin setWeight:0];
  }
}

// Methods to see which coins are in scales/tray
-(NSMutableArray*)getCoinsInLeftScale
{
  return _leftScaleCoins;
}

-(NSMutableArray*)getCoinsInRightScale
{
  return _rightScaleCoins;
}

-(NSMutableArray*)getCoinsInTray
{
  return _trayCoins;
}

-(void)moveCoin:(ScalesGameCoin*)coin toPlace:(int)to
{
  BOOL foundCoin = NO;
  int from = 0;
  
  // Find where the coin is coming from by checking the fake coin bucket and
  // each tray
  if (_fakeCoinGuess == coin) {
    from = SCALES_FAKECOINBUCKET;
    foundCoin = YES;
  }
  
  if (!foundCoin) {
    for (ScalesGameCoin* checkCoin in _trayCoins) {
      if (checkCoin == coin) {
        from = SCALES_TRAY;
        foundCoin = YES;
        break;
      }
    }
  }
  
  if (!foundCoin) {
    for (ScalesGameCoin* checkCoin in _leftScaleCoins) {
      if (checkCoin == coin) {
        from = SCALES_LEFT;
        foundCoin = YES;
        break;
      }
    }
  }
  
  if (!foundCoin) {
    for (ScalesGameCoin* checkCoin in _rightScaleCoins) {
      if (checkCoin == coin) {
        from = SCALES_RIGHT;
        break;
      }
    }
  }
  
  // Now move the coin according to the to and the from
  if (from == SCALES_FAKECOINBUCKET) {
    _fakeCoinGuess = NULL;
  }
  else if (from == SCALES_LEFT) {
    [_leftScaleCoins removeObject:coin];
  }
  else if (from == SCALES_RIGHT) {
    [_rightScaleCoins removeObject:coin];
  }
  else if (from == SCALES_TRAY) {
    [_trayCoins removeObject:coin];
  }
  
  if (to == SCALES_FAKECOINBUCKET) {
    _fakeCoinGuess = coin;
  }
  else if (to == SCALES_LEFT) {
    [_leftScaleCoins addObject:coin];
  }
  else if (to == SCALES_RIGHT) {
    [_rightScaleCoins addObject:coin];
  }
  else if (to == SCALES_TRAY) {
    [_trayCoins addObject:coin];
  }
}

-(int)checkScales
{
  int leftWeight = 0;
  int rightWeight = 0;
  
  int numLeftCoins = (int)[_leftScaleCoins count];
  int numRightCoins = (int)[_rightScaleCoins count];
  
  // Find the combined weights of the coins on each scale
  for (int i = 0; i < numLeftCoins; i++) {
    ScalesGameCoin* coin = [_leftScaleCoins objectAtIndex:i];
    leftWeight += [coin weight];
  }
  
  for (int i = 0; i < numRightCoins; i++) {
    ScalesGameCoin* coin = [_rightScaleCoins objectAtIndex:i];
    rightWeight += [coin weight];
  }
  
  // If LEFT  is heavier, return 0
  // If they're balanced, return 1
  // If RIGHT is heavier, return 2
  if (leftWeight > rightWeight) {
    return SCALES_LEFT;
  }
  else if (rightWeight > leftWeight){
    return SCALES_RIGHT;
  }
  else {
    return SCALES_BALANCED;
  }
}

-(BOOL)checkIfCoinFake:(ScalesGameCoin*)coin
{
  // That's minus one guess
  --_numGuesses;
  
  if ([coin weight] != 1) {
    return YES;
  }
  else {
    return NO;
  }
}

-(BOOL)canStillGuess
{
  return _numGuesses > 0;
}

@end
