//
//  StageController.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "StageController.h"
#import "StageView.h"
#import "StageModel.h"
#import "InteriorController.h"

@interface StageController () {
    StageView* _stageView;
    StageModel* _stageModel;
}

@end

@implementation StageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Let game controller know the stage has been finished
- (void)notifyStageComplete
{
}

// When house is clicked, display interior view
-(void)enterHouse:(int)houseNumber {
}
@end
