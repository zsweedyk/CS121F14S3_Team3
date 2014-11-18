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
-(void)returnToPrevious;
@end

@interface RoadGameView : UIView

@property (assign, nonatomic) id <CheckConnectionValid, CreateConnection, ExitMinigame> delegate;

-(void)setNodeValueAtRow:(int)row AndColumn:(int)col toValue:(int) value;
-(void)setNodeBackgroundAtRow:(int)row AndColumn:(int)col;

@end
