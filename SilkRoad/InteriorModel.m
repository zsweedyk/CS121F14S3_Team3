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

/*
 * The entire dialogue of the game is stored in Dialogue.txt
 * Each line in this file is the dialogue for a given stage, which is '/' separated into houses
 * This is further comma separated into multiple lines of dialogue for a house
 */
-(void)initializeAllDialogue
{
  NSString *path;
  NSError *error;
  
  path = [[NSBundle mainBundle] pathForResource:@"Dialogue" ofType:@"txt"];
  
  NSString *dialogueString = [[NSString alloc] initWithContentsOfFile:path
                                                            encoding:NSUTF8StringEncoding error:&error];

  _allDialogue = [[NSMutableArray alloc] init];
  NSArray* separateStages =  [dialogueString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
  int numStages = [separateStages count];
  for (int i = 0; i < numStages; i++) {
    
    NSArray* separateHouses = [[separateStages objectAtIndex:i] componentsSeparatedByString:@"/"];
    [_allDialogue addObject:[[NSMutableArray alloc] init]];
    NSLog(@"%@", separateHouses);
    
    int numHousesInStage = [separateHouses count];
    for (int j = 0; j < numHousesInStage; j++) {
      NSArray* separateLines = [[separateHouses objectAtIndex:j] componentsSeparatedByString:@","];
      [[_allDialogue objectAtIndex:i] addObject:separateLines];
    }
  }
}

// TODO this may change when houses are clickable
-(void)initForStage:(int)stage andHouse:(int)house
{
  _dialogueForCurrentHouse = [[NSMutableArray alloc] initWithArray:[[_allDialogue objectAtIndex:stage]objectAtIndex:house]];
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
