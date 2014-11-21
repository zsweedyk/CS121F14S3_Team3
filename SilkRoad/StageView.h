//
//  StageView.h
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "House.h"

@protocol ButtonPressed
-(void)buttonPressed:(id)button;
@end

@interface StageView : UIView

@property (assign, nonatomic) id <ButtonPressed> delegate;

-(id)initWithFrame:(CGRect)frame background:(UIImage*)background;

-(void)loadNewStageWithHouses:(NSMutableArray*)houses;

@end
