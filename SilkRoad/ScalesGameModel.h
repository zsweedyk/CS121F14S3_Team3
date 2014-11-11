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

-(int)newGame;

-(NSMutableArray*)getCoinsInLeftScale;
-(NSMutableArray*)getCoinsInRightScale;
-(NSMutableArray*)getCoinsInTray;

-(void)moveToLeftScale:(ScalesGameCoin*)coin;
-(void)removeFromLeftScale:(ScalesGameCoin*)coin;
-(void)moveToRightScale:(ScalesGameCoin*)coin;
-(void)removeFromRightScale:(ScalesGameCoin*)coin;
-(void)moveFromLeftScaleToRightScale:(ScalesGameCoin*)coin;
-(void)moveFromRightScaleToLeftScale:(ScalesGameCoin*)coin;

-(int)checkScales;
-(BOOL)checkIfCoinFake:(ScalesGameCoin*)coin;

@end
