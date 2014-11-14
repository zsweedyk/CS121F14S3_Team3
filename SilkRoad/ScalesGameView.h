//
//  ScalesGameView.h
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/20/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScalesGameCoin.h"

@protocol ScalesGameDelegate
-(void)startNewGame;
-(void)exitScalesGame:(BOOL)won;
-(void)weighCoinsInScale;
-(void)moveCoin:(ScalesGameCoin*)coin toPlace:(int)placeToMove;
@end

@interface ScalesGameView : UIView

@property (assign, nonatomic) id <ScalesGameDelegate> delegate;

-(id)initWithFrame:(CGRect)frame;
-(void)setCurrencyForCiv:(int)civ;
-(void)newGameWithCoins:(NSMutableArray*)coins;
-(void)makeLeftScaleHeavier;
-(void)makeRightScaleHeavier;
-(void)makeScalesBalanced;
-(void)foundFakeCoin:(BOOL)found;

@end
