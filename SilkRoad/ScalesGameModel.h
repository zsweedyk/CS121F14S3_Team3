//
//  ScalesGameModel.h
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/20/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScalesGameCoin.h"

@interface ScalesGameModel : NSObject

-(void)newGame;

-(NSMutableArray*)getCoinsInLeftScale;
-(NSMutableArray*)getCoinsInRightScale;
-(NSMutableArray*)getCoinsInTray;

-(void)moveCoin:(ScalesGameCoin*)coin toPlace:(int)to;

-(int)checkScales;
-(BOOL)checkIfCoinFake:(ScalesGameCoin*)coin;
-(BOOL)canStillGuess;

@end
