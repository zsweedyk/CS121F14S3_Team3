//
//  MainMenuView.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/23/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "MainMenuView.h"
#import "DataClass.h"

#import <AVFoundation/AVFoundation.h>
@interface MainMenuView()
{
  AVAudioPlayer* _introMusic;
}
@end

@implementation MainMenuView

-(id)initWithFrame:(CGRect)frame
{  
  self = [super initWithFrame:frame];
  
  if (self) {
    // Set the background image
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"silkroadmenu"]]];
    
    // Set up the button
    CGRect buttonFrame = CGRectMake(0.38*self.frame.size.width, 0.61*self.frame.size.height, 0.256*self.frame.size.width, 0.116*self.frame.size.height);
    UIButton *startButton = [[UIButton alloc] initWithFrame:buttonFrame];
    [startButton setBackgroundImage:[UIImage imageNamed:@"startgamebutton"] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:startButton];
    
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"drums" ofType:@"wav"];
    NSURL *pathURL = [NSURL fileURLWithPath:path];
    NSError *correct_error = nil;
    _introMusic = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:pathURL
                   error:&correct_error];
    [_introMusic setNumberOfLoops:-1];
    
    DataClass *gameData = [DataClass getInstance];
    if ([gameData soundOn]) {
      [_introMusic play];
    }
  }
  
  return self;
}

-(void)startGame {
  if ([_introMusic isPlaying]) {
    [_introMusic stop];
  }
  [self.delegate showStage];
}

@end
