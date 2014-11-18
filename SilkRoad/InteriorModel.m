//
//  InteriorModel.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "InteriorModel.h"

const int winDialogueLocation = 1;
const int transitionDialogueLocation = 2;

@interface InteriorModel()
{
    NSMutableArray* _allDialogues; // Necessary for storing the win dialogue
    NSMutableArray* _dialogueForCurrentHouse;
    int _currentLine;
}

@end

@implementation InteriorModel

/*
 * Each house has its own dialogue file stored in Dialoguexy where x is the stage number and y is the house number.
 * There is 1 dialogue if the house is not the village elder (house 0) or two seperated by a newline if the house is
 * the village elder.  Lines of a dialogue are seperated by /
 *
-(void)initializeAllDialogue
{
    NSString *path;
    NSError *error;

    path = [[NSBundle mainBundle] pathForResource:@"Dialogue" ofType:@"txt"];

    NSString *dialogueString = [[NSString alloc] initWithContentsOfFile:path
                                                            encoding:NSUTF8StringEncoding error:&error];

    _allDialogues = [[NSMutableArray alloc] init];
    NSArray* separateStages =  [dialogueString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSInteger numStages = [separateStages count];
    for (int i = 0; i < numStages; i++) {

    NSArray* separateHouses = [[separateStages objectAtIndex:i] componentsSeparatedByString:@"/"];
    [_allDialogues addObject:[[NSMutableArray alloc] init]];

    NSInteger numHousesInStage = [separateHouses count];
        for (int j = 0; j < numHousesInStage; j++) {
            NSArray* separateLines = [[separateHouses objectAtIndex:j] componentsSeparatedByString:@","];
            [[_allDialogues objectAtIndex:i] addObject:separateLines];
        }
    }
}*/


// Start by putting the text into a string and then into an array of strings.
// The array will have two objects if there is win dialogue otherwise it just has one object.
// For each string in the array, we then split into seperate lines with a delimeter of /
-(void)initForStage:(int)stage andHouse:(int)house
{
    NSString *path;
    NSError *error;
    
    path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Dialogue%d%d", stage,house] ofType:@"txt"];
    
    NSString *dialogueString = [[NSString alloc] initWithContentsOfFile:path
                                                               encoding:NSUTF8StringEncoding error:&error];
    
    _allDialogues = [[NSMutableArray alloc] init];
    
    //Put the dialogue into array and split into normal and win dialogue if applicable
    NSArray* separateDialogues =  [dialogueString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for (NSString* dialogue in separateDialogues) {
        NSArray* separateLines = [dialogue componentsSeparatedByString:@"/"];
        [_allDialogues addObject:separateLines];
    }
    
    _dialogueForCurrentHouse = [_allDialogues objectAtIndex:0];
}

-(BOOL)dialogueFinished
{
    return _currentLine < [_dialogueForCurrentHouse count];
}


//Returns the number of remaining lines of dialogue
-(int)remainingLinesOfDialogue
{
    return (int)[_dialogueForCurrentHouse count] - _currentLine;
}

-(NSString*)getNextLineOfDialogue
{
  return _dialogueForCurrentHouse[_currentLine++];
}

-(void)setWinDialogueForStage:(int)stage numGamesWon:(int)numMinigamesCompletedForStage funExists:(BOOL)funExists
{
  // If this is the first minigame the player has finished for the stage and there is something after it,
  // display transitional dialogue.
  // Otherwise, display the win dialogue.
  if (numMinigamesCompletedForStage == 0) {
    if (funExists) {
      _dialogueForCurrentHouse = [_allDialogues objectAtIndex:transitionDialogueLocation];
    } else {
      _dialogueForCurrentHouse = [_allDialogues objectAtIndex:winDialogueLocation];
    }
  }
  // Display win dialogue after they finish the second game
  else if (numMinigamesCompletedForStage == 1) {
    _dialogueForCurrentHouse = [_allDialogues objectAtIndex:winDialogueLocation];
  }
  _currentLine = 0;
}
@end
