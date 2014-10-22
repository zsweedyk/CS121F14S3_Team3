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

@interface RoadGameView : UIView

@property (assign, nonatomic) id <CheckConnectionValid> delegate;

-(void)setNodeValueAtRow:(int)row AndColumn:(int)col toValue:(int) value;

@end
