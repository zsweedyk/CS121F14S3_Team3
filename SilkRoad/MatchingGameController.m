//
//  MatchingGameController.m
//  SilkRoad
//
//  Created by CS121 on 10/11/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "MatchingGameController.h"
#import "MatchingGameModel.h"
#import "MatchingGameView.h"

@interface MatchingGameController ()
{
  MatchingGameModel* _gameModel;
  MatchingGameView* _gameView;
}

@end

@implementation MatchingGameController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _gameModel = [[MatchingGameModel alloc] init];
    [_gameModel initializePhrasesAndMatches];
    
      _gameView = [[MatchingGameView alloc] initWithFrame:self.view.frame leftSidePhrases:[_gameModel getLeftSidePhrases] andRightSidePhrases:[_gameModel getRightSidePhrases]];
    }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
