//
//  MasterMindGameController.m
//  SilkRoad
//
//  Created by Katharine Finlay on 11/25/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MasterMindGameController.h"
#import "MasterMindGameModel.h"
#import "MasterMindGameView.h"

@interface MasterMindGameController ()
{
  int _currentLevel;
  BOOL _won;
  
  MasterMindGameModel* _gameModel;
  MasterMindGameView* _gameView;
}

@end

@implementation MasterMindGameController

-(void)viewDidLoad
{
  [super viewDidLoad];
}

-(id)init
{
  self = [super init];
  
  if (self) {
    // Initialize gameModel
    _gameModel = [[MasterMindGameModel alloc] init];
    _gameView = [[MasterMindGameView alloc] initWithFrame:self.view.frame];
    _won = NO;
  }
  
  return self;
}



@end