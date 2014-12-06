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
#import "Constants.h"

int const NUM_HOUSES = 4;
int const LAST_STAGE = 3;

@interface StageController ()
{
  int _currentStage;
  BOOL _isIndia;
  BOOL _isChina;
  BOOL _hasBeenLoaded;

  StageView* _stageView;
  StageModel* _stageModel;
  ProgressView* _progressView;
  InteriorController* _interiorController;
  NSMutableArray* _houses;
}

@end

@implementation StageController

+(UIImage *)imageWithColor:(UIColor*)color
{
  CGRect rect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);
  
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return image;
}

-(void)setStageTo:(int)stage
{
  _currentStage = stage;
  // The switch between civilizations is at the midpoint of the stages
  _isIndia = stage < NUM_CITIES / 2;
  _isChina = !_isIndia;
}

-(void)viewDidLoad
{
  [super viewDidLoad];

  // Get stage frame dimensions
  CGRect frame = self.view.frame;
  CGFloat frameWidth = CGRectGetWidth(frame);
  CGFloat frameHeight = CGRectGetHeight(frame);

  // Make the progress view
  // Get the frame of the progress view (15% height, full width)
  CGRect progressFrame = CGRectMake(0, 0, frameWidth, frameHeight * 0.15);
  _progressView = [[ProgressView alloc] initWithFrame:progressFrame andCurrentStage:_currentStage];
  _progressView.delegate = self;

  // Create the stage model
  _stageModel = [[StageModel alloc] initForStage:_currentStage];
  
  // The stage view will take up the same space
  CGRect stageFrame = CGRectMake(0, 0, frameWidth, frameHeight);
  
  // Background images index from 1, are in the format india1 or china1
  UIImage* stageBackground;
  if (_isIndia) {
    stageBackground = [UIImage imageNamed:[NSString stringWithFormat:@"india%i", _currentStage + 1]];
  } else {
    // The current stage is 2 when you first reach China. Subtract off the midpoint to get china1, china2, etc.
    stageBackground = [UIImage imageNamed:[NSString stringWithFormat:@"china%i", (_currentStage - NUM_CITIES / 2) + 1]];
  }
  
  // Create the stage view
  _stageView = [[StageView alloc] initWithFrame:stageFrame background:stageBackground];
  
  [_stageView loadNewStageWithHouses:[_stageModel getHouses]];
  
  _stageView.delegate = self;
  [self.view addSubview:_stageView];
  [self.view addSubview:_progressView];

  //Initiate has been loaded
  _hasBeenLoaded = NO;
}

// Display the village elder with information about the stage when it is first visited
// Set _hasBeenLoaded so this doesn't appear when the user returns from an interior
-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  if (_hasBeenLoaded == NO) {
      [self displayInteriorControllerForInterior:4];
      _hasBeenLoaded = YES;
  }
}

-(void)displayInteriorControllerForInterior:(int)interior
{
  // Initialize the InteriorController
  _interiorController = [[InteriorController alloc] init];
  [_interiorController initInteriorView];
  
  // Configure InteriorController to report any changes to ViewController
  _interiorController.delegate = self;
  
  // Set the correct interior
  [_interiorController setStageTo:_currentStage andInteriorTo:interior hasVisitedHouses:[_stageModel visitedAllHouses]];
  [_interiorController progressDialogue];
  [self presentViewController:_interiorController animated:NO completion: nil];
}

-(void)returnToStage
{
  [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


-(void)notifyStageComplete
{
  // Let ViewController know the stage has been finished
  if (_currentStage != LAST_STAGE) {
    [self.delegate progressToNextStage];
  }
  else {
    [self showMap];
  }
}

-(void)showMap
{
  [self.delegate showMap];
}

-(void)buttonPressed:(id)button
{
  UIButton* ourButton = (UIButton*)button;
  int tag = (int)ourButton.tag;
  
  [_stageModel visitHouse:tag];
    
  // Change the house to grayscale to indicate it has been visited
  if (_isIndia) {
    [ourButton setBackgroundImage:[UIImage imageNamed:@"IndiaHouse_Desaturated"] forState:UIControlStateNormal];
  }
  if (_isChina) {
    [ourButton setBackgroundImage:[UIImage imageNamed:@"ChinaHouse_Desaturated"] forState:UIControlStateNormal];
  }
  
  [self displayInteriorControllerForInterior:tag];
}

@end
