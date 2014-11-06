//
//  StageModel.h
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "House.h"

@interface StageModel : NSObject

-(NSMutableArray*)getHouseLabels;

-(id)initForStage:(int)stage;

-(NSMutableArray*)getHouses;

-(void)visitHouse:(int)houseNum;

-(BOOL)visitedAllHouses;

//The following methods are made public strictly for testing purposes
-(void)addHouse:(NSString*)nextHouse;

@end
