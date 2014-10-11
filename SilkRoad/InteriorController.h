//
//  InteriorController.h
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReturnToStage
-(void)returnToStage;
@end

@interface InteriorController : UIViewController

@property (assign, nonatomic) id <ReturnToStage> delegate;

@end
