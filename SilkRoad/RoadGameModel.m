//
//  RoadGameModel.m
//  SilkRoad
//
//  Created by CS121 on 10/18/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "RoadGameModel.h"

@interface Node : NSObject
  @property int numConnections;
  @property int origNumConnections;
@end

@implementation Node

- (Node*)initWithNumConnections:(int)numConnections;
{
  Node* newNode = [[Node alloc] init];
  newNode.numConnections = numConnections;
  newNode.origNumConnections = numConnections;
  return newNode;
}

@end

@interface RoadGameModel()
{
  NSMutableArray* _grid;
  NSMutableDictionary* _connections;
  int _connectionsLeftToMake;
}
@end

@implementation RoadGameModel

- (void)initGrid
{
  NSString *path;
  NSError *error;
  
  path = [[NSBundle mainBundle] pathForResource:@"RoadPuzzle1" ofType:@"txt"];
  
  NSString* gridString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
  NSArray* gridRows = [gridString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
  
                          
  _grid = [[NSMutableArray alloc] initWithCapacity:9];
  _connections = [[NSMutableDictionary alloc] init];
  _connectionsLeftToMake = 0;
  
  for (int row = 0; row < 9; row++) {
    [_grid addObject:[[NSMutableArray alloc] initWithCapacity:9]];
    for (int col = 0; col < 9; col++) {
      NSString* rowString = [gridRows objectAtIndex:row];
      char nodeValue = [rowString characterAtIndex: col];
      
      int numconnections = (int)(nodeValue - '0');
      if (nodeValue == '.') {
        numconnections = 0;
      }
      Node* node = [[Node alloc] initWithNumConnections:numconnections];
      _connectionsLeftToMake += numconnections;
      [[_grid objectAtIndex:row] addObject:node];
    }
  }
}

- (int)getNodeValueAtRow:(int)row AndColumn:(int)col
{
  Node* node = [[_grid objectAtIndex:row] objectAtIndex:col];
  return node.numConnections;
}

- (BOOL)connectionIsValidForRow:(int)row1 Col:(int)col1 AndRow:(int)row2 Col:(int)col2
{
  BOOL isValid = YES;
  
  // Nodes must be in either the same row or same column to be connected
  if (row1 != row2 && col1 != col2) {
    isValid = NO;
  }
  
  // Don't connect a node to itself
  if (row1 == row2 && col1 == col2) {
    isValid = NO;
  }
  
  // Nodes must be neighbors with no interrupting nodes between them
  // Check that there are no other nodes on the same row
  Node* possiblyIntersectingNode;
  if (row1 == row2) {
    
    int startingCol = col1 < col2 ? col1 : col2;
    int endingCol = col2 > col1 ? col2 : col1;
    
    for (int i = startingCol + 1; i < endingCol; i++) {
      possiblyIntersectingNode = [[_grid objectAtIndex:row1] objectAtIndex:i];
      if (possiblyIntersectingNode.origNumConnections != 0) {
        isValid = NO;
      }
    }
  }

  // Check that there are no interrupting nodes between them column wise
  if (col1 == col2) {
    
    int startingRow = row1 < row2 ? row1 : row2;
    int endingRow = row2 > row1 ? row2 : row1;
    
    for (int i = startingRow + 1; i < endingRow; i++) {
      possiblyIntersectingNode = [[_grid objectAtIndex:i] objectAtIndex:col1];
      if (possiblyIntersectingNode.origNumConnections != 0) {
        isValid = NO;
      }
    }
  }
  
  return isValid;
}

- (int)getNumConnectionsToNodeAtRow:(int)row Col:(int)col
{
  Node* node = [[_grid objectAtIndex:row] objectAtIndex:col];
  return node.numConnections;
}

- (int)addConnectionToNodeAtRow:(int)row Col:(int)col
{
  Node* node = [[_grid objectAtIndex:row] objectAtIndex:col];
  node.numConnections--;
  _connectionsLeftToMake--;
  return node.numConnections;
}

- (int)resetNodeAtRow:(int)row Col:(int)col
{
  Node* node = [[_grid objectAtIndex:row] objectAtIndex:col];
  node.numConnections = node.origNumConnections;
  _connectionsLeftToMake += node.numConnections;
  return node.numConnections;
}

- (NSInteger)addConnectionBetweenRow:(int)row1 Col:(int)col1 AndRow:(int)row2 Col:(int)col2
{
  int keyInt;
  if (row1 * 10 + col1 < row2 * 10 + col2) {
    keyInt = row1 * 1000 + col1 * 100 + row2 * 10 + col2;
  } else {
    keyInt = row2 * 1000 + col2 * 100 + row1 * 10 + col1;
  }
  NSString* key = [NSString stringWithFormat:@"%i", keyInt];
  NSInteger value = [[_connections valueForKey:key] integerValue];
  
  // If a player tries to connect two nodes that are already fully connected, reset
  // the number of connections to 0
  NSInteger result = (value + 1) % 3;
  
  // If one of the nodes can only have a maximum of 1 connection and a player tries
  // to add another, also reset the number of connections to 0
  Node* node1 = [[_grid objectAtIndex:row1] objectAtIndex:col1];
  Node* node2 = [[_grid objectAtIndex:row2] objectAtIndex:col2];
  
  if ((node1.origNumConnections == 1 || node2.origNumConnections == 1) && value == 1) {
    result = 0;
  }
  [_connections setValue:[NSNumber numberWithInteger:result] forKey:key];

  return result;
}
@end
