//
//  ViewController.h
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/11/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StageController.h"
#import "MainMenuView.h"
#import "ProgressView.h"
#import "MapView.h"

@interface ViewController : UIViewController <ExitMenu, StageProtocol, MapProtocol, ReturnToPreviousFromScales,ReturnToPreviousFromMatching>

-(void)hideMap;

@end
