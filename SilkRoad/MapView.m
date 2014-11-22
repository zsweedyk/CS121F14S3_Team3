//
//  MapView.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "MapView.h"
#import "Constants.h"


@interface MapView() {
  int _currentStage;
  UIImage* _map;
  NSMutableArray* _stageButtons;
  UIButton* _backButton;
  UIButton* _roadGameButton;
  UIButton* _scalesGameButton;
}
@end

@implementation MapView

-(id)initWithFrame:(CGRect)frame {
  
  self = [super initWithFrame:frame];
  
  if (self) {
    _stageButtons = [[NSMutableArray alloc] initWithCapacity:NUM_CITIES];
    
    //Set background image
    UIImageView* backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map"]];
    backgroundView.frame = frame;
    [self addSubview:backgroundView];
    
    //Create back button
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 125, 125)];
    [_backButton setBackgroundImage:[UIImage imageNamed:@"buttonVisited"] forState:UIControlStateNormal];
    [_backButton setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(hideMap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backButton];
    
    [self createGameButtons];

    //Make city buttons
    [self addButtonNumber:0 WithFrame:CGRectMake(375, 400, 35, 35)];
    [self addButtonNumber:1 WithFrame:CGRectMake(415, 355, 35, 35)];
    [self addButtonNumber:2 WithFrame:CGRectMake(650, 335, 35, 35)];
    [self addButtonNumber:3 WithFrame:CGRectMake(550, 300, 35, 35)];
    
    //Set action for first city
    [[_stageButtons objectAtIndex:0] addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
  }
  return self;
  
}

- (void) createGameButtons
{
  _roadGameButton = [[UIButton alloc] initWithFrame:CGRectMake(860, 600, 125, 125)];
  [_roadGameButton setBackgroundImage:[UIImage imageNamed:@"roadGameButtonDesaturated"] forState:UIControlStateNormal];
  _scalesGameButton = [[UIButton alloc] initWithFrame:CGRectMake(700, 600, 125, 125)];
  [_scalesGameButton setBackgroundImage:[UIImage imageNamed:@"scalesGameButtonDesaturated"] forState:UIControlStateNormal];
  [self addSubview:_roadGameButton];
  [self addSubview:_scalesGameButton];
}

- (void) addButtonNumber:(int)index WithFrame:(CGRect)buttonFrame
{
  UIButton* city = [[UIButton alloc] initWithFrame:buttonFrame];
  [city setBackgroundImage:[UIImage imageNamed:@"buttonUnvisited"] forState:UIControlStateNormal];
  [city setTag:index];
  [self addSubview:city];
  [_stageButtons insertObject:city atIndex:index];
}

- (void)buttonPressed:(id)button
{
  UIButton* ourButton = (UIButton*)button;
  int tag = (int)ourButton.tag;
  NSLog(@"inButtonPressed MV at tag %d", tag);
  [self.delegate jumpToStage:tag];
}

-(void)moveToNextStage
{
  //Desaturate the last stage
  UIButton* finishedStageButton = [_stageButtons objectAtIndex:_currentStage];
  [finishedStageButton setBackgroundImage:[UIImage imageNamed:@"buttonVisitedDesaturated"] forState:UIControlStateNormal];
  
  _currentStage++;
  
  //Highlight the new stage and connect it to the button pressed method
  UIButton* currentStageButton = [_stageButtons objectAtIndex:_currentStage];
  [currentStageButton setBackgroundImage:[UIImage imageNamed:@"buttonVisited"] forState:UIControlStateNormal];
  [currentStageButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
  
  if (_currentStage == 2) {
    //You've beaten the scales game, have a button that lets you play again!
    [_scalesGameButton setBackgroundImage:[UIImage imageNamed:@"scalesGameButton"] forState:UIControlStateNormal];
    [_scalesGameButton addTarget:self action:@selector(goToScalesGame) forControlEvents:UIControlEventTouchUpInside];
  }
  
  if (_currentStage == 3) {
    //You've beaten the road game, have a button that lets you play again!
    [_roadGameButton setBackgroundImage:[UIImage imageNamed:@"roadGameButton"] forState:UIControlStateNormal];
    [_roadGameButton addTarget:self action:@selector(goToRoadGame) forControlEvents:UIControlEventTouchUpInside];
  }
}

-(void)hideMap
{
  [self.delegate hideMap];
}

- (void) goToScalesGame
{
  [self.delegate goToScalesGame];
}

- (void) goToRoadGame
{
  [self.delegate goToRoadGame];
}

@end
