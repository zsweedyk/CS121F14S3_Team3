//
//  RoadGameController.h
//  SilkRoad
//
//  Created by CS121 on 10/18/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoadGameView.h"
#import "MatchingGameController.h"

@interface RoadGameController : UIViewController <ReturnToPreviousFromMatching, RoadGameProtocol>

@property (assign, nonatomic) id <ReturnToPreviousFromMatching> delegate;

-(BOOL)hasBeenWon;

@end
