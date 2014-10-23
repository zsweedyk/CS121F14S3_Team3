//
//  ScalesGameController.h
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/20/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScalesGameView.h"

@protocol ReturnToInterior
-(void)returnToInterior;
@end

@interface ScalesGameController : UIViewController <ExitMinigame, CheckCoin>

@property (assign, nonatomic) id <ReturnToInterior> delegate;

@end