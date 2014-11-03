//
//  RoadGameModel.h
//  SilkRoad
//
//  Created by CS121 on 10/18/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoadGameModel : NSObject

- (void)initGridWithFile:(NSString*)filename;
- (BOOL)connectionIsValidForRow:(int)row1 Col:(int)col1 AndRow:(int)row2 Col:(int)col2;
- (int)addConnectionToNodeAtRow:(int)row Col:(int)col;
- (NSInteger)addConnectionBetweenRow:(int)row1 Col:(int)col1 AndRow:(int)row2 Col:(int)col2;
- (int)resetNodeAtRow:(int)row Col:(int)col;
- (int)getNumConnectionsToNodeAtRow:(int)row Col:(int)col;

@end