//
//  StageModel.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "StageModel.h"

@interface House : NSObject
    @property BOOL visited;
    @property NSString* label;
@end

@interface StageModel()
{
  NSMutableArray* _houses;
}

@end

@implementation StageModel

-(void)initWithStuffYetToBeDetermined
{
    _houses = [[NSMutableArray alloc] initWithCapacity:4];
}

-(NSMutableArray*)getHouseLabels
{
    NSMutableArray* labels = [[NSMutableArray alloc] initWithCapacity:[_houses count]];
    for (int i = 0; i < [_houses count]; i++) {
        House* currHouse = [_houses objectAtIndex:i];
        [labels insertObject:currHouse.label atIndex:i];
    }
    
    return labels;
}

-(void)visitedHouse: (int)house
{
  BOOL currHouseVisited = ((House*)[_houses objectAtIndex:house]).visited;
  currHouseVisited = YES;
}

-(void)loadNewStage: (int)stage
{
  
}

-(BOOL)canVisitHouse: (int)house
{
  return YES;
}

@end
