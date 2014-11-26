//
//  MasterMindGameView.h
//  SilkRoad
//
//  Created by Katharine Finlay on 11/23/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MasterMindGameView : UIView

-(id)initWithFrame:(CGRect)frame;
-(void)displayNewTurn:(int*) turn;
-(void)displayNewTurnFeedback:(int) matches;
-(void)displayPassword:(int*) password;
-(void)clearBoard;

@end