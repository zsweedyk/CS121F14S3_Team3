//
//  MapView.h
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MapProtocol
-(void)hideMap;
-(void)jumpToStage:(int)stage;
-(void)goToScalesGame;
-(void)goToRoadGame;
-(void)goToMasterMindGame;
@end

@interface MapView : UIView

@property (assign, nonatomic) id <MapProtocol> delegate;

-(id)initWithFrame:(CGRect)frame;

-(void)moveToNextStage;

@end
