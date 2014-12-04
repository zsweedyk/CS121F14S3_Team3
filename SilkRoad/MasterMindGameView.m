//
//  MasterMindGameView.m
//  SilkRoad
//
//  Created by Katharine Finlay on 11/23/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MasterMindGameView.h"

@interface MasterMindGameView()
{
  UIView* _turnView;
  UIView* _turnFeedbackView;
  UIView* _password;
  NSMutableArray* _turnViewButtons;
  NSMutableArray* _turnViewFeedbackButtons;
  NSMutableArray* _letterButtons;
  int _currentTurn[4];
  int _numTurns;
  int _charSize;
  int _inputCharSelected;
  UIButton* _checkSolutionButton;
}
@end

@implementation MasterMindGameView

-(id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  
  if (self) {
    _turnViewButtons = [[NSMutableArray alloc] init];
    _turnViewFeedbackButtons = [[NSMutableArray alloc] init];
    _letterButtons = [[NSMutableArray alloc] init];
    _turnFeedbackView = [[UIView alloc] init];
    _password = [[UIView alloc] init];
    _charSize = 35;
    [self initTurnsViewWithFrame:frame];
    [self initFeedbackViewWithFrame:frame];
    [self initLettersWithFrame:frame];
    [self setBackgroundColor:[UIColor grayColor]];
    _checkSolutionButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)*.8, CGRectGetHeight(frame)*.5, 200, 50)];
    [self addSubview:_checkSolutionButton];
    [_checkSolutionButton addTarget:self action:@selector(checkSolution) forControlEvents:UIControlEventTouchUpInside];
    [_checkSolutionButton setBackgroundColor:[UIColor redColor]];
    [_checkSolutionButton setTitle:@"Check Solution" forState:UIControlStateNormal];
    _checkSolutionButton.showsTouchWhenHighlighted = YES;
    for (int i = 0; i < 4; ++i) {
      _currentTurn[i] = 100;
    }
  }
  
  return self;
}

-(void)initTurnsViewWithFrame:(CGRect)frame
{
  _turnView = [[UIView alloc] initWithFrame:frame];
  // Get the dimensions of the frame
  CGFloat frameWidth = CGRectGetWidth(frame);
  CGFloat frameHeight = CGRectGetHeight(frame);
  
  // Make each cell in the tray the size of a button with 5% padding on all sides
  CGFloat cellSize = _charSize + (_charSize * 0.10);
  CGFloat horizontalPadding = (frameWidth - (cellSize * 5.5)) / 2;
  CGFloat verticalPadding = (frameHeight - 19*cellSize)/2;
  
  // Set the x- and y-offsets accordingly
  CGFloat xOffset = horizontalPadding;
  CGFloat yOffset = verticalPadding;
  
  // Create 2 rows of 6 cells
  for (int row = 0; row < 10; row++) {
    for (int col = 0; col < 4; col++) {
      CGRect cellFrame = CGRectMake(xOffset, yOffset, cellSize, cellSize);
      UIButton *cell = [[UIButton alloc] initWithFrame:cellFrame];
      //tags start at 50, then increase by 10's so that the color can be added in the 1's place
      cell.tag = row*4+col;
      
      [_turnViewButtons addObject:cell];
      [cell setBackgroundColor:[UIColor blueColor]];
      cell.showsTouchWhenHighlighted = YES;
      [self addSubview:cell];
      [cell addTarget:self action:@selector(turnCharSelected:) forControlEvents:UIControlEventTouchUpInside];
      
      xOffset += 2*cellSize;
    }
    
    xOffset = horizontalPadding;
    yOffset += 2*cellSize;
  }
  
}

-(void)initFeedbackViewWithFrame:(CGRect)frame
{
  _turnFeedbackView = [[UIView alloc] initWithFrame:frame];
  // Get the dimensions of the frame
  CGFloat frameWidth = CGRectGetWidth(frame);
  CGFloat frameHeight = CGRectGetHeight(frame);
  
  // Make each cell in the tray the size of a button with 5% padding on all sides
  CGFloat cellSize = _charSize/4;
  CGFloat horizontalPadding = (frameWidth - (cellSize * 5.5)) / 2 + 5.75*_charSize;
  CGFloat verticalPadding = (frameHeight - 21*_charSize)/2;
  
  // Set the x- and y-offsets accordingly
  CGFloat xOffset = horizontalPadding;
  CGFloat yOffset = verticalPadding + cellSize;//frameHeight - ((2 * cellSize) + verticalPadding);
  
  // Create 2 rows of 6 cells
  for (int row = 0; row < 20; row++) {
    for (int col = 0; col < 2; col++) {
      CGRect cellFrame = CGRectMake(xOffset, yOffset, cellSize, cellSize);
      UIButton *cell = [[UIButton alloc] initWithFrame:cellFrame];
      cell.tag = (row * 4) + col;
      
      [_turnViewFeedbackButtons addObject:cell];
      [cell setBackgroundColor:[UIColor blueColor]];
      cell.showsTouchWhenHighlighted = YES;
      [self addSubview:cell];
      
      xOffset += 2*cellSize;
    }
    if (row%2 != 0) {
      yOffset += 1.5*_charSize + 1.05*cellSize;
    } else {
      yOffset += 2*cellSize;
    }
    xOffset = horizontalPadding;
  }
  
}

