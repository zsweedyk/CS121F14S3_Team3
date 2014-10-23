//
//  InteriorController.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "InteriorController.h"
#import "InteriorModel.h"
#import "MatchingGameController.h"
#import "RoadGameController.h"

@interface InteriorController () {
  int _currentStage;
  int _currentInterior;
  
  InteriorModel* _interiorModel;
  InteriorView* _interiorView;
  
  // Available minigames should have their controllers included here
  MatchingGameController* _matchingGameController;
  //RoadGameController* _roadGameController;
}
@end

@implementation InteriorController

- (void)setStageTo:(int)stage andInteriorTo:(int)interior
{
  _currentStage = stage;
  _currentInterior = interior;
  
  [_interiorModel initForStage:_currentStage andHouse:_currentInterior];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Initialize the minigame controllers
  _matchingGameController = [[MatchingGameController alloc] init];
  [_matchingGameController setLevelTo:_currentStage];
  //_roadGameController = [[RoadGameController alloc] init];
  
  
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
  [_interiorModel initializeAllDialogue];
  
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
      break;
    case 1:
      //_roadGameController.delegate = self;
      //minigameViewController = _roadGameController;
      break;
    default:
      break;
  }

  // Create the navigation controller and present it.
  UINavigationController* matchingNavController = [[UINavigationController alloc] initWithRootViewController:minigameViewController];
  [self presentViewController:matchingNavController animated:YES completion: nil];
  matchingNavController.navigationBar.hidden = YES;

}

- (void)returnToInterior
{
  // Dismiss the minigame controller and return to the interior view
  if ([_matchingGameController hasBeenWon]) {
    [_interiorModel setWinDialogueForStage:_currentInterior];
    [self progressDialogue];
  }
  [self dismissViewControllerAnimated:YES completion:nil];

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
      if ([_matchingGameController hasBeenWon]) {
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
