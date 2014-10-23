//
//  MainMenuView.h
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/23/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowStage
-(void)showStage;
@end

@interface MainMenuView : UIView

@property (assign, nonatomic) id <ShowStage> delegate;

@end
