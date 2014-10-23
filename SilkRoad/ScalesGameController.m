//
//  ScalesGameController.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/20/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "ScalesGameController.h"
#import "ScalesGameModel.h"

@interface ScalesGameController ()
{
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
  }
  
  return self;
}

- (void)checkIfCoinFake:(ScalesGameCoin*)coin {
  BOOL fakeCoin = [_gameModel checkIfCoinFake:coin];
  [_gameView foundFakeCoin:fakeCoin];
}

- (void)exitMinigame {
  // Tell InteriorController that the interaction in the minigame is done
  [self.delegate returnToInterior];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
