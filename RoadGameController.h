//
//  RoadGameController.h
//  SilkRoad
//
//  Created by CS121 on 10/18/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoadGameView.h"

@protocol ReturnToInterior
-(void)returnToInterior;
@end

@interface RoadGameController : UIViewController <ReturnToInterior, CheckConnectionValid>

@property (assign, nonatomic) id <ReturnToInterior> delegate;

@end
