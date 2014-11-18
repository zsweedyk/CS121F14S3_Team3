//
//  MapView.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "MapView.h"
//#import "ScalesGameController.h"
//#import "RoadGameController.h"
#import "Constants.h"


@interface MapView() {
  int _currentStage;
  UIImage* _map;
  NSMutableArray* _stageButtons;
//  ScalesGameController* _scalesGameController;
//  RoadGameController* _roadGameController;
  UIButton* _backButton;
  UIButton* _roadGameButton;
  UIButton* _scalesGameButton;
  UIButton* firstCity; //ujjain
  UIButton* secondCity; //pataliputra
  UIButton* thirdCity;
  UIButton* fourthCity;
}
@end

@implementation MapView

-(id)initWithFrame:(CGRect)frame {
  
  self = [super initWithFrame:frame];
  
  if (self) {
    //[self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"map"]]];
    
    UIImageView* backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map"]];
    backgroundView.frame = frame;
    [self addSubview:backgroundView];
    CGRect buttonFrame1 = CGRectMake(375, 400, 35, 35);
    CGRect buttonFrame2 = CGRectMake(415, 355, 35, 35);
    CGRect buttonFrame3 = CGRectMake(550, 300, 35, 35);
    CGRect buttonFrame4 = CGRectMake(650, 335, 35, 35);
    firstCity = [[UIButton alloc] initWithFrame:buttonFrame1];
    secondCity = [[UIButton alloc] initWithFrame:buttonFrame2];
    thirdCity = [[UIButton alloc] initWithFrame:buttonFrame3];
    fourthCity = [[UIButton alloc] initWithFrame:buttonFrame4];
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 125, 125)];
    [_backButton setBackgroundImage:[UIImage imageNamed:@"buttonVisited"] forState:UIControlStateNormal];
    _roadGameButton = [[UIButton alloc] initWithFrame:CGRectMake(860, 600, 125, 125)];
    [_roadGameButton setBackgroundImage:[UIImage imageNamed:@"roadGameButtonDesaturated"] forState:UIControlStateNormal];
    _scalesGameButton = [[UIButton alloc] initWithFrame:CGRectMake(700, 600, 125, 125)];
    [_scalesGameButton setBackgroundImage:[UIImage imageNamed:@"scalesGameButtonDesaturated"] forState:UIControlStateNormal];
    [_stageButtons insertObject:firstCity atIndex:0];
    [_stageButtons insertObject:secondCity atIndex:1];
    [_stageButtons insertObject:thirdCity atIndex:2];
    [_stageButtons insertObject:fourthCity atIndex:3];
    [self addSubview:firstCity];
    [self addSubview:secondCity];
    [self addSubview:thirdCity];
    [self addSubview:fourthCity];
    [self addSubview:_backButton];
    [self addSubview:_roadGameButton];
    [self addSubview:_scalesGameButton];
    [firstCity setBackgroundImage:[UIImage imageNamed:@"buttonVisited"] forState:UIControlStateNormal];
    [firstCity addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [secondCity setBackgroundImage:[UIImage imageNamed:@"buttonUnvisited"] forState:UIControlStateNormal];
    [thirdCity setBackgroundImage:[UIImage imageNamed:@"buttonUnvisited"] forState:UIControlStateNormal];
    [fourthCity setBackgroundImage:[UIImage imageNamed:@"buttonUnvisited"] forState:UIControlStateNormal];
    [_backButton setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [firstCity setTag:0];
    [secondCity setTag:1];
    [thirdCity setTag:2];
    [fourthCity setTag:3];
    
    
    [_backButton addTarget:self action:@selector(hideMap) forControlEvents:UIControlEventTouchUpInside];
  }
  return self;
  
}

- (void) goToScalesGame
{
  [self.delegate goToScalesGame];
}

- (void) goToRoadGame
{
  [self.delegate goToRoadGame];
}

- (void)buttonPressed:(id)button
{
  UIButton* ourButton = (UIButton*)button;
  int tag = (int)ourButton.tag;
  NSLog(@"inButtonPressed MV at tag %d", tag);
  [self.delegate jumpToStage:tag];
}

-(void)hideMap
{
  [self.delegate hideMap];
}

-(void)moveToNextStage
{
  _currentStage++;
  if (_currentStage == 1) {
    [firstCity setBackgroundImage:[UIImage imageNamed:@"buttonVisitedDesaturated"] forState:UIControlStateNormal];
    [secondCity setBackgroundImage:[UIImage imageNamed:@"buttonVisited"] forState:UIControlStateNormal];
    [secondCity addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
  }
  if (_currentStage == 2) {
    [secondCity setBackgroundImage:[UIImage imageNamed:@"buttonVisitedDesaturated"] forState:UIControlStateNormal];
    [thirdCity setBackgroundImage:[UIImage imageNamed:@"buttonVisited"] forState:UIControlStateNormal];
    [thirdCity addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_scalesGameButton setBackgroundImage:[UIImage imageNamed:@"scalesGameButton"] forState:UIControlStateNormal];
    [_scalesGameButton addTarget:self action:@selector(goToScalesGame) forControlEvents:UIControlEventTouchUpInside];
  }
  if (_currentStage == 3) {
    [thirdCity setBackgroundImage:[UIImage imageNamed:@"buttonVisitedDesaturated"] forState:UIControlStateNormal];
    [fourthCity setBackgroundImage:[UIImage imageNamed:@"buttonVisited"] forState:UIControlStateNormal];
    [fourthCity addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_roadGameButton setBackgroundImage:[UIImage imageNamed:@"roadGameButton"] forState:UIControlStateNormal];
    [_roadGameButton addTarget:self action:@selector(goToRoadGame) forControlEvents:UIControlEventTouchUpInside];
  }
  
  UIButton* currentStageButton = [_stageButtons objectAtIndex:_currentStage];
  [currentStageButton setBackgroundImage:[UIImage imageNamed:@"buttonVisited"] forState:UIControlStateNormal];
}

@end
