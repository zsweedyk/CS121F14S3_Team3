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
  
  // If the coin is in the fake coin bucket, check it
  if (placeToMove == SCALES_FAKECOINBUCKET) {
    [self checkIfCoinFake:coin];
  }
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
}

- (void)checkIfCoinFake:(ScalesGameCoin*)coin {
  BOOL fakeCoin = [_gameModel checkIfCoinFake:coin];
  BOOL canStillGuess = [_gameModel canStillGuess];
  [_gameView foundFakeCoin:fakeCoin andCanGuess:canStillGuess];
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
