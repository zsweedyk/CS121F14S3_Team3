//
//  StageView.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "StageView.h"

@interface StageView()
{
    NSMutableArray* _houseButtons;
}

@end


@implementation StageView

-(void)initWithBackground:(UIImage*)background
{
}

-(void)createHouseWithBackground:(UIImage*)background atXCoord:(int)x andYCoord:(int)y withLabel:(NSString*)label
{
}

-(void)loadNewStage: (int)stage
         withHouses: (NSMutableArray*) houses
{
    //houses is a mutable array containing the labels for the houses
    //at the current stage. The labels will be read in and used to set
    //the button titles.
    NSString* currHouseTitle;
    UIButton* currHouseButton;
    for (int i = 0; i < [houses count]; i++) {
        currHouseTitle = [houses objectAtIndex:i];
        currHouseButton = [_houseButtons objectAtIndex:i];
        [currHouseButton setTitle:currHouseTitle forState:UIControlStateNormal];
    }
}

@end
