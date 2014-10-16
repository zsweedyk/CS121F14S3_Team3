//
//  InteriorModel.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "InteriorModel.h"

@interface InteriorModel()
{
    NSMutableArray* _allDialogue; // Very nested array: dialogue for house for stage
    NSMutableArray* _dialogueForCurrentHouse;
    int _currentLine;
}

@end

@implementation InteriorModel

-(void)initializeAllDialogue
{
  // TODO read from a file, probably. missing a level of nesting currently
  _allDialogue = [[NSMutableArray alloc] initWithCapacity:4];
  for (int i = 0; i < 4; i++) {
    NSMutableArray* subArray = [[NSMutableArray alloc] init];
    [subArray addObject:@"dialogue"];
    [subArray addObject:@"next dialogue"];
    [_allDialogue addObject:subArray];
  }
}

// TODO this may change when houses are clickable
-(void)initForStage:(int)stage AndHouse:(int)house
{
  _dialogueForCurrentHouse = [[NSMutableArray alloc] initWithArray:[_allDialogue objectAtIndex:stage]];
}

-(BOOL)dialogueFinished
{
  return _currentLine < [_dialogueForCurrentHouse count];
}

-(NSString*)getNextLineOfDialogue
{
  return _dialogueForCurrentHouse[_currentLine++];
}

@end
