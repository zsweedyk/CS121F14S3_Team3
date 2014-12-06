//
//  InteriorController.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "InteriorController.h"
#import "InteriorModel.h"
#import "RoadGameController.h"
#import "Constants.h"

@interface InteriorController () {
  int _currentStage;
  int _currentInterior;
  int _numMinigamesWon;
  BOOL _funExists;
  
  InteriorModel* _interiorModel;
  InteriorView* _interiorView;
  
  BOOL _canEnterMinigame;
  
  // Available minigames should have their controllers included here
  MatchingGameController* _matchingGameController;
  RoadGameController* _roadGameController;
  ScalesGameController* _scalesGameController;
  MasterMindGameController* _masterMindGameController;
}
@end

@implementation InteriorController

-(void)setStageTo:(int)stage andInteriorTo:(int)interior hasVisitedHouses:(BOOL)canEnterMinigame
{
  _currentStage = stage;
  _currentInterior = interior;
  
  if (_currentStage <= LAST_INDIA_STAGE) {
    [_interiorView setInteriorBGTo:@"mohenjodaro.jpg"];
    if (_currentInterior == 0 || _currentInterior == 4) {
      [_interiorView setCharacterTo:@"Village Elder" withImage:[UIImage imageNamed:@"IndianMan1"]];
    }
    else if (_currentInterior == 1) {
      [_interiorView setCharacterTo:@"Cobbler" withImage:[UIImage imageNamed:@"IndiaWoman1"]];
    }
    else if (_currentInterior == 2) {
      [_interiorView setCharacterTo:@"Butcher" withImage:[UIImage imageNamed:@"IndianWoman2"]];
    }
    else if (_currentInterior == 3) {
      [_interiorView setCharacterTo:@"Farmer" withImage:[UIImage imageNamed:@"IndianMan2"]];
    }
  } else {
    [_interiorView setInteriorBGTo:@"chinabg"];
    if (_currentInterior == 0 || _currentInterior == 4) {
      [_interiorView setCharacterTo:@"Village Elder" withImage:[UIImage imageNamed:@"ChineseMan1"]];
    }
    else if (_currentInterior == 1) {
      [_interiorView setCharacterTo:@"Cobbler" withImage:[UIImage imageNamed:@"ChineseWoman1"]];
    }
    else if (_currentInterior == 2) {
      [_interiorView setCharacterTo:@"Butcher" withImage:[UIImage imageNamed:@"ChineseWoman2"]];
    }
    else if (_currentInterior == 3) {
      [_interiorView setCharacterTo:@"Farmer" withImage:[UIImage imageNamed:@"ChineseMan2"]];
    }
  }
  
  _numMinigamesWon = 0;
  
  _funExists = NO;
  // The constants file has an array stating which stages have fun
  if (STAGES_WITH_FUN[_currentStage] == 1) {
    _funExists = YES;
  }
  
  [_interiorModel initForStage:_currentStage andHouse:_currentInterior];
  _canEnterMinigame = canEnterMinigame;
}

-(void)viewDidLoad
{
  [super viewDidLoad];
  
  // Initialize the minigame controllers
  _matchingGameController = [[MatchingGameController alloc] init];
  [_matchingGameController setLevelTo:_currentStage];
  
  _roadGameController = [[RoadGameController alloc] init];
  _scalesGameController = [[ScalesGameController alloc] init];
  _masterMindGameController = [[MasterMindGameController alloc] init];
  
  // Initialize the InteriorView
  [self initInteriorView];
}

-(void)initInteriorView
{
  // Get stage frame dimensions
  CGRect frame = self.view.frame;
  CGFloat frameWidth = CGRectGetWidth(frame);
  CGFloat frameHeight = CGRectGetHeight(frame);
  
  // The interior view will take up the same space
  CGRect interiorFrame = CGRectMake(0, 0, frameWidth, frameHeight);
  
  // Create interior view
  _interiorView = [[InteriorView alloc] initWithFrame:interiorFrame];
  
  // Set up model to read in all dialogue
  _interiorModel = [[InteriorModel alloc] init];
  
  // Set up the delegate to know when to leave
  _interiorView.delegate = self;
  
  [self.view addSubview:_interiorView];
}

