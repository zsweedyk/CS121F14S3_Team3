//
//  MatchingGameView.m
//  SilkRoad
//
//  Created by CS121 on 10/11/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "MatchingGameView.h"

@interface MatchingGameView()
{
  NSMutableArray *_leftSidePhraseButtons;
  NSMutableArray *_rightSidePhraseButtons;
  NSMutableArray *_leftMatched;
  NSMutableArray *_rightMatched;
  int _leftSelected;
  int _rightSelected;
  int _numPhrases;
  int _countMatched;
  AVAudioPlayer* _correctAudio;
  AVAudioPlayer* _incorrectAudio;
}
@end

@implementation MatchingGameView

-(id)initWithFrame:(CGRect)frame leftSidePhrases:(NSMutableArray*)leftSide andRightSidePhrases:(NSMutableArray*)rightSide
{
  self = [super initWithFrame:frame];
  
  if (self) {
    // Game begins as not won
    
    // Set the minigame background
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"stonebg"]]];
    
    // Find the number of terms that are going to be matched
    // Assume that the number of phrases for each side is equal
    // Also assume that we won't have over 2^31-1 items to match, so casting
    //    count to an int should be okay
    _numPhrases = (int)[leftSide count];
    _countMatched = 0;
    
    // Initialize the arrays
    _leftSidePhraseButtons = [[NSMutableArray alloc] initWithCapacity:_numPhrases];
    _rightSidePhraseButtons = [[NSMutableArray alloc] initWithCapacity:_numPhrases];
    _leftMatched = [[NSMutableArray alloc] initWithCapacity:_numPhrases];
    _rightMatched = [[NSMutableArray alloc] initWithCapacity:_numPhrases];

    // Get the dimensions of the frame
    CGFloat frameWidth = CGRectGetWidth(frame);
    CGFloat frameHeight = CGRectGetHeight(frame);
    
    // The game frame will be 90% of the screen, the bottom 10% is for the game
    //    bottom bar
    CGFloat gameFrameWidth = frameWidth;
    CGFloat gameFrameHeight = frameHeight * 0.90;
    
    // Set offset values for the game phrases
    // Have 10% padding on all sides
    CGFloat horizontalPadding = gameFrameWidth * 0.10;
    CGFloat verticalPadding = gameFrameHeight * 0.10;
    // Make the phrases 35% of the frame width
    // 80% of the screen height is left for the phrases; distribute it evenly
    //    according to number of phrases (also accounts for vertical space
    //    between phrases that are 10% of the phrase height)
    CGFloat phraseWidth = gameFrameWidth * 0.35;
    CGFloat phraseHeight = (gameFrameHeight * 0.80) / (_numPhrases * 1.10);
    // Set the x-offset accordingly
    CGFloat xOffsetForLeftPhrases = horizontalPadding;
    CGFloat xOffsetForRightPhrases = gameFrameWidth - (phraseWidth + horizontalPadding);
    // Set the phrase vertical padding
    CGFloat phrasePadding = phraseHeight * 0.10;
    // Set the initial y-offset
    CGFloat yOffset = verticalPadding;
    
    NSString *path_correct  = [[NSBundle mainBundle] pathForResource:@"correct_gong" ofType:@"wav"];
    NSString *path_incorrect  = [[NSBundle mainBundle] pathForResource:@"incorrect_buzzer" ofType:@"wav"];
    NSURL *pathURL_correct = [NSURL fileURLWithPath:path_correct];
    NSURL *pathURL_incorrect = [NSURL fileURLWithPath:path_incorrect];
    NSError *correct_error = nil;
    _correctAudio = [[AVAudioPlayer alloc]
                                   initWithContentsOfURL:pathURL_correct
                                   error:&correct_error];
    NSError *incorrect_error = nil;
    _incorrectAudio = [[AVAudioPlayer alloc]
                                     initWithContentsOfURL:pathURL_incorrect
                                     error:&incorrect_error];
    
    [_correctAudio setVolume:0.0];
    [_correctAudio play];
    
    [_incorrectAudio setVolume:0.0];
    [_incorrectAudio play];
    
    if (correct_error) {
      NSLog(@"Error, file not found: %@",path_correct);
    }
    if (incorrect_error) {
      NSLog(@"Error, file not found: %@",path_incorrect);
    }
    
    // Simultaenously create the buttons on the left and the right side
    for (int i = 0; i < _numPhrases; i++) {
      // Create a button containing a phrase on the left side
      // Left side buttons are tagged with a 1 and then the index of the phrase
      //    in the array
      CGRect buttonFrame = CGRectMake(xOffsetForLeftPhrases, yOffset, phraseWidth, phraseHeight);
      UIButton* phraseButton = [[UIButton alloc] initWithFrame:buttonFrame];
      [phraseButton.titleLabel setAdjustsFontSizeToFitWidth:NO];
      [phraseButton.titleLabel setNumberOfLines:0];
      // Add padding around text
      phraseButton.contentEdgeInsets= UIEdgeInsetsMake(30, 30, 30, 30);
      [phraseButton setTitle:[leftSide objectAtIndex:i] forState:UIControlStateNormal];
      [phraseButton setBackgroundImage:[UIImage imageNamed:@"geodenormal"] forState:UIControlStateNormal];
      phraseButton.tag = (1 * 10) + (i + 1);
      [phraseButton addTarget:self action:@selector(phraseSelected:) forControlEvents:UIControlEventTouchUpInside];
      [self addSubview:phraseButton];
      [_leftSidePhraseButtons insertObject:phraseButton atIndex:i];
      
      // Create a button containing a phrase on the left side
      // Right side buttons are tagged with a 2 and then the index of the phrase
      //    in the array
      buttonFrame = CGRectMake(xOffsetForRightPhrases, yOffset, phraseWidth, phraseHeight);
      phraseButton = [[UIButton alloc] initWithFrame:buttonFrame];
      [phraseButton.titleLabel setAdjustsFontSizeToFitWidth:NO];
      [phraseButton.titleLabel setNumberOfLines:0];
      // Add padding around text
      phraseButton.contentEdgeInsets= UIEdgeInsetsMake(30, 30, 30, 30);
      [phraseButton setTitle:[rightSide objectAtIndex:i] forState:UIControlStateNormal];
      [phraseButton setBackgroundImage:[UIImage imageNamed:@"geodenormal"] forState:UIControlStateNormal];
      phraseButton.tag = (2 * 10) + (i + 1);
      [phraseButton addTarget:self action:@selector(phraseSelected:) forControlEvents:UIControlEventTouchUpInside];
      [self addSubview:phraseButton];
      [_rightSidePhraseButtons insertObject:phraseButton atIndex:i];
      
      // Initialize matched array to all 0s
      [_leftMatched insertObject:[NSNumber numberWithInt:0] atIndex:i];
      [_rightMatched insertObject:[NSNumber numberWithInt:0] atIndex:i];

      yOffset += phraseHeight + phrasePadding;
    }
    
    // Initialize the return button
    [self initReturnButtonWithFrame:frame];
  }
  
  return self;
}

