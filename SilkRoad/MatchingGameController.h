//
//  MatchingGameController.h
//  SilkRoad
//
//  Created by CS121 on 10/11/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchingGameView.h"

@protocol ReturnToInterior
-(void)returnToInterior;
@end

@interface MatchingGameController : UIViewController <ExitMinigame, CheckForMatch>

@property (assign, nonatomic) id <ReturnToInterior> delegate;

@end