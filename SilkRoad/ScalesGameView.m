//
//  ScalesGameView.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/20/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "ScalesGameView.h"
#import "ScalesGameCoin.h"

@interface ScalesGameView()
{
  UILabel *_leftScale;
  UILabel *_rightScale;
  UILabel *_tray;
}
@end

@implementation ScalesGameView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  
  if (self) {
    
    // Set the minigame background
    [self setBackgroundColor:[UIColor whiteColor]];
    
    // Get the dimensions of the frame
    CGFloat frameWidth = CGRectGetWidth(frame);
    CGFloat frameHeight = CGRectGetHeight(frame);
    
    // The game frame will be 90% of the screen, the bottom 10% is for the game
    //    bottom bar
    CGFloat gameFrameWidth = frameWidth;
    CGFloat gameFrameHeight = frameHeight * 0.90;
    
    // TODO: SCALE GRAPHICS
    // For now, just have labels with coin names
    
    // Have 10% padding on all sides
    CGFloat horizontalPadding = gameFrameWidth * 0.10;
    CGFloat verticalPadding = gameFrameHeight * 0.10;
    // Make the side scales 35% of the frame width and the tray 80%
    // 80% of the screen height is left for the scales/tray; make the side scales
    //    use 35% and the tray use 35%
    CGFloat scaleWidth = gameFrameWidth * 0.35;
    CGFloat scaleHeight = gameFrameHeight * 0.35;
    CGFloat trayWidth = gameFrameWidth * 0.80;
    CGFloat trayHeight = gameFrameHeight * 0.80;
    // Set the x-offset accordingly
    CGFloat xOffsetForLeftScale = horizontalPadding;
    CGFloat xOffsetForRightScale = gameFrameWidth - (scaleWidth + horizontalPadding);
    CGFloat xOffsetForTray = horizontalPadding;
    // Set the y-offset accordingly
    CGFloat yOffsetForScales = verticalPadding;
    CGFloat yOffsetForTray = gameFrameHeight - (trayHeight + verticalPadding);
    
    // Create frames
    CGRect leftScaleFrame = CGRectMake(xOffsetForLeftScale, yOffsetForScales, scaleWidth, scaleHeight);
    CGRect rightScaleFrame = CGRectMake(xOffsetForRightScale, yOffsetForScales, scaleWidth, scaleHeight);
    CGRect trayFrame = CGRectMake(xOffsetForTray, yOffsetForTray, trayWidth, trayHeight);
    
    // Create labels
    _leftScale = [[UILabel alloc] initWithFrame:leftScaleFrame];
    [_leftScale setBackgroundColor:[UIColor yellowColor]];
    _rightScale = [[UILabel alloc] initWithFrame:rightScaleFrame];
    [_rightScale setBackgroundColor:[UIColor yellowColor]];
    _tray = [[UILabel alloc] initWithFrame:trayFrame];
    [_tray setBackgroundColor:[UIColor blueColor]];
    
    // Initialize the return button
    [self initReturnButtonWithFrame:frame];
  }
  
  return self;
}

- (void)initReturnButtonWithFrame:(CGRect)frame
{
  // Get the dimensions of the frame
  CGFloat frameWidth = CGRectGetWidth(frame);
  CGFloat frameHeight = CGRectGetHeight(frame);
  
  // The return button will be 10% of the screen height and 15% of the width, with
  //   padding equal to 10% of button width all around
  CGFloat returnFrameWidth = frameWidth * 0.15;
  CGFloat returnFrameHeight = frameHeight * 0.10;
  CGFloat padding = returnFrameWidth * 0.10;
  
  CGFloat verticalOffset = frameHeight - (returnFrameHeight + padding);
  CGFloat horizontalOffset = frameWidth - (returnFrameWidth + padding);
  
  // Make the frame for the return button
  CGRect returnFrame = CGRectMake(horizontalOffset, verticalOffset, returnFrameWidth, returnFrameHeight);
  // Make the button and add it to the view
  UIButton* returnButton = [[UIButton alloc] initWithFrame:returnFrame];
  [returnButton setTitle:@"Return to Hut" forState:UIControlStateNormal];
  // TODO: set background color to green for visibility
  [returnButton setBackgroundColor:[UIColor greenColor]];
  [returnButton addTarget:self action:@selector(exitGame) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:returnButton];
}

- (void)updateCoinsInLeftScale:(NSMutableArray*)leftScaleCoins RightScale:(NSMutableArray*)rightScaleCoins andTray:(NSMutableArray*)trayCoins
{
  NSString* leftScale = [leftScaleCoins componentsJoinedByString:@" "];
  NSString* rightScale = [rightScaleCoins componentsJoinedByString:@" "];
  NSString* tray = [trayCoins componentsJoinedByString:@" "];
  
  [_leftScale setText:leftScale];
  [_rightScale setText:rightScale];
  [_tray setText:tray];
}

- (void)identifyFakeCoin:(id)sender
{
  // Delegate this to the game controller
  [self.delegate checkIfCoinFake:sender];
}

- (void)foundFakeCoin:(BOOL)found
{
  // If we found the coin, the game is won
  if (found) {
    NSLog(@"Congrats, you won!");
    [self wonGame];
  }
  else {
    NSLog(@"Sorry, try again...");
    [self newGame];
  }
}

- (void)newGame
{
  // Wait
}

- (void)wonGame
{
  // Tell game controller to leave the view
  [self.delegate exitMinigame];
}

- (void)exitGame
{
  // Tell game controller to leave the view
  [self.delegate exitMinigame];
}

@end
