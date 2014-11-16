//
//  RoadGameView.h
//  SilkRoad
//
//  Created by CS121 on 10/18/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CheckConnectionValid
-(BOOL)checkConnectionValidBetweenRow:(int)row1 Col:(int)col1 AndRow:(int)row2 Col:(int)col2;
@end

@protocol CreateConnection
-(NSInteger)createConnectionBetweenRow:(int)row1 Col:(int)col1 AndRow:(int)row2 Col:(int)col2;
@end

@protocol ExitMinigame
-(void)returnToInterior;
@end

@protocol NewGame
-(void)newGame;
@end

@protocol ResetGame
-(void)resetGame;
@end

@interface RoadGameView : UIView

@property (assign, nonatomic) id <CheckConnectionValid, CreateConnection, ExitMinigame, NewGame, ResetGame> delegate;

-(void)setNodeValueAtRow:(int)row AndColumn:(int)col toValue:(int) value;
-(void)setNodeBackgroundAtRow:(int)row AndColumn:(int)col;
-(void)resetLines;

@end
