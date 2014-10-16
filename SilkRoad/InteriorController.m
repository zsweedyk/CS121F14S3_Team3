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

@interface InteriorController () {
  InteriorModel* _interiorModel;
  InteriorView* _interiorView;
  
  // Available minigames should have their controllers included here
  MatchingGameController* _matchingGameController;
}
@end

@implementation InteriorController

- (void)viewDidLoad
{
  NSLog(@"Starting to load InteriorController");
  [super viewDidLoad];

  // Initialize the Minigame Controllers
  _matchingGameController = [[MatchingGameController alloc] init];
  
  NSLog(@"Finished loading Minigame Controller");
  // Initialize the InteriorView
  [self initInteriorView];
  NSLog(@"Finished loading interior view");
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:YES];
  [super viewDidAppear:NO];
  
  // TODO: Test minigame by displaying the MinigameController
  // [self enterMinigame];
  
}

- (void)initInteriorView
{
  NSLog(@"Initializing InteriorView");
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
  
  // TODO make this not hard coded
  [_interiorModel initForStage:0 AndHouse:0];
  
  [self progressDialogue];
  
  // Set up the delegate to know when to leave
  _interiorView.delegate = self;
  
  [self.view addSubview:_interiorView];
}

- (void)enterMinigame
{
  // Configure MinigameController to report any changes to InteriorController
  _matchingGameController.delegate = self;
  
  // Create the navigation controller and present it.
  UINavigationController *matchingNavController = [[UINavigationController alloc]
                                                  initWithRootViewController:_matchingGameController];
  [self presentViewController:matchingNavController animated:YES completion: nil];
}

- (void)returnToInterior
{
  // Dismiss the minigame controller and return to the interior view
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
    // TODO not all houses should enter minigames, more logic here, probably
    [self enterMinigame];
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
