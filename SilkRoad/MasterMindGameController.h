//
//  MasterMindGameModel.h
//  SilkRoad
//
//  Created by Katharine Finlay on 11/22/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MasterMindGameView.h"

@protocol ReturnToPreviousFromMasterMind
-(void)returnToPrevious;
@end

@interface MasterMindGameController : UIViewController <MasterMindCheckSolution>

@property (assign, nonatomic) id <ReturnToPreviousFromMasterMind> delegate;

-(BOOL)hasBeenWon;

@end