//
//  RoadGameModel.h
//  SilkRoad
//
//  Created by CS121 on 10/18/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoadGameModel : NSObject

-(void)initGrid;
-(int)getNodeValueAtRow:(int)row AndColumn:(int)col;

@end
