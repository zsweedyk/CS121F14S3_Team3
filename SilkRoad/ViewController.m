//
//  ViewController.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/11/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "ViewController.h"
#import "MapView.h"
#import "ProgressView.h"

@interface ViewController () {
  int _currentStage;
  
  MainMenuView* _menuView;
  MapView* _mapView;
  ProgressView* _progressView;
  StageController* _stageController;
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
  _stageController = [[StageController alloc] init];
  [_stageController setStageTo:_currentStage];
  
  // Show Main Menu
  [self.view addSubview:_menuView];
}

- (void)showStage {
  [_menuView removeFromSuperview];
  [self displayStageController];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)displayStageController {
  // Configure StageController to report any changes to ViewController
  _stageController.delegate = self;
  [self presentViewController:_stageController animated:YES completion: nil];
}


// Initialize new stageController, set this to be the current stage
-(void)progressToNextStage {
  [self dismissViewControllerAnimated:NO completion:nil];
  _stageController = [[StageController alloc] init];
  [_stageController setStageTo:++_currentStage];
  
  [self displayStageController];
}

@end
