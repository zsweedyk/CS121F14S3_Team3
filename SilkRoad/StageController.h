//
//  StageController.h
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InteriorController.h"
#import "House.h"
#import "StageView.h"
#import "ProgressView.h"

@protocol StageProtocol
-(void)progressToNextStage;
-(void)showMap;
@end

@interface StageController : UIViewController <ReturnToStage, ButtonPressed, NotifyStageComplete, ToggleMap>

@property (assign, nonatomic) id <StageProtocol> delegate;

-(void)setStageTo:(int)currentStage;

-(void)buttonPressed:(id)button;

@end
