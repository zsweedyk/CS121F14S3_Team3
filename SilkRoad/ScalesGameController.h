//
//  ScalesGameController.h
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/20/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScalesGameView.h"

@protocol ReturnToPreviousFromScales
-(void)returnToPrevious;
@end

@interface ScalesGameController : UIViewController <ScalesGameProtocol>

@property (assign, nonatomic) id <ReturnToPreviousFromScales> delegate;

-(void)setCurrencyTo:(int)civ;
-(BOOL)hasBeenWon;

@end