-(void)initReturnButtonWithFrame:(CGRect)frame
{
  // Get the dimensions of the frame
  CGFloat frameWidth = CGRectGetWidth(frame);
  CGFloat frameHeight = CGRectGetHeight(frame);
  
  // The return button will be 10% of the screen height and 25% of the width, with
  //   padding equal to 10% of button width all around
  CGFloat returnFrameWidth = frameWidth * 0.25;
  CGFloat returnFrameHeight = frameHeight * 0.10;
  CGFloat padding = returnFrameWidth * 0.10;
  
  CGFloat verticalOffset = frameHeight - (returnFrameHeight + padding);
  CGFloat horizontalOffset = frameWidth - (returnFrameWidth + padding);

  // Make the frame for the return button
  CGRect returnFrame = CGRectMake(horizontalOffset, verticalOffset, returnFrameWidth, returnFrameHeight);
  // Make the button and add it to the view
  UIButton* returnButton = [[UIButton alloc] initWithFrame:returnFrame];
  [returnButton setTitle:@"Return to Village" forState:UIControlStateNormal];
  // TODO: set background color to blue for visibility
  [returnButton setBackgroundImage:[UIImage imageNamed:@"geodered"] forState:UIControlStateNormal];
  [returnButton addTarget:self action:@selector(exitGame) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:returnButton];
}

