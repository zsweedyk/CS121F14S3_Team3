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

@interface MasterMindGameController ()
{
  int _currentLevel;
  BOOL _won;
  
  MasterMindGameModel* _gameModel;
  MasterMindGameView* _gameView;
}

@end

@implementation MasterMindGameController

//-(void)viewDidLoad
//{
//  [super viewDidLoad];
////  _gameModel = [[MasterMindGameModel alloc] init];
////  _gameView = [[MasterMindGameView alloc] initWithFrame:self.view.frame];
////  _won = NO;
////  _gameView.delegate = self;
////  [self.view addSubview:_gameView];
//}

-(id)init
{
  self = [super init];
  
  if (self) {
    _gameModel = [[MasterMindGameModel alloc] init];
    _gameView = [[MasterMindGameView alloc] initWithFrame:self.view.frame];
    _won = NO;
    _gameView.delegate = self;
    
    [self.view addSubview:_gameView];
  }
  
  return self;
}

-(int)checkSolution:(int*)solution
{
  return [_gameModel getMatchesFromAttempt:solution];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end