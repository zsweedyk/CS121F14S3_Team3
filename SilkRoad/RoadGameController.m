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

- (id)init
{
  self = [super init];
  
  if (self) {
    // Initialize gameModel
    _gameModel = [[RoadGameModel alloc] init];
    [_gameModel initGridWithFile:@"RoadPuzzle1"];
    
    _gameView = [[RoadGameView alloc] initWithFrame:self.view.frame];
    _gameView.delegate = self;
    [self.view addSubview:_gameView];
    
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        int nodeValue = [_gameModel getNumAvailableConnectionsToNodeAtRow:row Col:col];
        if (nodeValue != 0) {
          [_gameView setNodeValueAtRow:row AndColumn:col toValue:nodeValue];
        }
      }
    }
  }
  
  return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self returnToInterior];
  }
  
  int newNumConnectionsForNode1 = [_gameModel getNumAvailableConnectionsToNodeAtRow:row1 Col:col1];
  int newNumConnectionsForNode2 = [_gameModel getNumAvailableConnectionsToNodeAtRow:row2 Col:col2];
  
  [_gameView setNodeValueAtRow:row1 AndColumn:col1 toValue:newNumConnectionsForNode1];
  [_gameView setNodeValueAtRow:row2 AndColumn:col2 toValue:newNumConnectionsForNode2];
  
  return numConnectionsAfterUpdate;
}

- (BOOL)hasBeenWon
{
  return [_gameModel hasBeenWon];
}
-(void)returnToInterior
{
  [self.delegate returnToInterior];
}
@end
