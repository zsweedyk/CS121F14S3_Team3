//
//  InteriorController.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "InteriorController.h"
#import "InteriorModel.h"
#import "InteriorView.h"

@interface InteriorController () {
    InteriorModel* _interiorModel;
    InteriorView* _interiorView;
}
@end

@implementation InteriorController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  NSLog(@"Initialized InteriorController");
  // Initialize the InteriorView
  [self initInteriorView];
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
  [self.view addSubview:_interiorView];
}

- (void)leaveInterior
{
  // Tell StageController that the interaction in the interior is done
  [self.delegate returnToStage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
