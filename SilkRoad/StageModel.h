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

-(void)loadNewStage: (int)stage;

-(NSMutableArray*)getHouseLabels;

-(void)visitedHouse: (int)house;

-(id)initForStage:(int)stage;

-(NSMutableArray*)getHouses;

@end
