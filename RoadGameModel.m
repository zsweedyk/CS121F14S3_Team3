//
//  RoadGameModel.m
//  SilkRoad
//
//  Created by CS121 on 10/18/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "RoadGameModel.h"

@interface Node : NSObject
  @property int row;
  @property int column;
  @property int numConnections;
@end

@implementation Node

-(Node*)initWithRow:(int)row Column:(int)column AndNumConnections:(int)numConnections
{
  Node* newNode = [[Node alloc] init];
  newNode.row = row;
  newNode.column = column;
  newNode.numConnections = numConnections;
  return newNode;
}

@end

@interface RoadGameModel()
{
  NSMutableArray* _grid;
  NSMutableArray* _nodeList;
  NSMutableDictionary* _connections;
}
@end

@implementation RoadGameModel

-(void)initGrid
{
  NSString *path;
  NSError *error;
  
  path = [[NSBundle mainBundle] pathForResource:@"RoadPuzzle1" ofType:@"txt"];
  
  NSString* gridString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
  NSArray* gridRows = [gridString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                          
                          
  _grid = [[NSMutableArray alloc] initWithCapacity:9];
  
  for (int row = 0; row < 9; row++) {
    [_grid addObject:[[NSMutableArray alloc] initWithCapacity:9]];
    for (int col = 0; col < 9; col++) {
      NSString* rowString = [gridRows objectAtIndex:row];
      char nodeValue = [rowString characterAtIndex: col];
      
      int numconnections = (int)(nodeValue - '0');
      if (nodeValue == '.') {
        numconnections = 0;
      }
      Node* node = [[Node alloc] initWithRow:row Column:col AndNumConnections:numconnections];
      [_nodeList addObject:node];
      [[_grid objectAtIndex:row] addObject:node];
    }
  }
}

-(int)getNodeValueAtRow:(int)row AndColumn:(int)col
{
  Node* node = [[_grid objectAtIndex:row] objectAtIndex:col];
  return node.numConnections;
}

@end
