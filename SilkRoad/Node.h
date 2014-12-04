//
//  Node.h
//  SilkRoad
//
//  Created by CS121 on 12/3/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Node : NSObject

@property int numConnections;
@property int origNumConnections;
@property NSMutableDictionary* connections;

-(Node*)initWithNumConnections:(int)numConnections;

@end
