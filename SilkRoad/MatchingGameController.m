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
  MatchingGameModel* _gameModel;
  MatchingGameView* _gameView;
}

@end

@implementation MatchingGameController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  
  if (self) {
    // Initialize gameModel
    _gameModel = [[MatchingGameModel alloc] init];
    [_gameModel initializeGame];
    NSLog(@"Done initializing game model");

    
    // Create the minigame view
    _gameView = [[MatchingGameView alloc] initWithFrame:self.view.frame leftSidePhrases:[_gameModel getLeftSidePhrases] andRightSidePhrases:[_gameModel getRightSidePhrases]];
    
    // Set up the delegate to know when to leave
    _gameView.delegate = self;
    
    [self.view addSubview:_gameView];
    NSLog(@"Done initializing game view");
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

- (void)exitMinigame
{
  // Tell InteriorController that the interaction in the minigame is done
  [self.delegate returnToInterior];
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
