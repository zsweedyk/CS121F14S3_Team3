//
//  InteriorController.h
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InteriorView.h"
#import "MatchingGameController.h"
#import "ScalesGameController.h"

@protocol ReturnToStage
-(void)returnToStage;
@end

@protocol NotifyStageComplete
-(void)notifyStageComplete;
@end

@interface InteriorController : UIViewController <LeaveInterior, ReturnToPreviousFromMatching, ReturnToPreviousFromScales, EnterMinigame, ProgressDialogue>

@property (assign, nonatomic) id <ReturnToStage, NotifyStageComplete> delegate;

-(void)setStageTo:(int)stage andInteriorTo:(int)interior hasVisitedHouses:(BOOL)canEnterMinigame;

-(void)initInteriorView;

@end