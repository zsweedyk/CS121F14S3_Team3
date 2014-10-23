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

@protocol ProgressToNextStage
-(void)progressToNextStage;
@end


@interface StageController : UIViewController <ReturnToStage, ButtonPressed, NotifyStageComplete>

@property (assign, nonatomic) id <ProgressToNextStage> delegate;

- (void)setStageTo:(int)currentStage;

- (void)buttonPressed:(id)button;

@end
