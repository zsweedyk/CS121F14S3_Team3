//
//  StageController.h
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InteriorController.h"

@protocol ProgressToNextStage
-(void)progressToNextStage;
@end

@interface StageController : UIViewController <ReturnToStage>

@property (assign, nonatomic) id <ProgressToNextStage> delegate;

@end
