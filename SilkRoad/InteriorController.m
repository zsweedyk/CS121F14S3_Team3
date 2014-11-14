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
  
  InteriorModel* _interiorModel;
  InteriorView* _interiorView;
  
  // Available minigames should have their controllers included here
  MatchingGameController* _matchingGameController;
  RoadGameController* _roadGameController;
  ScalesGameController* _scalesGameController;
}
@end

@implementation InteriorController

- (void)setStageTo:(int)stage andInteriorTo:(int)interior hasVisitedHouses:(BOOL)canEnterMinigame
{
  _currentStage = stage;
  _currentInterior = interior;
  if (_currentStage == 0 || _currentStage == 1) {
    [_interiorView setInteriorBGTo:@"mohenjodaro.jpg"];
    if (_currentInterior == 0 || _currentInterior == 4) {
      [_interiorView setCharacterTo:@"Village Elder" withImage:[UIImage imageNamed:@"IndianMan1"]];
    } else if (_currentInterior == 1) {
      [_interiorView setCharacterTo:@"Cobbler" withImage:[UIImage imageNamed:@"IndiaWoman1"]];
    } else if (_currentInterior == 2) {
      [_interiorView setCharacterTo:@"Butcher" withImage:[UIImage imageNamed:@"IndianWoman2"]];
    } else if (_currentInterior == 3) {
      [_interiorView setCharacterTo:@"Farmer" withImage:[UIImage imageNamed:@"IndianMan2"]];
    }
  } else if (_currentStage == 2 || _currentStage == 3) {
    [_interiorView setInteriorBGTo:@"chinabg"];
    if (_currentInterior == 0 || _currentInterior == 4) {
      [_interiorView setCharacterTo:@"Village Elder" withImage:[UIImage imageNamed:@"ChineseMan1"]];
    } else if (_currentInterior == 1) {
      [_interiorView setCharacterTo:@"Cobbler" withImage:[UIImage imageNamed:@"ChineseWoman1"]];
    } else if (_currentInterior == 2) {
      [_interiorView setCharacterTo:@"Butcher" withImage:[UIImage imageNamed:@"ChineseWoman2"]];
    } else if (_currentInterior == 3) {
      [_interiorView setCharacterTo:@"Farmer" withImage:[UIImage imageNamed:@"ChineseMan2"]];
    }
  }
  
  
  [_interiorModel initForStage:_currentStage andHouse:_currentInterior];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Initialize the minigame controllers
  _matchingGameController = [[MatchingGameController alloc] init];
  [_matchingGameController setLevelTo:_currentStage];
  
  _roadGameController = [[RoadGameController alloc] init];
  _scalesGameController = [[ScalesGameController alloc] init];

  
  // Initialize the InteriorView
  [self initInteriorView];
}

- (void)initInteriorView
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
  
  [_interiorModel initForStage:_currentStage andHouse:_currentInterior];
  
  [self progressDialogue];
  
  // Set up the delegate to know when to leave
  _interiorView.delegate = self;
  
  [self.view addSubview:_interiorView];
}

- (void)enterMinigame
{
  // Configure MinigameController to report any changes to InteriorController
  UIViewController* minigameViewController;
  switch (_currentStage) {
    case 0:
       _matchingGameController.delegate = self;
      minigameViewController = _matchingGameController;
      [_matchingGameController setLevelTo:_currentStage];
      break;
    case 1:
      _scalesGameController.delegate = self;
      minigameViewController = _scalesGameController;
      [_scalesGameController setCurrencyTo:CHINA];
      break;
    case 2:
      _roadGameController.delegate = self;
      minigameViewController = _roadGameController;
      break;
    case 3:
      _scalesGameController.delegate = self;
      minigameViewController = _scalesGameController;
      [_scalesGameController setCurrencyTo:INDIA];
      break;
    default:
      _matchingGameController.delegate = self;
      minigameViewController = _matchingGameController;
      [_matchingGameController setLevelTo:_currentStage];
      break;
  }

  [self presentViewController:minigameViewController animated:YES completion: nil];
}

- (void)returnToInterior
{
  BOOL winning;
  switch (_currentStage) {
    case 0:
      winning = [_matchingGameController hasBeenWon];
      break;
    case 1:
      winning = [_scalesGameController hasBeenWon];
      break;
    case 2:
      winning = [_roadGameController hasBeenWon];
      break;
    case 3:
      winning = [_scalesGameController hasBeenWon];
      break;
    default:
      winning = [_matchingGameController hasBeenWon];
      break;
  }
  
  // Dismiss the minigame controller and return to the interior view
  if (winning) {
    [_interiorModel setWinDialogueForStage:_currentStage];
    [self progressDialogue];
  }
  // When animated, causes timing issue and does not properly return
  // to stage if minigame has not been won
  [self dismissViewControllerAnimated:NO completion:nil];
  
  if (!winning) {
    [self.delegate returnToStage];
  }
}

- (void)leaveInterior
{
  // Tell StageController that the interaction in the interior is done
  [self.delegate returnToStage];
}

-(void)progressDialogue
{
  // Check to see if there are still available dialogue lines to display
  if ([_interiorModel dialogueFinished]) {
    [_interiorView setDialogueTextTo:[_interiorModel getNextLineOfDialogue]];
  } else {
    // The first house always contains the minigame
    if (_currentInterior == 0) {
      // If the game has been won and there is no more dialogue, go to
      // the next stage
      if ([_matchingGameController hasBeenWon] || [_scalesGameController hasBeenWon] || [_roadGameController hasBeenWon]) {
        [self.delegate notifyStageComplete];
      } else {
        // If the game has yet to be won, enter the game
        [self enterMinigame];
      }
    } else {
      // For any other house, simply leave when there is no more dialogue
      [self leaveInterior];
    }
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
