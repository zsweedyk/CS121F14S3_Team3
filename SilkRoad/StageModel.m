//
//  StageModel.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "StageModel.h"

@interface StageModel()
{
  NSMutableArray* _houses;
}

@end

@implementation StageModel

//A set of constants that specify the indices at which certain elements of a house are stored
const int nameIndex = 0;
const int xIndex = 1;
const int yIndex = 2;
const int imageIndex = 3;
const int tagIndex = 4;

// Parse the file for the appropriate stage
-(id)initForStage:(int)stage
{
  self = [super init];
  _houses =  [[NSMutableArray alloc] init];
      
  NSString *path;
  NSError *error;
  
  path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"stage%d", stage] ofType:@"txt"];
  
  NSString *houseString = [[NSString alloc] initWithContentsOfFile:path
                                                             encoding:NSUTF8StringEncoding error:&error];
  
  NSArray* separateHouses =  [houseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
  for (NSString* house in separateHouses) {
    [self addHouse:house];
  }
  return self;
}

//Adds a house described in the given string to the back of the houses array
-(void)addHouse:(NSString*)nextHouse
{
  NSArray* componentsOfHouse = [nextHouse componentsSeparatedByString:@", "];
  House* newHouse =  [House alloc];
  newHouse.visited = NO;
  newHouse.label = [componentsOfHouse objectAtIndex:nameIndex];
  CGFloat x = [[componentsOfHouse objectAtIndex:xIndex] floatValue]/1.5;
  CGFloat y = [[componentsOfHouse objectAtIndex:yIndex] floatValue]/1.5;
  newHouse.xCord = x;
  newHouse.yCord = y;
  UIImage* house = [UIImage imageNamed:[componentsOfHouse objectAtIndex:imageIndex]];
  newHouse.image = house;
  newHouse.tag = [[componentsOfHouse objectAtIndex:tagIndex] integerValue];
  [_houses addObject:newHouse];
}

-(NSMutableArray*)getHouses
{
  return _houses;
}

//Tells the model that house n is being visited
-(void)visitHouse:(int)houseNum
{
  ((House*)[_houses objectAtIndex:houseNum]).visited = YES;
}

// Returns true if every house has been visted and otherwise returns false
-(BOOL)visitedAllHouses
{
  for (House* house in _houses) {
    if (house.visited == NO) {
        return NO;
    }
  }
  
  return YES;
}

@end
