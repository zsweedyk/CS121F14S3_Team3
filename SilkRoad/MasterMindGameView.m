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
  int _numTurns;
  int _charSize;
}
@end

@implementation MasterMindGameView

-(id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  
  if (self) {
    _turnFeedbackView = [[UIView alloc] init];
    _password = [[UIView alloc] init];
    _charSize = 35;
    CGFloat frameWidth = CGRectGetWidth(frame);
    CGFloat frameHeight = CGRectGetHeight(frame);
    //[self initTurnsViewWithFrame:CGRectMake(frameWidth*.2, frameHeight*.05, frameWidth-(frameWidth*.4), frameHeight-(frameHeight*.1))];
    [self initTurnsViewWithFrame:frame];
    [self initFeedbackViewWithFrame:frame];
    [self setBackgroundColor:[UIColor grayColor]];
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
  CGFloat verticalPadding = frameHeight * 0.05;
  
  // Set the x- and y-offsets accordingly
  CGFloat xOffset = horizontalPadding;
  CGFloat yOffset = verticalPadding;//frameHeight - ((2 * cellSize) + verticalPadding);
  
  // Create 2 rows of 6 cells
  for (int row = 0; row < 10; row++) {
    for (int col = 0; col < 4; col++) {
      CGRect cellFrame = CGRectMake(xOffset, yOffset, cellSize, cellSize);
      UIButton *cell = [[UIButton alloc] initWithFrame:cellFrame];
      cell.tag = (row * 4) + col;
      
      [_turnViewButtons insertObject:cell atIndex:cell.tag];
      [cell setBackgroundColor:[UIColor blueColor]];
      [self addSubview:cell];
      
      xOffset += 2*cellSize;
    }
    
    xOffset = horizontalPadding;
    yOffset += 2*cellSize;
  }
  
}

-(void)initFeedbackViewWithFrame:(CGRect)frame
{
  _turnView = [[UIView alloc] initWithFrame:frame];
  // Get the dimensions of the frame
  CGFloat frameWidth = CGRectGetWidth(frame);
  CGFloat frameHeight = CGRectGetHeight(frame);
  
  // Make each cell in the tray the size of a button with 5% padding on all sides
  CGFloat cellSize = _charSize/4;
  CGFloat horizontalPadding = (frameWidth - (cellSize * 5.5)) / 2 + 5.75*_charSize;
  CGFloat verticalPadding = frameHeight * 0.05;
  
  // Set the x- and y-offsets accordingly
  CGFloat xOffset = horizontalPadding;
  CGFloat yOffset = verticalPadding + cellSize;//frameHeight - ((2 * cellSize) + verticalPadding);
  
  // Create 2 rows of 6 cells
  for (int row = 0; row < 20; row++) {
    for (int col = 0; col < 2; col++) {
        CGRect cellFrame = CGRectMake(xOffset, yOffset, cellSize, cellSize);
        UIButton *cell = [[UIButton alloc] initWithFrame:cellFrame];
        cell.tag = (row * 4) + col;
        
        [_turnViewButtons insertObject:cell atIndex:cell.tag];
        [cell setBackgroundColor:[UIColor blueColor]];
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
    UIButton* currentButton = [_turnViewFeedbackButtons objectAtIndex:_numTurns+i];
    [currentButton setBackgroundColor:[UIColor blackColor]];
    exactMatches--;
    i++;
  }
  //Then set half matches to white
  while (i < 4 && halfMatches > 0) {
    UIButton* currentButton = [_turnViewFeedbackButtons objectAtIndex:_numTurns+i];
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