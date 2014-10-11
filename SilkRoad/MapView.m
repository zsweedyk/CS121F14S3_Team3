//
//  MapView.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "MapView.h"

@interface MapView() {
    int _currentStage;
    UIImage* _map;
    NSMutableArray* _stageButtons;
}
@end

@implementation MapView

-(void)moveToNextStage
{
    UIButton* oldStageButton = [_stageButtons objectAtIndex:_currentStage];
    [oldStageButton setBackgroundColor:[UIColor blackColor]];
    
    _currentStage++;
    
    UIButton* currentStageButton = [_stageButtons objectAtIndex:_currentStage];
    [currentStageButton setBackgroundColor:[UIColor greenColor]];
}

@end
