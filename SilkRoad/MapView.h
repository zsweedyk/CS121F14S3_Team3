//
//  MapView.h
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HideMap
-(void)hideMap;
@end

@protocol JumpToStage
-(void)jumpToStage:(int)stage;
@end

@interface MapView : UIView

@property (assign, nonatomic) id <HideMap, JumpToStage> delegate;

-(id)initWithFrame:(CGRect)frame;

-(void)moveToNextStage;

@end
