//
//  ScalesGameController.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/20/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "ScalesGameController.h"
#import "ScalesGameModel.h"
#import "Constants.h"

@interface ScalesGameController ()
{
  BOOL _hasBeenWon;
  ScalesGameView *_gameView;
  ScalesGameModel *_gameModel;
}

@end

@implementation ScalesGameController

- (id)init
{
  self = [super init];
  
  if (self) {
    _gameModel = [[ScalesGameModel alloc] init];

    _gameView = [[ScalesGameView alloc] initWithFrame:self.view.frame];
    _gameView.delegate = self;
    
    [self.view addSubview:_gameView];
  }
  
  return self;
}

- (void)setCurrencyTo:(int)civ
{
  [_gameView setCurrencyForCiv:civ];
  [self startNewGame];
}

- (void)startNewGame
{
  _hasBeenWon = NO;
  
  [_gameModel newGame];
  [_gameView newGameWithCoins:[_gameModel getCoinsInTray]];
}

- (void)moveCoin:(ScalesGameCoin*)coin toPlace:(int)placeToMove
{
  [_gameModel moveCoin:coin toPlace:placeToMove];
}

- (void)weighCoinsInScale {
  int weighResult = [_gameModel checkScales];
  
  // Make the view represent the result of the weighing
  if (weighResult == SCALES_LEFT) {
    [_gameView makeLeftScaleHeavier];
  }
  else if (weighResult == SCALES_RIGHT) {
    [_gameView makeRightScaleHeavier];
  }
  else {
    [_gameView makeScalesBalanced];
  }
  
  // Check to see if there are more weighings
  BOOL canWeigh = [_gameModel canStillWeigh];
  
  // If not, time to identify the fake coin!
  if (!canWeigh) {
    [_gameView identifyFakeCoin];
  }
}

- (void)checkIfCoinFake:(ScalesGameCoin*)coin {
  BOOL fakeCoin = [_gameModel checkIfCoinFake:coin];
  [_gameView foundFakeCoin:fakeCoin];
}

- (void)exitScalesGame:(BOOL)won {
  // Tell InteriorController that the interaction in the minigame is done
  _hasBeenWon = won;
  [self.delegate returnToPrevious];
}

- (BOOL)hasBeenWon {
  return _hasBeenWon;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
