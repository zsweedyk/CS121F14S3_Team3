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

@interface StageController () {
    int _currentStage;

    StageView* _stageView;
    StageModel* _stageModel;
    InteriorController* _interiorController;
    NSMutableArray* _houses;
    
}

@end

@implementation StageController

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setStageTo:(int)stage
{
    _currentStage = stage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


// Display the stage view
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [super viewDidAppear:NO];

    // Get stage frame dimensions
    CGRect frame = self.view.frame;
    CGFloat frameWidth = CGRectGetWidth(frame);
    CGFloat frameHeight = CGRectGetHeight(frame);

    // The stage view will take up the same space
    CGRect stageFrame = CGRectMake(0, 0, frameWidth, frameHeight);
    
    // Stage 0 is hardcoded for now
    [self initializeHousesForStage:0];
    
    NSLog(@"%d", [_houses count]);
    
    UIImage* india = [UIImage imageNamed:@"india2"];
    _stageView = [[StageView alloc] initWithFrame:stageFrame background:india];
    [_stageView loadNewStageWithHouses:_houses];
    
    _stageView.delegate = self;
    [self.view addSubview:_stageView];
}

- (void)initializeHousesForStage:(int)stage
{
    _houses =  [[NSMutableArray alloc] init];
    if(stage == 0) {
        House* newHouse = [House alloc];
        newHouse.visited = NO;
        newHouse.label = @"House 1";
        newHouse.xCord = 300;
        newHouse.yCord = 300;
        UIImage* house = [UIImage imageNamed:@"IndiaHouse_400"];
        newHouse.image = house;
        [_houses addObject:newHouse];
    }
}

- (void)displayInteriorControllerForInterior:(int)interior
{
    // Set the correct interior
    [_interiorController setStageTo:_currentStage andInteriorTo:interior];
    // Create the navigation controller and present it.
    UINavigationController *interiorNavController = [[UINavigationController alloc]
                                                  initWithRootViewController:_interiorController];
    [self presentViewController:interiorNavController animated:YES completion: nil];
    interiorNavController.navigationBar.hidden = YES;

}

- (void)returnToStage
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)notifyStageComplete
{
    // Let ViewController know the stage has been finished
    [self.delegate progressToNextStage];
}

- (void)miniGameCompleted
{
}
// When house is clicked, display interior view
- (void)enterHouse:(int)houseNumber
{
}

- (void)buttonPressed:(id)button
{
    // Initialize the InteriorController
    _interiorController = [[InteriorController alloc] init];
    // Configure InteriorController to report any changes to ViewController
    _interiorController.delegate = self;
    
    [self displayInteriorControllerForInterior:0];
}


@end
