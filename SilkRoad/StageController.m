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
    [self initializeHousesForStage:_currentStage];
    
    NSLog(@"%d", [_houses count]);
    
    
    if (_currentStage == 0) {
        UIImage* india = [UIImage imageNamed:@"india2"];
        _stageView = [[StageView alloc] initWithFrame:stageFrame background:india];
    } else if (_currentStage == 1) {
        UIImage* china = [UIImage imageNamed:@"china2"];
        _stageView = [[StageView alloc] initWithFrame:stageFrame background:china];
    }
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
  NSLog(@"Stage complete!");
  [self.delegate progressToNextStage];
}

- (void)buttonPressed:(id)button
{
    // Initialize the InteriorController
    _interiorController = [[InteriorController alloc] init];
    // Configure InteriorController to report any changes to ViewController
    _interiorController.delegate = self;
    UIButton* ourButton = (UIButton*)button;
    NSInteger tag = ourButton.tag;
    
    [self displayInteriorControllerForInterior:tag];
    
}


@end
