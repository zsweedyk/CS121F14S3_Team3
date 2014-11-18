//
//  ViewController.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/11/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "ViewController.h"
#import "ProgressView.h"
#import "RoadGameController.h"
#import "ScalesGameController.h"
#import "Constants.h"

@interface ViewController () {
  int _currentStage;
  
  MainMenuView* _menuView;
  MapView* _mapView;
  StageController* _stageController;
  ScalesGameController* _scalesGameController;
  RoadGameController* _roadGameController;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // TODO: Currently hardcoding the current stage to 0
  _currentStage = 0;
  
  // Initialize the controllers
  _menuView = [[MainMenuView alloc] initWithFrame:self.view.frame];
  _menuView.delegate = self;
  _mapView = [[MapView alloc] initWithFrame:self.view.frame];
  _mapView.delegate = self;
  _scalesGameController = [[ScalesGameController alloc] init];
  _roadGameController = [[RoadGameController alloc] init];
  _stageController = [[StageController alloc] init];
  [_stageController setStageTo:_currentStage];
  
  
  // Show Main Menu
  [self.view addSubview:_menuView];
}

- (void)showStage
{
  [_menuView removeFromSuperview];
  [self displayStageController];
}

-(void)showMap
{
  NSLog(@"In showMap");
  [self dismissViewControllerAnimated:NO completion:nil];
  [self goToScalesGame];
  //[self.view addSubview:_mapView];
}

- (void) hideMap
{
  NSLog(@"Got to hide map VC");
  [_mapView removeFromSuperview];
  [self displayStageController];
}

- (void) jumpToStage:(int)stage
{
  NSLog(@"inButtonPressed MV fo stage %d", stage);
  _stageController = [[StageController alloc] init];
  [_stageController setStageTo:stage];
  [self hideMap];
}

- (void)returnToPrevious
{
  [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)goToScalesGame
{
  _scalesGameController.delegate = self;
  [_scalesGameController setCurrencyTo:CHINA];
  [self presentViewController:_scalesGameController animated:YES completion: nil];
}

- (void)goToRoadGame
{
  _roadGameController.delegate = self;
  [self presentViewController:_roadGameController animated:YES completion: nil];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)displayStageController
{
  // Configure StageController to report any changes to ViewController
  _stageController.delegate = self;
  // Create the navigation controller and present it.
  [self presentViewController:_stageController animated:YES completion: nil];
  //navigationController.navigationBar.hidden = YES;
}


// Initialize new stageController, set this to be the current stage
-(void)progressToNextStage
{
  [self dismissViewControllerAnimated:NO completion:nil];
  _stageController = [[StageController alloc] init];
  [_stageController setStageTo:++_currentStage];
  [_mapView moveToNextStage];
  
  [self displayStageController];
}

@end
