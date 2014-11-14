//
//  InteriorModel.h
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InteriorModel : NSObject

-(void)initForStage:(int)stage andHouse:(int)house;
-(BOOL)dialogueFinished;
-(NSString*)getNextLineOfDialogue;
-(void)setWinDialogueForStage:(int)stage;

//The following methods exist just for testing and should not be considered part of the public interface
-(int)remainingLinesOfDialogue;

@end
