//
//  MasterMindGameModel.h
//  SilkRoad
//
//  Created by Katharine Finlay on 11/22/13.
//  Copyright (c) 2013 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MasterMindGameModel : NSObject

-(id)init;
-(void)makeNewSolution;
-(int)getMatchesFromAttempt:(int*)attempt;
-(BOOL)hasBeenWon;
-(void)resetGame;

//for testing
-(void)setPassword:(int*)mockPassword;

@end