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
  @property NSMutableDictionary* connections;
@end

@implementation Node

- (Node*)initWithNumConnections:(int)numConnections;
{
  Node* newNode = [[Node alloc] init];
  newNode.numConnections = numConnections;
  newNode.origNumConnections = numConnections;
  newNode.connections = [[NSMutableDictionary alloc] init];
  return newNode;
}

@end

@interface RoadGameModel()
{
  NSMutableArray* _grid;
  int _connectionsLeftToMake;
}
@end

@implementation RoadGameModel

- (void)initGridWithFile:(NSString*)filename
{
  NSString *path;
  NSError *error;
  
  path = [[NSBundle mainBundle] pathForResource:filename ofType:@"txt"];
  
  NSString* gridString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
  NSArray* gridRows = [gridString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

  _grid = [[NSMutableArray alloc] initWithCapacity:9];
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

- (int)getNumAvailableConnectionsToNodeAtRow:(int)row Col:(int)col
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

- (int)resetNodeAtRow:(int)row Col:(int)col ByValue:(NSInteger)value;
{
  Node* node = [[_grid objectAtIndex:row] objectAtIndex:col];
  node.numConnections += (int)value;
  _connectionsLeftToMake += value;
  return node.numConnections;
}

- (NSInteger)getNumConnectionsBetweenRow:(int)row1 Col:(int)col1 AndRow:(int)row2 Col:(int)col2
{
  Node* node = [[_grid objectAtIndex:row1] objectAtIndex:col1];
  NSString* key = [NSString stringWithFormat:@"%i", row2 * 10 + col2];
  NSInteger value = [[node.connections valueForKey:key] integerValue];
  return value;
}

- (NSInteger)numConnectionsAfterUpdateForRow:(int)row1 Col:(int)col1 AndRow:(int)row2 Col:(int)col2
{
  // If one of the nodes can only have a maximum of 1 connection and a player tries
  // to add another, also reset the number of connections to 0
  Node* node1 = [[_grid objectAtIndex:row1] objectAtIndex:col1];
  Node* node2 = [[_grid objectAtIndex:row2] objectAtIndex:col2];
  
  NSInteger value1 = [self getNumConnectionsBetweenRow:row1 Col:col1 AndRow:row2 Col:col2];
  NSInteger value2 = [self getNumConnectionsBetweenRow:row2 Col:col2 AndRow:row1 Col:col1];
  
  assert(value1 == value2);
  
  // If a player tries to connect two nodes that are already fully connected, reset
  // the number of connections to 0
  NSInteger result = (value1 + 1) % 3;

  if ((node1.origNumConnections == 1 || node2.origNumConnections == 1) && result == 2) {
    result = 0;
  }
  
  // Reset the connection if either node has a zero value
  if (node1.numConnections == 0 || node2.numConnections == 0) {
    result = 0;
  }
  
  return result;
}

- (void)setNumConnectionsBetweenRow:(int)row1 Col:(int)col1 AndRow:(int)row2 Col:(int)col2 ToValue:(NSInteger)value
{
  Node* node = [[_grid objectAtIndex:row1] objectAtIndex:col1];
  NSString* key = [NSString stringWithFormat:@"%i", row2 * 10 + col2];
  [node.connections setValue:[NSNumber numberWithInteger:value] forKey:key];
}

- (void)addConnectionBetweenRow:(int)row1 Col:(int)col1 AndRow:(int)row2 Col:(int)col2
{
  NSInteger value1 = [self getNumConnectionsBetweenRow:row1 Col:col1 AndRow:row2 Col:col2];
  NSInteger value2 = [self getNumConnectionsBetweenRow:row2 Col:col2 AndRow:row1 Col:col1];
  
  assert(value1 == value2);

  NSInteger result = value1 + 1;
  
  [self setNumConnectionsBetweenRow:row1 Col:col1 AndRow:row2 Col:col2 ToValue:result];
  [self setNumConnectionsBetweenRow:row2 Col:col2 AndRow:row1 Col:col1 ToValue:result];
  
  [self addConnectionToNodeAtRow:row1 Col:col1];
  [self addConnectionToNodeAtRow:row2 Col:col2];
}

- (void)resetConnectionBetweenRow:(int)row1 Col:(int)col1 AndRow:(int)row2 Col:(int)col2
{
  NSInteger value1 = [self getNumConnectionsBetweenRow:row1 Col:col1 AndRow:row2 Col:col2];
  NSInteger value2 = [self getNumConnectionsBetweenRow:row2 Col:col2 AndRow:row1 Col:col1];
  
  assert(value1 == value2);

  [self setNumConnectionsBetweenRow:row1 Col:col1 AndRow:row2 Col:col2 ToValue:0];
  [self setNumConnectionsBetweenRow:row2 Col:col2 AndRow:row1 Col:col1 ToValue:0];
  
  [self resetNodeAtRow:row1 Col:col1 ByValue:value1];
  [self resetNodeAtRow:row2 Col:col2 ByValue:value2];
}

- (void)resetGame
{
  for (int i = 0; i < 9; i++) {
    for (int j = 0; j < 9; j++) {
      Node* node = [[_grid objectAtIndex:i] objectAtIndex:j];
      node.numConnections = node.origNumConnections;
      node.connections = [[NSMutableDictionary alloc] init];
    }
  }
}

- (BOOL)hasBeenWon
{
  return _connectionsLeftToMake == 0;
}
@end
