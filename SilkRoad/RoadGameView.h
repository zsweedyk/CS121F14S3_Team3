//
//  RoadGameView.h
//  SilkRoad
//
//  Created by CS121 on 10/18/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RoadGameProtocol
-(BOOL)checkConnectionValidBetweenRow:(int)row1 Col:(int)col1 AndRow:(int)row2 Col:(int)col2;
-(NSInteger)createConnectionBetweenRow:(int)row1 Col:(int)col1 AndRow:(int)row2 Col:(int)col2;
-(void)returnToPrevious;
-(void)newGame;
-(void)resetGame;
@end

@interface RoadGameView : UIView

@property (assign, nonatomic) id <RoadGameProtocol> delegate;

-(void)setNodeValueAtRow:(int)row AndColumn:(int)col toValue:(int) value;
-(void)setNodeBackgroundAtRow:(int)row AndColumn:(int)col;
-(void)resetLines;

@end
