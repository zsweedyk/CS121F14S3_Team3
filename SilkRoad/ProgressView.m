//
//  ProgressView.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "ProgressView.h"

@interface ProgressView()
{
    int _currentStage;
    UIImage* _progressBar;
    NSMutableArray* _stageButtons;
}
@end

@implementation ProgressView

-(void)moveToNextStage
{
    UIButton* oldStageButton = [_stageButtons objectAtIndex:_currentStage];
    [oldStageButton setBackgroundColor:[UIColor blackColor]];
    
    _currentStage++;
    
    UIButton* currentStageButton = [_stageButtons objectAtIndex:_currentStage];
    [currentStageButton setBackgroundColor:[UIColor greenColor]];
}

@end
