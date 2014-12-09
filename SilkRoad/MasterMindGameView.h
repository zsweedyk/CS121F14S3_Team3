//
//  MasterMindGameView.h
//  SilkRoad
//
//  Created by Katharine Finlay on 11/23/13.
//  Copyright (c) 2013 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MasterMindCheckSolution
-(int)checkSolution:(int*)solution;
-(void)newGame;
-(void)returnToPrevious;
@end


@interface MasterMindGameView : UIView

@property (assign, nonatomic) id <MasterMindCheckSolution> delegate;


-(id)initWithFrame:(CGRect)frame;
-(void)displayNewTurn:(int*) turn;
-(void)displayNewTurnFeedback:(int) matches;
-(void)clearBoard;

@end