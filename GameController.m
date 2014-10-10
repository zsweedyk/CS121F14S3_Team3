//
//  GameController.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "GameController.h"
#import "MapView.h"
#import "ProgressView.h"
#import "StageController.h"

@interface GameController () {
    MapView* _mapView;
    ProgressView* _progressView;
    StageController* _currentStage;
}

@end

@implementation GameController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Initialize new stageController, set this to be the current stage
-(void)progressToNextStage {
}

@end
