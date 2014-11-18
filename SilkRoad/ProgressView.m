//
//  ProgressView.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "ProgressView.h"
#import "Constants.h"

@interface ProgressView()
{
    int _currentStage;
}
@end

@implementation ProgressView

- (id)initWithFrame:(CGRect)frame andCurrentStage:(int)stage
{
  self = [super initWithFrame:frame];
  
  if (self) {
    _currentStage = stage;
    NSLog(@"initializing for current stage %d", _currentStage);
    
    // Get the frame size
    CGFloat frameWidth = CGRectGetWidth(frame);
    CGFloat frameHeight = CGRectGetHeight(frame);
    
    // Set up the background for the progress bar
    UILabel* progressBar = [[UILabel alloc] initWithFrame:frame];
    [progressBar setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.75]];
    
    // Add the map button
    CGFloat xPaddingMap = frameWidth * 0.05;
    CGFloat yPaddingMap = (frameHeight - 94) / 2;
    UIButton* mapButton = [[UIButton alloc] initWithFrame:CGRectMake(xPaddingMap, yPaddingMap, 125, 94)];
    [mapButton setBackgroundImage:[UIImage imageNamed:@"mapButton"] forState:UIControlStateNormal];
    [mapButton addTarget:self action:@selector(toggleMap) forControlEvents:UIControlEventTouchUpInside];
    
    // Add the node progress line
    CGFloat lineThickness = frameHeight * 0.01;
    CGFloat xPaddingLine = (2 * xPaddingMap) + 125;
    CGFloat yPaddingLine = (frameHeight - lineThickness) / 2;
    CGFloat lineWidth = frameWidth - xPaddingLine - xPaddingMap;
    UILabel* progressLine = [[UILabel alloc] initWithFrame:CGRectMake(xPaddingLine, yPaddingLine, lineWidth, lineThickness)];
    [progressLine setBackgroundColor:[UIColor whiteColor]];
    
    // Set up the frame for the nodes
    CGFloat nodeSize = 35;
    // There should be the same amount of space before and after each node
    // There is a node for each city, plus the node in the middle
    int numNodes = NUM_CITIES + 1;
    CGFloat nodeXPadding = (lineWidth - (numNodes * nodeSize)) / (numNodes + 1);
    CGFloat nodeYPadding = (frameHeight - nodeSize) / 2;
    
    CGFloat nodeXOffset = xPaddingLine + nodeXPadding;
    NSLog(@"line width: %f",lineWidth);
    NSLog(@"space taken up by nodes: %f",numNodes*nodeSize);
    
    int citiesPerCiv = NUM_CITIES / 2;
    int indexOfCurrent;
    
    if (_currentStage >= citiesPerCiv) {
      indexOfCurrent = NUM_CITIES - (_currentStage - citiesPerCiv);
    }
    else {
      indexOfCurrent = _currentStage;
    }
    
    NSLog(@"Index of current is %d", indexOfCurrent);
    
    // Add everything to the view
    [self addSubview:progressBar];
    [self addSubview:progressLine];
    [self addSubview:mapButton];
    
    // Add all the nodes
    for (int i = 0; i < numNodes; i++) {
      CGRect nodeFrame = CGRectMake(nodeXOffset, nodeYPadding, nodeSize, nodeSize);
      UIImageView *node = [[UIImageView alloc] initWithFrame:nodeFrame];
      
      // Set all the node backgrounds accordingly
      // If it's the center node, it's a star
      if (i == citiesPerCiv) {
        if (_currentStage > NUM_CITIES) {
          [node setImage:[UIImage imageNamed:@"starflow"]];
        }
        else {
          [node setImage:[UIImage imageNamed:@"starnormal"]];          
        }
      }
      // If it's the index of current, it's currently visited
      else if (i == indexOfCurrent) {
        [node setImage:[UIImage imageNamed:@"buttonVisited"]];
      }
      
      // If it's neither of those special cases, we have to do some calculations
      else {
        // Handle the case where we're on the second civ
        if (_currentStage >= citiesPerCiv) {
          // All of the first civ has been visited
          // The second civ up to the current one has been visited
          if (i < citiesPerCiv || i > indexOfCurrent) {
            [node setImage:[UIImage imageNamed:@"buttonVisitedDesaturated"]];
          }
          else {
            [node setImage:[UIImage imageNamed:@"buttonUnvisited"]];
          }
        }
        else {
          if (i < indexOfCurrent) {
            [node setImage:[UIImage imageNamed:@"buttonVisitedDesaturated"]];
          }
          else {
            [node setImage:[UIImage imageNamed:@"buttonUnvisited"]];
          }
        }
      }
      
      // Add the node
      [self addSubview:node];
      
      nodeXOffset += nodeXPadding + nodeSize;
    }
  }
  return self;
}

//-(void)moveToNextStage
//{
//    UIButton* oldStageButton = [_stageButtons objectAtIndex:_currentStage];
//    [oldStageButton setBackgroundColor:[UIColor blackColor]];
//    
//    _currentStage++;
//    
//    UIButton* currentStageButton = [_stageButtons objectAtIndex:_currentStage];
//    [currentStageButton setBackgroundColor:[UIColor greenColor]];
//}

-(void)toggleMap
{
  [self.delegate showMap];
}

@end
