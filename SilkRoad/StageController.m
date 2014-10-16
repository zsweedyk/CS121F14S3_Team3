//
//  StageController.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "StageController.h"
#import "StageView.h"
#import "StageModel.h"

@interface StageController () {
  StageView* _stageView;
  StageModel* _stageModel;
  InteriorController* _interiorController;
}

@end

@implementation StageController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  NSLog(@"Initialized StageController, initializing interiorController");
  // Initialize the InteriorController
  _interiorController = [[InteriorController alloc] init];
  // Configure InteriorController to report any changes to ViewController
  _interiorController.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:YES];
  [super viewDidAppear:NO];
  
  NSLog(@"Displaying InteriorController");
  // Display the InteriorController
  [self displayInteriorController];
  
}

- (void)displayInteriorController
{
  // Create the navigation controller and present it.
  UINavigationController *interiorNavController = [[UINavigationController alloc]
                                                  initWithRootViewController:_interiorController];
  [self presentViewController:interiorNavController animated:YES completion: nil];
}

- (void)returnToStage
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)notifyStageComplete
{
  // Let ViewController know the stage has been finished
  [self.delegate progressToNextStage];
}

- (void)miniGameCompleted
{
}
// When house is clicked, display interior view
-(void)enterHouse:(int)houseNumber
{
}


@end
