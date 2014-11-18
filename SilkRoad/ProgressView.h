//
//  ProgressView.h
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ToggleMap
-(void)showMap;
@end;

@interface ProgressView : UIView

@property (assign, nonatomic) id <ToggleMap> delegate;

-(id)initWithFrame:(CGRect)frame andCurrentStage:(int)stage;

@end
