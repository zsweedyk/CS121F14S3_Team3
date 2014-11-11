//
//  ScalesGameView.h
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/20/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScalesGameCoin.h"

@protocol ExitScalesGame
-(void) exitScalesGame;
@end

@protocol CheckCoin
-(void) checkIfCoinFake:(ScalesGameCoin*)coin;
@end

@interface ScalesGameView : UIView

@property (assign, nonatomic) id <ExitScalesGame, CheckCoin> delegate;

-(id)initWithFrame:(CGRect)frame andNumCoins:(int)numCoins;
-(void)foundFakeCoin:(BOOL)found;

@end
