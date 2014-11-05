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
- (int)getNumAvailableConnectionsToNodeAtRow:(int)row Col:(int)col;
- (BOOL)connectionIsValidForRow:(int)row1 Col:(int)col1 AndRow:(int)row2 Col:(int)col2;
- (void)addConnectionBetweenRow:(int)row1 Col:(int)col1 AndRow:(int)row2 Col:(int)col2;
- (void)resetConnectionBetweenRow:(int)row1 Col:(int)col1 AndRow:(int)row2 Col:(int)col2;
- (BOOL)hasBeenWon;
- (NSInteger)numConnectionsAfterUpdateForRow:(int)row1 Col:(int)col1 AndRow:(int)row2 Col:(int)col2;

// Uncomment to test
- (int)addConnectionToNodeAtRow:(int)row Col:(int)col;
- (int)resetNodeAtRow:(int)row Col:(int)col ByValue:(NSInteger)value;
- (NSInteger)getNumConnectionsBetweenRow:(int)row1 Col:(int)col1 AndRow:(int)row2 Col:(int)col2;
- (void)setNumConnectionsBetweenRow:(int)row1 Col:(int)col1 AndRow:(int)row2 Col:(int)col2 ToValue:(NSInteger)value;
@end