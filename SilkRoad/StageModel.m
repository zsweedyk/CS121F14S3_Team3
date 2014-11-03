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


// Parse the file for the appropriate stage
- (id)initForStage:(int)stage
{
    self = [super init];
    _houses =  [[NSMutableArray alloc] init];
    /*
    if(stage == 0) {
        
        House* newHouse = [House alloc];
        newHouse.visited = NO;
        newHouse.label = @"Village Elder";
        newHouse.xCord = 200;
        newHouse.yCord = 350;
        UIImage* house = [UIImage imageNamed:@"IndiaHouse_400"];
        newHouse.image = house;
        newHouse.tag = 0;
        [_houses addObject:newHouse];
        UIImage *scaledHouse =
        [UIImage imageWithCGImage:[house CGImage]
                            scale:(house.scale * 1.5)
                      orientation:(house.imageOrientation)];
        
        House* newHouse1 = [House alloc];
        newHouse1.visited = NO;
        newHouse1.label = @"Cobbler";
        newHouse1.xCord = 425;
        newHouse1.yCord = 675;
        newHouse1.image = house;
        newHouse1.tag = 1;
        [_houses addObject:newHouse1];
        
        House* newHouse2 = [House alloc];
        newHouse2.visited = NO;
        newHouse2.label = @"Butcher";
        newHouse2.xCord = 350;
        newHouse2.yCord = 600;
        newHouse2.image = scaledHouse;
        newHouse2.tag = 2;
        [_houses addObject:newHouse2];
        
        House* newHouse3 = [House alloc];
        newHouse3.visited = NO;
        newHouse3.label = @"Farmer";
        newHouse3.xCord = 600;
        newHouse3.yCord = 700;
        newHouse3.image = house;
        newHouse3.tag = 3;
        [_houses addObject:newHouse3];
    }
    
    if(stage == 1) {
        House* newHouse = [House alloc];
        newHouse.visited = NO;
        newHouse.label = @"Village Elder";
        newHouse.xCord = 300;
        newHouse.yCord = 700;
        UIImage* house = [UIImage imageNamed:@"ChinaHouse400_250"];
        newHouse.image = house;
        newHouse.tag = 0;
        [_houses addObject:newHouse];
        
        UIImage* bigHouse = [UIImage imageNamed:@"ChinaHouse_600_375"];
        
        House* newHouse1 = [House alloc];
        newHouse1.visited = NO;
        newHouse1.label = @"Cobbler";
        newHouse1.xCord = 500;
        newHouse1.yCord = 550;
        newHouse1.image = house;
        newHouse1.tag = 1;
        [_houses addObject:newHouse1];
        
        House* newHouse2 = [House alloc];
        newHouse2.visited = NO;
        newHouse2.label = @"Butcher";
        newHouse2.xCord = 150;
        newHouse2.yCord = 800;
        newHouse2.image = bigHouse;
        newHouse2.tag = 2;
        [_houses addObject:newHouse2];
        
        House* newHouse3 = [House alloc];
        newHouse3.visited = NO;
        newHouse3.label = @"Farmer";
        newHouse3.xCord = 450;
        newHouse3.yCord = 750;
        newHouse3.image = bigHouse;
        newHouse3.tag = 3;
        [_houses addObject:newHouse3];
    }
     */
    
    NSString *path;
    NSError *error;
    
    path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"stage%d", stage] ofType:@"txt"];
    
    NSString *houseString = [[NSString alloc] initWithContentsOfFile:path
                                                               encoding:NSUTF8StringEncoding error:&error];
    
    NSArray* separateHouses =  [houseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSUInteger numHouses = [separateHouses count];
    for (NSString* house in separateHouses) {
        [self addHouse:house];
    }
    return self;
}

//A set of constants that specify the indices at which certain elements of a house are stored
const int nameIndex = 0;
const int xIndex = 1;
const int yIndex = 2;
const int imageIndex = 3;
const int tagIndex = 4;

//Adds a house described in the given string to the back of the houses array
-(void)addHouse:(NSString*)nextHouse
{
    NSLog(nextHouse);
    NSArray* componentsOfHouse = [nextHouse componentsSeparatedByString:@", "];
    House* newHouse =  [House alloc];
    newHouse.visited = NO;
    newHouse.label = [componentsOfHouse objectAtIndex:nameIndex];
    CGFloat x = [[componentsOfHouse objectAtIndex:xIndex] floatValue]/2;
    CGFloat y = [[componentsOfHouse objectAtIndex:yIndex] floatValue]/2;
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

-(BOOL)canVisitHouse: (int)house
{
  return YES;
}

@end
