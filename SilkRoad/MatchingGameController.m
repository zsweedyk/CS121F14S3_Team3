//
//  MatchingGameController.m
//  SilkRoad
//
//  Created by CS121 on 10/11/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "MatchingGameController.h"
#import "MatchingGameModel.h"
#import "MatchingGameView.h"

@interface MatchingGameController ()
{
  int _currentLevel;
  BOOL _won;
  
  MatchingGameModel* _gameModel;
  MatchingGameView* _gameView;
}

@end

@implementation MatchingGameController

- (void)setLevelTo:(int)level
{
  NSLog(@"Set the matching level to %d", level);
  _currentLevel = level;
  
  // Now initialize the game for that level
  [_gameModel initializeGameForLevel:_currentLevel];
  
  // Create the minigame view
  _gameView = [[MatchingGameView alloc] initWithFrame:self.view.frame leftSidePhrases:[_gameModel getLeftSidePhrases] andRightSidePhrases:[_gameModel getRightSidePhrases]];
  
  // Set up the delegate to know when to leave
  _gameView.delegate = self;
  
  [self.view addSubview:_gameView];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
}

- (id)init
{
  self = [super init];
  
  if (self) {
    // Initialize gameModel
    _gameModel = [[MatchingGameModel alloc] init];
//    [_gameModel initializeGameForLevel:_currentLevel];
    _won = NO;
  }
  
  return self;
}

- (void)checkForMatchWithLeftPhrase:(NSString*)leftPhrase andRightPhrase:(NSString*)rightPhrase;
{
  BOOL match = [_gameModel checkMatchBetweenLeftPhrase:leftPhrase andRightPhrase:rightPhrase];
  
  // If they match, remove them from play;
  // Otherwise, clear the selection and keep going
  if (match) {
    NSLog(@"It's a match!");
    [_gameView matchFound:YES];
  }
  else {
    NSLog(@"Not a match...");
    [_gameView matchFound:NO];
  }
}

- (void)exitMinigame:(BOOL)won
{
  // Tell InteriorController that the interaction in the minigame is done
  _won = won;
  [self.delegate returnToInterior];
}

- (BOOL)hasBeenWon
{
  return _won;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
