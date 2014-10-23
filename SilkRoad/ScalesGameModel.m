//
//  ScalesGameModel.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/20/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "ScalesGameModel.h"
#import "StageModel.h"

@implementation ScalesGameModel {
  NSMutableArray *_leftScaleCoins;
  NSMutableArray *_rightScaleCoins;
  NSMutableArray *_trayCoins;
  
  int _numWeighings;
};

- (id)init {
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
  // Reset the number of weighings to 0
  _numWeighings = 0;
  
  // The player will have between 8-12 coins to weigh
  // Choose the number of coins and create them
  int minNumOfCoins = 8;
  int maxNumOfCoins = 12;
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
-(NSMutableArray*)getCoinsInLeftScale {
  return _leftScaleCoins;
}

-(NSMutableArray*)getCoinsInRightScale {
  return _rightScaleCoins;
}

-(NSMutableArray*)getCoinsInTray {
  return _trayCoins;
}

// Methods to move coins between scales/tray
-(void)moveToLeftScale:(ScalesGameCoin*)coin {
  [_trayCoins removeObject:coin];
  [_leftScaleCoins addObject:coin];
}

-(void)removeFromLeftScale:(ScalesGameCoin*)coin {
  [_leftScaleCoins removeObject:coin];
  [_trayCoins addObject:coin];
}

-(void)moveToRightScale:(ScalesGameCoin*)coin {
  [_trayCoins removeObject:coin];
  [_rightScaleCoins addObject:coin];
}

-(void)removeFromRightScale:(ScalesGameCoin*)coin {
  [_rightScaleCoins removeObject:coin];
  [_trayCoins addObject:coin];
}

-(int)checkScales {
  int leftWeight = 0;
  int rightWeight = 0;
  
  int numLeftCoins = (int)[_leftScaleCoins count];
  int numRightCoins = (int)[_rightScaleCoins count];
  
  // Find the combined weights of the coins on each scale
  for (int i = 0; i < numLeftCoins; i++) {
    ScalesGameCoin* coin = [_leftScaleCoins objectAtIndex:i];
    leftWeight += [coin weight];
  }
  
  for (int i = 0; i < numLeftCoins; i++) {
    ScalesGameCoin* coin = [_leftScaleCoins objectAtIndex:i];
    rightWeight += [coin weight];
  }
  
  // If LEFT  is heavier, return 0
  // If they're balanced, return 1
  // If RIGHT is heavier, return 2
  if (leftWeight > rightWeight) {
    return 0;
  }
  else if (rightWeight > leftWeight){
    return 2;
  }
  else {
    return 1;
  }
}

-(BOOL)checkIfCoinFake:(ScalesGameCoin*)coin
{
  if ([coin weight] != 1) {
    return YES;
  }
  else {
    return NO;
  }
}

@end