-(void)initLettersWithFrame:(CGRect)frame
{
  // Get the dimensions of the frame
  CGFloat frameWidth = CGRectGetWidth(frame);
  CGFloat frameHeight = CGRectGetHeight(frame);
  
  // Make each cell in the tray the size of a button with 5% padding on all sides
  CGFloat cellSize = _charSize*1.5;
  CGFloat horizontalPadding = frameWidth/10 - cellSize;
  CGFloat verticalPadding = frameHeight/2 - cellSize/2;
  
  // Set the x- and y-offsets accordingly
  CGFloat xOffset = horizontalPadding;
  CGFloat yOffset = verticalPadding;
  int numTurnButtons = (int) [_turnViewButtons count];
  
  // Create 2 rows of 6 cells
  for (int i = 0; i < 4; i++) {
    CGRect cellFrame = CGRectMake(xOffset, yOffset, cellSize, cellSize);
    UIButton *cell = [[UIButton alloc] initWithFrame:cellFrame];
    cell.tag = i;
    [cell addTarget:self action:@selector(letterSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    //TODO: set images for letter bank
    if (i == 0) {
      //TODO: display first button as selected, darkened, desaturated, what have you
      [cell setBackgroundColor:[UIColor blackColor]];
    } else if (i == 1) {
      [cell setBackgroundColor:[UIColor orangeColor]];
    } else if (i == 2) {
      [cell setBackgroundColor:[UIColor greenColor]];
    } else {
      [cell setBackgroundColor:[UIColor purpleColor]];
    }
    
    [_letterButtons addObject:cell];
    cell.showsTouchWhenHighlighted = YES;
    [self addSubview:cell];
    
    xOffset += 1.5*cellSize;
  }
  
  _inputCharSelected = 0;
  
  
}

-(void)displayButton:(UIButton*) button forChar: (int)character
{
  NSAssert(character <= 3, @"making sure letter button is displaying a char in change");
  if (character == 0) {
    [button setBackgroundColor:[UIColor redColor]];
  } else if (character == 1) {
    [button setBackgroundColor:[UIColor orangeColor]];
  } else if (character == 2) {
    [button setBackgroundColor:[UIColor greenColor]];
  } else {
    [button setBackgroundColor:[UIColor purpleColor]];
  }
}


-(void)letterSelected:(id)sender
{
  UIButton *newButton = (UIButton*) sender;
  
  int newTag = (int) [newButton tag];
    UIButton *oldButton = [_letterButtons objectAtIndex:_inputCharSelected];
    int oldTag = (int) [oldButton tag];
    [self displayButton:oldButton forChar:oldTag];
    _inputCharSelected = newTag;
    //TODO: set graphic for highlighted letter bank character
    [newButton setBackgroundColor:[UIColor blackColor]];
  //if button selected is in the current playable row

}

-(void)turnCharSelected:(id)sender
{
  UIButton *newButton = (UIButton*) sender;
  
  int tag = (int) [newButton tag];
  UIButton* buttonSelected = [_turnViewButtons objectAtIndex:tag];
  //TODO: display turn view button as new char
  [self displayButton:buttonSelected forChar:_inputCharSelected];
  if (_numTurns == 0) {
    _currentTurn[tag] = _inputCharSelected;
  } else {
    _currentTurn[tag % (_numTurns*4)] = _inputCharSelected;
  }
}

-(void)checkSolution
{
  for (int i = 0; i < 4; i++) {
    if (_currentTurn[i] == 100) //not been set
      return;
  }
  _numTurns++;
  int matches = [self.delegate checkSolution:_currentTurn];
  for (int i = 0; i < 4; i++) { //clear new turn solution
    _currentTurn[i] = 100;
  }
  [self displayNewTurnFeedback:matches];
}


-(void)displayNewTurn:(int*) turn
{
  for (int i = 0; i < 4; i++) {
    UIButton* currentButton = [_turnViewButtons objectAtIndex:_numTurns+i];
    switch (turn[i]) {
      case 0:
        [currentButton setBackgroundColor:[UIColor redColor]];
      case 1:
        [currentButton setBackgroundColor:[UIColor greenColor]];
      case 2:
        [currentButton setBackgroundColor:[UIColor purpleColor]];
      case 3:
        [currentButton setBackgroundColor:[UIColor yellowColor]];
    }
  }
}

-(void)displayNewTurnFeedback:(int) matches
{
  int exactMatches = matches/10;
  int halfMatches = matches % 10;
  int i = 0;
  //First set exact matches to black
  while (i < 4 && exactMatches > 0) {
    int index = ((_numTurns-1)*4)+i;
    UIButton* currentButton = [_turnViewFeedbackButtons objectAtIndex:index];
    [currentButton setBackgroundColor:[UIColor blackColor]];
    exactMatches--;
    i++;
  }
  //Then set half matches to white
  while (i < 4 && halfMatches > 0) {
    UIButton* currentButton = [_turnViewFeedbackButtons objectAtIndex:((_numTurns-1)*4)+i];
    [currentButton setBackgroundColor:[UIColor whiteColor]];
    halfMatches--;
    i++;
  }
}

-(void)displayPassword:(int*) password
{
  _numTurns = 11;
  [self displayNewTurn:password];
}

-(void)clearBoard
{
  _numTurns = 0;
  for (int i = 0; i < 4; i++) {
    UIButton* currentButton = [_turnViewButtons objectAtIndex:_numTurns+i];
    UIButton* currentFeedbackButton = [_turnViewButtons objectAtIndex:_numTurns+i];
    [currentButton setBackgroundColor:[UIColor blueColor]];
    [currentFeedbackButton setBackgroundColor:[UIColor blueColor]];
  }
}

@end