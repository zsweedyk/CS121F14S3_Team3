//
//  ViewController.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/11/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "ViewController.h"
#import "ProgressView.h"
#import "RoadGameController.h"
#import "ScalesGameController.h"
#import "Constants.h"
#import "CharacterDescriptionView.h"
#import "MasterMindGameController.h"
#import "DataClass.h"

@interface ViewController () {
  int _currentStage;
  
  MainMenuView* _menuView;
  CreditsView* _creditsView;
  MapView* _mapView;
  CharacterDescriptionView* _characterView;
  StageController* _stageController;
  ScalesGameController* _scalesGameController;
  RoadGameController* _roadGameController;
  MasterMindGameController* _masterMindGameController;
  
  AVAudioPlayer* _chinaBGMPlayer;
  AVAudioPlayer* _indiaBGMPlayer;
  BOOL _playingChinaBGM;
  BOOL _playingIndiaBGM;
}

@end

@implementation ViewController

-(void)viewDidLoad
{
  [super viewDidLoad];
  
  _currentStage = 0;
  
  // Initialize the controllers
  _menuView = [[MainMenuView alloc] initWithFrame:self.view.frame];
  _menuView.delegate = self;
  _mapView = [[MapView alloc] initWithFrame:self.view.frame];
  _mapView.delegate = self;
  _characterView = [[CharacterDescriptionView alloc] initWithFrame:self.view.frame];
  [_characterView setToCivilization:INDIA];
  _characterView.delegate = self;
  _creditsView = [[CreditsView alloc] initWithFrame:self.view.frame];
  _creditsView.delegate = self;
  _scalesGameController = [[ScalesGameController alloc] init];
  _roadGameController = [[RoadGameController alloc] init];
  _stageController = [[StageController alloc] init];
  [_stageController setStageTo:_currentStage];
  _masterMindGameController = [[MasterMindGameController alloc] init];
  
  // Initialize the music
  NSString *cpath  = [[NSBundle mainBundle] pathForResource:@"ChinaMusic" ofType:@"mp3"];
  NSString *ipath  = [[NSBundle mainBundle] pathForResource:@"IndiaMusic" ofType:@"mp3"];
  NSURL *cpathURL = [NSURL fileURLWithPath:cpath];
  NSURL *ipathURL = [NSURL fileURLWithPath:ipath];
  NSError *cerror = nil;
  NSError *ierror = nil;
  
  _chinaBGMPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:cpathURL error:&cerror];
  _indiaBGMPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:ipathURL error:&ierror];
  [_chinaBGMPlayer setNumberOfLoops:-1];
  [_indiaBGMPlayer setNumberOfLoops:-1];
  
  _playingChinaBGM = NO;
  _playingIndiaBGM = NO;

  // Show Main Menu
  [self.view addSubview:_menuView];
}

// When start game is clicked, remove the main menu screen and show character description
-(void)exitMenu
{
  [_menuView removeFromSuperview];
  [self showCharacterDescription];
}

-(void)playBGMForStage:(int)stage
{
  // If the wrong music is playing, change it
  // If no music is playing, play the correct one
  // If the correct music is already playing, do nothing
  if (stage >= NUM_CITIES / 2) {
    if (_playingIndiaBGM) {
      [_indiaBGMPlayer stop];
      [_chinaBGMPlayer play];
      
      _playingIndiaBGM = NO;
      _playingChinaBGM = YES;
    }
    else if (!(_playingChinaBGM)) {
      [_chinaBGMPlayer play];
      _playingChinaBGM = YES;
    }
  }
  else {
    if (_playingChinaBGM) {
      [_chinaBGMPlayer stop];
      [_indiaBGMPlayer play];
  
      _playingChinaBGM = NO;
      _playingIndiaBGM = YES;
    }
    else if (!(_playingIndiaBGM)) {
      [_indiaBGMPlayer play];
      _playingIndiaBGM = YES;
    }
  }
}

-(void)switchSound
{
  DataClass *gameData = [DataClass getInstance];
  
  // Switch the sound settings
  [gameData setSoundOn:(![gameData soundOn])];
  
  // Update the game to match the new settings
  if ([gameData soundOn]) {
    if (_playingChinaBGM) {
      [_chinaBGMPlayer play];
    }
    else if (_playingIndiaBGM) {
      [_indiaBGMPlayer play];
    }
  }
  else {
    if (_playingChinaBGM) {
      [_chinaBGMPlayer stop];
    }
    else if (_playingIndiaBGM) {
      [_indiaBGMPlayer stop];
    }
  }
}

-(void)showCharacterDescription
{
  [self playBGMForStage:_currentStage];
  
  [self.view addSubview:_characterView];
}

// Remove character description and display the stage
-(void)hideCharacterDescription
{
  [_characterView removeFromSuperview];
  [self displayStageController];
}

-(void)showCredits
{
  NSLog(@"Clicked to show credits");
  [_menuView removeFromSuperview];
  [self.view addSubview:_creditsView];
}

-(void)hideCredits
{
  [_creditsView removeFromSuperview];
  [self.view addSubview:_menuView];
}

-(void)showMap
{
  [self dismissViewControllerAnimated:NO completion:nil];
  [self.view addSubview:_mapView];
}

-(void)hideMap
{
  [_mapView removeFromSuperview];
  [self displayStageController];
}

-(void)jumpToStage:(int)stage
{
  _stageController = [[StageController alloc] init];
  [_stageController setStageTo:stage];
  [self playBGMForStage:stage];
  [self hideMap];
}

-(void)returnToPrevious
{
  [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)goToScalesGame
{
  _scalesGameController.delegate = self;
  [_scalesGameController setCurrencyTo:CHINA];
  [self presentViewController:_scalesGameController animated:YES completion: nil];
}

-(void)goToRoadGame
{
  _roadGameController.delegate = self;
  [_roadGameController setMapBackgroundForCivilization:CHINA];
  [self presentViewController:_roadGameController animated:YES completion: nil];
}

-(void)goToMasterMindGame
{
  //_masterMindGameController.delegate = self;
  [self presentViewController:_masterMindGameController animated:YES completion: nil];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)displayStageController
{
  // Configure StageController to report any changes to ViewController
  _stageController.delegate = self;
  [self presentViewController:_stageController animated:YES completion: nil];
}


// Initialize new stageController, set this to be the current stage
-(void)progressToNextStage
{
  [self dismissViewControllerAnimated:NO completion:nil];
  _stageController = [[StageController alloc] init];
  [_stageController setStageTo:++_currentStage];
  [_mapView moveToNextStage];
  
  // If we are at the midpoint, display a character description of the new character
  //    and switch the music
  if (_currentStage == NUM_CITIES / 2) {
    [_characterView setToCivilization:CHINA];
    [self showCharacterDescription];
  } else {
    [self displayStageController];
  }
  
  [self playBGMForStage:_currentStage];
}

@end