-(void)enterMinigame
{
  // Configure MinigameController to report any changes to InteriorController
  UIViewController* minigameViewController;
  if (_numMinigamesWon == 1 && _funExists) {
    switch (_currentStage) {
      case 0:
        _masterMindGameController.delegate = self;
        minigameViewController = _masterMindGameController;
        break;
      case 1:
        _scalesGameController.delegate = self;
        minigameViewController = _scalesGameController;
        [_scalesGameController setCurrencyTo:CHINA];
        break;
      case 3:
        _roadGameController.delegate = self;
        minigameViewController = _roadGameController;
        break;
      case 4:
        _masterMindGameController.delegate = self;
        minigameViewController = _masterMindGameController;
        break;
      case 5:
        _scalesGameController.delegate = self;
        minigameViewController = _scalesGameController;
        [_scalesGameController setCurrencyTo:INDIA];
        break;
      case 7:
        _roadGameController.delegate = self;
        minigameViewController = _roadGameController;
        break;
    }
  }
  else {
    _matchingGameController.delegate = self;
    minigameViewController = _matchingGameController;
    [_matchingGameController setLevelTo:_currentStage];
  }
  
  [self presentViewController:minigameViewController animated:YES completion: nil];
}

-(void)returnToPrevious
{
  BOOL winning = NO;
  
  if (_numMinigamesWon == 1 && _funExists) {
    switch (_currentStage) {
      case 0:
        winning = [_masterMindGameController hasBeenWon];
        break;
      case 1:
        winning = [_scalesGameController hasBeenWon];
        break;
      case 3:
        winning = [_roadGameController hasBeenWon];
        break;
      case 4:
        winning = [_masterMindGameController hasBeenWon];
        break;
      case 5:
        winning = [_scalesGameController hasBeenWon];
        break;
      case 7:
        winning = [_roadGameController hasBeenWon];
        break;
    }
  }
  else {
    winning = [_matchingGameController hasBeenWon];
  }
  
  // Display win dialogue
  if (winning) {
    [_interiorModel setWinDialogueForStage:_currentInterior numGamesWon:_numMinigamesWon funExists:_funExists];
    _numMinigamesWon += 1;
    [self progressDialogue];
  }
  // When animated, causes timing issue and does not properly return
  // to stage if minigame has not been won
  [self dismissViewControllerAnimated:NO completion:nil];
  
  // Dismiss the minigame controller and return to the interior view
  if (!winning) {
    [self.delegate returnToStage];
  }
}

-(void)leaveInterior
{
  // Tell StageController that the interaction in the interior is done
  [self.delegate returnToStage];
}

-(void)progressDialogue
{
  // Check to see if there are still available dialogue lines to display
  if ([_interiorModel dialogueFinished]) {
    [_interiorView setDialogueTextTo:[_interiorModel getNextLineOfDialogue]];
  }
  else {
    // The first house always contains the minigame
    if (_currentInterior == 0 && _canEnterMinigame) {
      // If the matching game has been won, check to see if there is another fun minigame after it
      if ([_matchingGameController hasBeenWon]) {
        
        // If there is a fun minigame that hasn't been won, enter it, otherwise the stage is finished
        if (_funExists) {
          if ([_scalesGameController hasBeenWon] || [_roadGameController hasBeenWon] || [_masterMindGameController hasBeenWon]) {
            [self.delegate notifyStageComplete];
          }
          else {
            [self enterMinigame];
          }
        }
        
        // If there is no other fun minigame, return to the stage
        else {
          [self.delegate notifyStageComplete];
        }
        
      }
      else {
        [self enterMinigame];
      }
      // The matching game hasn't been won, go to it
    }
    else {
      // For any other house, simply leave when there is no more dialogue
      [self leaveInterior];
    }
  }
}

-(void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end
