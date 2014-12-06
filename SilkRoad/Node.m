//
//  Node.m
//  SilkRoad
//
//  Created by CS121 on 12/3/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "Node.h"

@implementation Node

-(Node*)initWithNumConnections:(int)numConnections;
{
  Node* newNode = [[Node alloc] init];
  newNode.numConnections = numConnections;
  newNode.origNumConnections = numConnections;
  newNode.connections = [[NSMutableDictionary alloc] init];
  return newNode;
}

@end