-(void)phraseSelected:(id)sender
{
  UIButton *newButton = (UIButton*) sender;
  UIButton *oldButton;
  BOOL deselect = NO;
  
  // 1 = left, 2 = right
  int sideSelected = (int) newButton.tag / 10;
  int phraseSelected = (newButton.tag % 10);
  
  if (sideSelected == 1) {
    // If the phrase has already been matched, no more to do
    if ([[_leftMatched objectAtIndex:phraseSelected - 1] intValue]) {
      NSLog(@"Already matched!");
      return;
    }
    else if (_leftSelected != 0) {
      oldButton = [_leftSidePhraseButtons objectAtIndex:_leftSelected - 1];
      [oldButton setBackgroundImage:[UIImage imageNamed:@"geodenormal"] forState:UIControlStateNormal];
    }
    
    if (_leftSelected == phraseSelected) {
      deselect = YES;
      _leftSelected = 0;
    }
    else {
      _leftSelected = phraseSelected;
    }
  }
  else if (sideSelected == 2) {
    // If the phrase has already been matched, no more to do
    if ([[_rightMatched objectAtIndex:phraseSelected - 1] intValue]) {
      NSLog(@"Already matched!");
      return;
    }
    else if (_rightSelected != 0) {
      oldButton = [_rightSidePhraseButtons objectAtIndex:_rightSelected - 1];
      [oldButton setBackgroundImage:[UIImage imageNamed:@"geodenormal"] forState:UIControlStateNormal];
    }
    
    if (_rightSelected == phraseSelected) {
      deselect = YES;
      _rightSelected = 0;
    }
    else {
      _rightSelected = phraseSelected;
    }
  }
  
  if (deselect) {
    return;
  }
  else {
    [newButton setBackgroundImage:[UIImage imageNamed:@"geodeselected"] forState:UIControlStateNormal];
  }
  
  // If both sides have been selected, then check to see if the match is correct
  if (_leftSelected != 0 && _rightSelected != 0) {
    NSLog(@"Checking for a match...");
    [self checkMatchWithLeft:_leftSelected andRight:_rightSelected];
  }
}

-(void)checkMatchWithLeft:(int)left andRight:(int)right
{
  // Get the associated phrases
  UIButton *button = [_leftSidePhraseButtons objectAtIndex:left - 1];
  NSString *leftPhrase = button.currentTitle;
  button = [_rightSidePhraseButtons objectAtIndex:right - 1];
  NSString *rightPhrase = button.currentTitle;
  
  // Delegate this to the game controller
  [self.delegate checkForMatchWithLeftPhrase:leftPhrase andRightPhrase:rightPhrase];
}

-(void)matchFound:(BOOL)match
{
  UIButton *leftButton = [_leftSidePhraseButtons objectAtIndex:_leftSelected - 1];
  UIButton *rightButton = [_rightSidePhraseButtons objectAtIndex:_rightSelected - 1];
  
  if (match) {
    [_correctAudio setVolume:1.0];
    [_correctAudio play];
    // Increment number of matches
    _countMatched++;
    // Mark down the match so that they will be unclickable
    [_leftMatched replaceObjectAtIndex:_leftSelected - 1 withObject:[NSNumber numberWithInt:1]];
    [_rightMatched replaceObjectAtIndex:_rightSelected - 1 withObject:[NSNumber numberWithInt:1]];
    // Change the background color to matched
    [leftButton setBackgroundImage:[UIImage imageNamed:@"geodegrey"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"geodegrey"] forState:UIControlStateNormal];
  }
  else {
    [_incorrectAudio setVolume:0.5];
    [_incorrectAudio play];
    // Reset the background color to original
    [leftButton setBackgroundImage:[UIImage imageNamed:@"geodenormal"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"geodenormal"] forState:UIControlStateNormal];
  }
  
  _leftSelected = 0;
  _rightSelected = 0;
  
  // If we've matched everything, the game is won!
  if (_countMatched == _numPhrases) {
    NSLog(@"Congrats, you won!");
    [self wonGame];
  }
}

-(void)wonGame
{
  // Tell game controller to leave the view
  [self.delegate exitMinigame:YES];
}

-(void)exitGame
{
  // Clear any current selections
  UIButton *oldButton;
  
  if (_leftSelected != 0) {
    oldButton = [_leftSidePhraseButtons objectAtIndex:_leftSelected - 1];
    [oldButton setBackgroundImage:[UIImage imageNamed:@"geodenormal"] forState:UIControlStateNormal];
    _leftSelected = 0;
  }
  
  if (_rightSelected != 0) {
    oldButton = [_rightSidePhraseButtons objectAtIndex:_rightSelected - 1];
    [oldButton setBackgroundImage:[UIImage imageNamed:@"geodenormal"] forState:UIControlStateNormal];
    _rightSelected = 0;
  }
  
  // Tell game controller to leave the view
  [self.delegate exitMinigame:NO];
}

@end
