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
  
  MapView* _mapView;
  ProgressView* _progressView;
  StageController* _stageController;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // TODO: Currently hardcoding the current stage to 1
  _currentStage = 1;
  
  // Initialize the StageController
  _stageController = [[StageController alloc] init];
  [_stageController setStageTo:_currentStage];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:YES];
  [super viewDidAppear:NO];
    
  // TODO: Display the StageView
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
  
  // Create the navigation controller and present it.
  UINavigationController *navigationController = [[UINavigationController alloc]
                                                  initWithRootViewController:_stageController];
  [self presentViewController:navigationController animated:YES completion: nil];
}



// Initialize new stageController, set this to be the current stage
-(void)progressToNextStage {
}

@end
