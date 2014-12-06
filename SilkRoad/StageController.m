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
  _isIndia = stage == 0 || stage == 1;
  _isChina = stage == 2 || stage == 3;
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

  // The stage view will take up the same space
  CGRect stageFrame = CGRectMake(0, 0, frameWidth, frameHeight);

  _stageModel = [[StageModel alloc] initForStage:_currentStage];
  
  
  if (_currentStage == 0) {
      UIImage* india1 = [UIImage imageNamed:@"india2"];
      _stageView = [[StageView alloc] initWithFrame:stageFrame background:india1];
  } else if (_currentStage == 1) {
    UIImage* india2 = [UIImage imageNamed:@"india1"];
    _stageView = [[StageView alloc] initWithFrame:stageFrame background:india2];
  } else if (_currentStage == 2) {
    UIImage* china1 = [UIImage imageNamed:@"china2"];
    _stageView = [[StageView alloc] initWithFrame:stageFrame background:china1];
  } else if (_currentStage == 3) {
    UIImage* china2 = [UIImage imageNamed:@"china1"];
    _stageView = [[StageView alloc] initWithFrame:stageFrame background:china2];
  }
  [_stageView loadNewStageWithHouses:[_stageModel getHouses]];
  
  _stageView.delegate = self;
  [self.view addSubview:_stageView];
  [self.view addSubview:_progressView];

  //Initiate has been loaded
  _hasBeenLoaded = NO;
}

//We need the following hack since we can present another view controller in view did load
- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  if (_hasBeenLoaded == NO) {
      [self displayInteriorControllerForInterior:4];
      _hasBeenLoaded = YES;
  }
}

- (void)initializeHousesForStage:(int)stage
{
  _houses =  [[NSMutableArray alloc] init];

  NSArray* houseXCords = @[@300, @500, @300, @500];
  NSArray* houseYCords = @[@300, @500, @300, @500];
  NSArray* houseLabels = @[@"Village Elder", @"Cobbler", @"Butcher", @"Farmer"];


  for (int i = 0; i < NUM_HOUSES; i++) {
    House* newHouse = [House alloc];
    newHouse.visited = NO;
    newHouse.label = [houseLabels objectAtIndex:i];
    newHouse.xCord = (int)[houseXCords objectAtIndex:i];
    newHouse.yCord = (int)[houseYCords objectAtIndex:i];
    newHouse.tag = i;
      
    UIImage* house;
    
    if (_isIndia) {
      house = [UIImage imageNamed:@"IndiaHouse_400"];
    }
    else if (_isChina) {
      house = [UIImage imageNamed:@"ChinaHouse400_250"];
    }
    
    newHouse.image = house;
    [_houses addObject:newHouse];
  }
}

- (void)displayInteriorControllerForInterior:(int)interior
{
  // Initialize the InteriorController
  _interiorController = [[InteriorController alloc] init];
  [_interiorController initInteriorView];
  
  // Configure InteriorController to report any changes to ViewController
  _interiorController.delegate = self;
  
  // Set the correct interior
  [_interiorController setStageTo:_currentStage andInteriorTo:interior hasVisitedHouses:[_stageModel visitedAllHouses]];
  [_interiorController progressDialogue];
  [self presentViewController:_interiorController animated:YES completion: nil];
}

- (void)returnToStage
{
  [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (void)notifyStageComplete
{
  // Let ViewController know the stage has been finished
  NSLog(@"Stage complete!");
  if (_currentStage != LAST_STAGE) {
    [self.delegate progressToNextStage];
  }
  else {
    [self showMap];
  }
}

- (void)showMap
{
  [self.delegate showMap];
}

-(void)switchSound
{
  [self.delegate switchSound];
}

- (void)buttonPressed:(id)button
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
