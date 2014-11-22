//
//  RoadGameController.m
//  SilkRoad
//
//  Created by CS121 on 10/18/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "RoadGameController.h"
#import "RoadGameModel.h"
#import "RoadGameView.h"

@interface RoadGameController ()
{
  RoadGameModel* _gameModel;
  RoadGameView* _gameView;
}
@end

@implementation RoadGameController

-(id)init
{
  self = [super init];
  
  if (self) {
    [self initGame];
  }
  
  return self;
}

-(void)initGame
{
  // Initialize gameModel
  _gameModel = [[RoadGameModel alloc] init];
  int puzzleNumber = arc4random_uniform(12);
  [_gameModel initGridWithFile:[NSString stringWithFormat:@"RoadPuzzle%i", puzzleNumber]];
  
  _gameView = [[RoadGameView alloc] initWithFrame:self.view.frame];
  _gameView.delegate = self;
  [self.view addSubview:_gameView];
  
  for (int row = 0; row < 9; row++) {
    for (int col = 0; col < 9; col++) {
      int nodeValue = [_gameModel getNumAvailableConnectionsToNodeAtRow:row Col:col];
      if (nodeValue != 0) {
        [_gameView setNodeBackgroundAtRow:row AndColumn:col];
        [_gameView setNodeValueAtRow:row AndColumn:col toValue:nodeValue];
      }
    }
  }
}


-(BOOL)checkConnectionValidBetweenRow:(int)row1 Col:(int)col1 AndRow:(int)row2 Col:(int)col2
{
  return [_gameModel connectionIsValidForRow:row1 Col:col1 AndRow:row2 Col:col2];
}

-(NSInteger)createConnectionBetweenRow:(int)row1 Col:(int)col1 AndRow:(int)row2 Col:(int)col2
{
  NSInteger numConnectionsAfterUpdate = [_gameModel numConnectionsAfterUpdateForRow:row1 Col:col1 AndRow:row2 Col:col2];

  if (numConnectionsAfterUpdate != 0) {
    [_gameModel addConnectionBetweenRow:row1 Col:col1 AndRow:row2 Col:col2];
  } else {
    [_gameModel resetConnectionBetweenRow:row1 Col:col1 AndRow:row2 Col:col2];
  }
  
  if ([_gameModel hasBeenWon]) {
    [self returnToPrevious];
  }
  
  int newNumConnectionsForNode1 = [_gameModel getNumAvailableConnectionsToNodeAtRow:row1 Col:col1];
  int newNumConnectionsForNode2 = [_gameModel getNumAvailableConnectionsToNodeAtRow:row2 Col:col2];
  
  [_gameView setNodeValueAtRow:row1 AndColumn:col1 toValue:newNumConnectionsForNode1];
  [_gameView setNodeValueAtRow:row2 AndColumn:col2 toValue:newNumConnectionsForNode2];
  
  return numConnectionsAfterUpdate;
}

-(BOOL)hasBeenWon
{
  return [_gameModel hasBeenWon];
}

-(void)returnToPrevious
{
  [self.delegate returnToPrevious];
}

-(void)newGame
{
  [self initGame];
}

-(void)resetGame
{
  // Reset underlying values
  [_gameModel resetGame];
  
  // Update values on nodes of view
  for (int row = 0; row < 9; row++) {
    for (int col = 0; col < 9; col++) {
      int nodeValue = [_gameModel getNumAvailableConnectionsToNodeAtRow:row Col:col];
      if (nodeValue != 0) {
        [_gameView setNodeBackgroundAtRow:row AndColumn:col];
        [_gameView setNodeValueAtRow:row AndColumn:col toValue:nodeValue];
      }
    }
  }
  
  // Remove all drawn lines
  [_gameView resetLines];
}

-(void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
