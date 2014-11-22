//
//  ScalesGameView.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/20/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "ScalesGameView.h"
#import "ScalesGameCoin.h"
#import "Constants.h"

@interface ScalesGameView()
{
  CGRect _gameFrame;
  
  UIView *_leftScaleView;
  UIView *_rightScaleView;
  UIButton *_leftScale;
  UIButton *_rightScale;
  UIButton *_fakeCoinBucket;
  
  UIImage *_coinImage;
  UIImage *_coinHighlightImage;
  int _coinSize;
  
  NSMutableArray *_trayCells;
  NSMutableArray *_leftCells;
  NSMutableArray *_rightCells;
  
  NSMutableArray *_coinArray;
  NSMutableArray *_coinImgArray;
  
  ScalesGameCoin* _currentCoin;
  ScalesGameCoin* _guessCoin;
  int _currentCoinNum;
}
@end

@implementation ScalesGameView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  
  if (self) {
    // Set the minigame background
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"scalesBackground.png"]]];
    
    // Get the dimensions of the frame
    CGFloat frameWidth = CGRectGetWidth(frame);
    CGFloat frameHeight = CGRectGetHeight(frame);
    
    // The game frame will be 90% of the screen, the bottom 10% is for the game
    //    bottom bar
    CGFloat gameFrameWidth = frameWidth;
    CGFloat gameFrameHeight = frameHeight * 0.90;
    _gameFrame = CGRectMake(0, 0, gameFrameWidth, gameFrameHeight);
    
    _coinSize = (gameFrameWidth * 0.50) / 6;
    
    // Initialize the arrays
    _trayCells = [[NSMutableArray alloc] initWithCapacity:SCALES_MAXNUMCOINS];
    _leftCells = [[NSMutableArray alloc] initWithCapacity:SCALES_MAXNUMCOINS];
    _rightCells = [[NSMutableArray alloc] initWithCapacity:SCALES_MAXNUMCOINS];
    
    // Initialize the game graphics
    [self initScalesWithFrame:_gameFrame];
    [self initTrayWithFrame:_gameFrame];
    [self initWeighButtonWithFrame:_gameFrame];
    
    // Initialize the return button
    [self initReturnButtonWithFrame:frame];
    
    // Fake coin bucket
    // Each cell in the tray is the size of a button with 5% padding on each side
    // The bucket should be double that size
    CGFloat cellSize = _coinSize + (_coinSize * 0.10);
    CGFloat bucketSize = 2 * cellSize;
    CGFloat verticalPadding = CGRectGetHeight(_gameFrame) * 0.05;
    
    // Set the x- and y-offsets accordingly
    CGFloat xOffset = cellSize / 4;
    CGFloat yOffset = CGRectGetHeight(_gameFrame) - ((2 * cellSize) + verticalPadding);
    
    CGRect bucketFrame = CGRectMake(xOffset, yOffset, bucketSize, bucketSize+.1*bucketSize);
    _fakeCoinBucket = [[UIButton alloc] initWithFrame:bucketFrame];
    [_fakeCoinBucket setBackgroundImage:[UIImage imageNamed:@"TreasureChest.png"] forState:UIControlStateNormal];
    _fakeCoinBucket.tag = 500;
    [_fakeCoinBucket addTarget:self action:@selector(moveCoinTo:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_fakeCoinBucket];
  
  }
  
  return self;
}

- (void)setCurrencyForCiv:(int)civ
{
  // Set the coin image according to the civ
  if (civ == INDIA) {
    _coinImage = [UIImage imageNamed:@"indiacurr"];
    _coinHighlightImage = [UIImage imageNamed:@"indiacurrselect"];
  }
  else if (civ == CHINA) {
    _coinImage = [UIImage imageNamed:@"chinacurr"];
    _coinHighlightImage = [UIImage imageNamed:@"chinacurrselect"];
  }
  else {
    _coinImage = [UIImage imageNamed:@"indiacurr"];
    _coinHighlightImage = [UIImage imageNamed:@"indiacurrselect"];
  }
}

- (void)newGameWithCoins:(NSMutableArray*)coins
{
  // Reset all instance variables
  _currentCoin = NULL;
  _guessCoin = NULL;
  _currentCoinNum = (int)[coins count];
  
  // Clear the arrays
  [_coinArray removeAllObjects];
  for (UIButton* coin in _coinImgArray) {
    [coin removeFromSuperview];
  }
  [_coinImgArray removeAllObjects];
  
  // Now initialize them for the new array
  _coinArray = [[NSMutableArray alloc] initWithCapacity:[coins count]];
  _coinImgArray = [[NSMutableArray alloc] initWithCapacity:[coins count]];
  
  // Put the coins into the coin array
  _coinArray = [coins mutableCopy];
  
  // Add the coins to the game graphics
  [self makeScalesBalanced];
  [self initCoins];
}

- (void)initScalesWithFrame:(CGRect)frame
{
  // Get the dimensions of the frame
  CGFloat frameWidth = CGRectGetWidth(frame);
  CGFloat frameHeight = CGRectGetHeight(frame);
  
  // Have 10% padding on all sides
  CGFloat horizontalPadding = frameWidth * 0.1;
  CGFloat verticalPadding = frameHeight * 0.1;

  // Make each cell in the tray the size of a button with 5% padding on all sides
  CGFloat cellSize = _coinSize + (_coinSize * 0.02);
  
  CGFloat scaleWidth = cellSize * 4.2;
  CGFloat scaleHeight = cellSize * 4;
  
  // START WITH THE LEFT SCALE
  // Set the x- and y-offsets accordingly
  CGFloat xOffsetLeft = horizontalPadding;
  CGFloat yOffsetLeft = verticalPadding;
  CGRect leftScaleFrame = CGRectMake(xOffsetLeft, yOffsetLeft, scaleWidth, scaleHeight);
  _leftScaleView = [[UIView alloc] initWithFrame:leftScaleFrame];
  UIImage* origLeftArm = [UIImage imageNamed:@"leftArm"];
  UIImage *scaledLeftArm = [UIImage imageWithCGImage:[origLeftArm CGImage]
                      scale:(origLeftArm.scale * 1.1)
                      orientation:(origLeftArm.imageOrientation)];
  UIImageView* leftScale = [[UIImageView alloc] initWithImage:scaledLeftArm];
  [self addSubview:_leftScaleView];
  [_leftScaleView addSubview:leftScale];
  
  CGFloat xOffset = 20;
  CGFloat yOffset = 5;
  
  // Create 3 rows of 4 cells
  for (int row = 0; row < 3; row++) {
    for (int col = 0; col < 4; col++) {
      CGRect cellFrame = CGRectMake(xOffset, yOffset, cellSize, cellSize);
      UIButton *cell = [[UIButton alloc] initWithFrame:cellFrame];
      cell.tag = 100 + (row * 4) + col;
      [cell addTarget:self action:@selector(moveCoinTo:) forControlEvents:UIControlEventTouchUpInside];
      
      [_leftCells insertObject:cell atIndex:(cell.tag - 100)];
      [_leftScaleView addSubview:cell];
      
      xOffset += cellSize;
    }
    
    xOffset = 20;
    yOffset += cellSize - (cellSize * .05);
  }
  
  // NOW MAKE THE RIGHT SCALE
  // Set the x- and y-offsets accordingly
  CGFloat xOffsetRight = frameWidth - (cellSize * 4.75) - horizontalPadding;
  CGFloat yOffsetRight = verticalPadding;
  
  CGRect rightScaleFrame = CGRectMake(xOffsetRight, yOffsetRight, scaleWidth, scaleHeight);
  _rightScaleView = [[UIView alloc] initWithFrame:rightScaleFrame];
  UIImage* origRightArm = [UIImage imageNamed:@"rightScale"];
  UIImage *scaledRightArm = [UIImage imageWithCGImage:[origRightArm CGImage]
                                               scale:(origRightArm.scale * 1.1)
                                         orientation:(origRightArm.imageOrientation)];
  UIImageView* rightScale = [[UIImageView alloc] initWithImage:scaledRightArm];
  [_rightScaleView addSubview:rightScale];
  CGRect rightFrame = _rightScaleView.frame;
  rightFrame.origin.x = xOffsetRight;
  rightFrame.origin.y = yOffsetRight;
  
  [self addSubview:_rightScaleView];
  
  xOffset = 20;
  yOffset = 5;
  
  // Create 3 rows of 4 cells
  for (int row = 0; row < 3; row++) {
    for (int col = 0; col < 4; col++) {
      CGRect cellFrame = CGRectMake(xOffset, yOffset, cellSize, cellSize);
      UIButton *cell = [[UIButton alloc] initWithFrame:cellFrame];
      cell.tag = 200 + (row * 4) + col;
      [cell addTarget:self action:@selector(moveCoinTo:) forControlEvents:UIControlEventTouchUpInside];
      
      [_rightCells insertObject:cell atIndex:(cell.tag - 200)];
      [_rightScaleView addSubview:cell];
      
      xOffset += cellSize;
    }
    
    xOffset = 20;
    yOffset += cellSize - (cellSize * .05);
  }
  
  // Draw the support rods
  CGFloat rodWidth = 0.05 * scaleWidth;
  CGFloat rodHeight = scaleHeight * 0.75;
  CGFloat yOffsetRod = yOffsetLeft + (scaleHeight / 2);
  CGFloat xOffsetLeftRod = xOffsetLeft + (scaleWidth / 2) - (0.025 * scaleWidth);
  CGFloat xOffsetRightRod = xOffsetRight + (scaleWidth / 2) - (0.025 * scaleWidth);
  
  CGRect leftVertRodFrame = CGRectMake(xOffsetLeftRod, yOffsetRod, rodWidth, rodHeight);
  CGRect rightVertRodFrame = CGRectMake(xOffsetRightRod, yOffsetRod, rodWidth, rodHeight);
  
  UILabel* leftVertRod = [[UILabel alloc] initWithFrame:leftVertRodFrame];
  UILabel* rightVertRod = [[UILabel alloc] initWithFrame:rightVertRodFrame];
  [self addSubview:leftVertRod];
  [self addSubview:rightVertRod];
  [self sendSubviewToBack:leftVertRod];
  [self sendSubviewToBack:rightVertRod];
  
  // Draw the connecting horizontal bar
  CGFloat horizRodWidth = xOffsetRightRod - xOffsetLeftRod + (0.05 * scaleWidth);
  CGFloat horizRodHeight = rodWidth;
  CGFloat yOffsetHorizRod = yOffsetRod + rodHeight;
  CGFloat xOffsetHorizRod = xOffsetLeftRod;

  CGRect horizRodFrame = CGRectMake(xOffsetHorizRod, yOffsetHorizRod, horizRodWidth, horizRodHeight);
  
  UILabel* horizRod = [[UILabel alloc] initWithFrame:horizRodFrame];
  [self addSubview:horizRod];
  
  // Draw the middle vertical bar
  CGFloat vertRodWidth = (xOffsetRight - (xOffsetLeftRod + scaleWidth)) / 2;
  CGFloat vertRodHeight = rodHeight / 2;
  CGFloat yOffsetVertRod = yOffsetHorizRod;
  CGFloat xOffsetVertRod = xOffsetHorizRod + (horizRodWidth / 2) - (vertRodWidth / 2);
  
  CGRect vertRodFrame = CGRectMake(xOffsetVertRod, yOffsetVertRod, vertRodWidth, vertRodHeight);
  
  UILabel* vertRod = [[UILabel alloc] initWithFrame:vertRodFrame];
  [self addSubview:vertRod];
  [self sendSubviewToBack:vertRod];
  
}

- (void)initTrayWithFrame:(CGRect)frame
{
  // Get the dimensions of the frame
  CGFloat frameWidth = CGRectGetWidth(frame);
  CGFloat frameHeight = CGRectGetHeight(frame);
  
  // Make each cell in the tray the size of a button with 5% padding on all sides
  CGFloat cellSize = _coinSize + (_coinSize * 0.10);
  CGFloat horizontalPadding = (frameWidth - (cellSize * 6)) / 2;
  CGFloat verticalPadding = frameHeight * 0.05;
  
  // Set the x- and y-offsets accordingly
  CGFloat xOffset = horizontalPadding;
  CGFloat yOffset = frameHeight - ((2 * cellSize) + verticalPadding);
  
  // Create 2 rows of 6 cells
  for (int row = 0; row < 2; row++) {
    for (int col = 0; col < 6; col++) {
      CGRect cellFrame = CGRectMake(xOffset, yOffset, cellSize, cellSize);
      UIButton *cell = [[UIButton alloc] initWithFrame:cellFrame];
      cell.tag = (row * 6) + col;
      [cell addTarget:self action:@selector(moveCoinTo:) forControlEvents:UIControlEventTouchUpInside];
      
      [_trayCells insertObject:cell atIndex:cell.tag];
      [self addSubview:cell];
      
      xOffset += cellSize;
    }
    
    xOffset = horizontalPadding;
    yOffset += cellSize;
  }
}

- (void)initCoins
{
  int numCoins = (int)[_coinArray count];
  CGFloat coinPadding = _coinSize * 0.05;
  
  // Fill the tray cells with coins
  for (int i = 0; i < numCoins; i++) {
    CGRect coinFrame = CGRectMake(coinPadding, coinPadding, _coinSize, _coinSize);
    UIButton *coin = [[UIButton alloc] initWithFrame:coinFrame];
    coin.tag = i;
    [coin addTarget:self action:@selector(coinSelected:) forControlEvents:UIControlEventTouchUpInside];
    [coin setBackgroundImage:_coinImage forState:UIControlStateNormal];
    [_coinImgArray insertObject:coin atIndex:coin.tag];
    
    UIButton* currentCell = [_trayCells objectAtIndex:i];
    [currentCell addSubview:coin];
  }
}

- (void)initWeighButtonWithFrame:(CGRect)frame
{
  // Get the dimensions of the frame
  CGFloat frameWidth = CGRectGetWidth(frame);
  CGFloat frameHeight = CGRectGetHeight(frame);
  
  // The button will be 10% of the screen height and 15% of the width, with
  //   padding equal to 10% of button width all around
  CGFloat weighFrameWidth = frameWidth * 0.15;
  CGFloat weighFrameHeight = frameHeight * 0.10;
  
  CGFloat verticalOffset = frameHeight * 0.55;
  CGFloat horizontalOffset = (frameWidth * 0.5) - (weighFrameWidth / 2);
  
  // Make the frame for the return button
  CGRect weighFrame = CGRectMake(horizontalOffset, verticalOffset, weighFrameWidth, weighFrameHeight);
  // Make the button and add it to the view
  UIButton* weighButton = [[UIButton alloc] initWithFrame:weighFrame];
  [weighButton setTitle:@"Weigh Coins" forState:UIControlStateNormal];
  // TODO: set background color to red for visibility
  [weighButton setBackgroundColor:[UIColor redColor]];
  [weighButton addTarget:self action:@selector(weighCoins) forControlEvents:UIControlEventTouchUpInside];
  weighButton.highlighted = YES;
  [self addSubview:weighButton];
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
  [returnButton setTitle:@"Return" forState:UIControlStateNormal];
  // TODO: set background color to green for visibility
  [returnButton setBackgroundColor:[UIColor greenColor]];
  [returnButton addTarget:self action:@selector(exitGame) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:returnButton];
}

- (void)coinSelected:(id)sender
{
  // Get the coin number
  UIButton* coin = (UIButton*) sender;
  int coinNum = (int)coin.tag;
  
  if (coinNum == _currentCoinNum) {
    _currentCoinNum = (int)[_coinArray count];
    _currentCoin = NULL;
    [coin setBackgroundImage:_coinImage forState:UIControlStateNormal];
  }
  else {
    if (_currentCoin != NULL) {
      UIButton* oldCoin = [_coinImgArray objectAtIndex:_currentCoinNum];
      [oldCoin setBackgroundImage:_coinImage forState:UIControlStateNormal];
    }
    
    _currentCoinNum = coinNum;
    _currentCoin = [_coinArray objectAtIndex:coinNum];
    [coin setBackgroundImage:_coinHighlightImage forState:UIControlStateNormal];
  }
}

- (void)moveCoinTo:(id)sender
{
  // Don't do anything if there's no coin selected
  if (_currentCoin == NULL) {
    return;
  }
  
  UIButton* placeSelected = (UIButton*) sender;
  
  int placeToMove = (int)placeSelected.tag / 100;
  
  UIButton* currentCoin = [_coinImgArray objectAtIndex:_currentCoinNum];
  // Remove the coin from where it was
  [currentCoin removeFromSuperview];
  // Put it in the new cell
  [placeSelected addSubview:currentCoin];
  
  // Reposition it to be centered
  CGRect placeFrame = placeSelected.frame;
  CGFloat frameHeight = CGRectGetHeight(placeFrame);
  CGFloat frameWidth = CGRectGetWidth(placeFrame);
  CGRect coinFrame = currentCoin.frame;
  CGFloat coinSize = CGRectGetWidth(coinFrame);
  coinFrame.origin.x = (frameWidth - coinSize) / 2;
  coinFrame.origin.y = (frameHeight - coinSize) / 2;
  currentCoin.frame = coinFrame;
  
  // Tell the controller the coin has been moved
  [self.delegate moveCoin:_currentCoin toPlace:placeToMove];
  
  // If it's in the fake coin bucket, save it as a guess
  if (placeToMove == SCALES_FAKECOINBUCKET) {
    _guessCoin = _currentCoin;
  }
  
  // Reset the selected coin
  _currentCoinNum = (int)[_coinArray count];
  _currentCoin = NULL;
  [currentCoin setBackgroundImage:_coinImage forState:UIControlStateNormal];
}

- (void) weighCoins
{
  [self.delegate weighCoinsInScale];
}

-(void)makeLeftScaleHeavier
{
  CGFloat frameHeight = CGRectGetHeight(_gameFrame);
  
  // Move the left scale down
  CGRect leftFrame = _leftScaleView.frame;
  leftFrame.origin.y = frameHeight * 0.125;
  _leftScaleView.frame = leftFrame;
  
  // Move the right scale up
  CGRect rightFrame = _rightScaleView.frame;
  rightFrame.origin.y = frameHeight * 0.075;
  _rightScaleView.frame = rightFrame;
}

-(void)makeRightScaleHeavier
{
  CGFloat frameHeight = CGRectGetHeight(_gameFrame);
  
  // Move the right scale down
  CGRect rightFrame = _rightScaleView.frame;
  rightFrame.origin.y = frameHeight * 0.125;
  _rightScaleView.frame = rightFrame;
  
  // Move the left scale up
  CGRect leftFrame = _leftScaleView.frame;
  leftFrame.origin.y = frameHeight * 0.075;
  _leftScaleView.frame = leftFrame;
}

-(void)makeScalesBalanced
{
  CGFloat frameHeight = CGRectGetHeight(_gameFrame);
  
  // Return both scales to middle position
  CGRect leftFrame = _leftScaleView.frame;
  leftFrame.origin.y = frameHeight * 0.1;
  _leftScaleView.frame = leftFrame;
  
  CGRect rightFrame = _rightScaleView.frame;
  rightFrame.origin.y = frameHeight * 0.1;
  _rightScaleView.frame = rightFrame;
}

- (void)foundFakeCoin:(BOOL)found andCanGuess:(BOOL)guess
{
  // If we found the coin, move to guessing the weight
  if (found) {
    [self alertRightCoin];
  }
  else {
    // If you can still guess, try again
    // Otherwise, new set of coins
    if (guess) {
      [self alertWrongCoin];
    }
    else {
      [self lostGameWithWeight:NO];
    }
  }
}

- (void)alertRightCoin
{
  NSString *message = [NSString stringWithFormat:@"That looks like a fake coin! Tell me, is that coin heavier or lighter than the others?"];
  UIAlertView *rightAlert = [[UIAlertView alloc] initWithTitle:@"Good job!"
                                                       message:message
                                                      delegate:self
                                             cancelButtonTitle:@"Heavier"
                                             otherButtonTitles:@"Lighter", nil];
  rightAlert.tag = 1;
  [rightAlert show];
}

- (void)alertWrongCoin
{
  NSString *message = [NSString stringWithFormat:@"That coin wasn't fake!"];
  UIAlertView *wrongAlert = [[UIAlertView alloc] initWithTitle:@"Wrong coin!"
                                                     message:message
                                                    delegate:self
                                           cancelButtonTitle:@"Try Again"
                                           otherButtonTitles: nil];
  wrongAlert.tag = 2;
  [wrongAlert show];
}

- (void)lostGameWithWeight:(BOOL)guessingWeight
{
  NSString* message;
  
  if (guessingWeight) {
    message = [NSString stringWithFormat:@"Sorry, that doesn't seem right. Don't worry, I'll give you a new set of coins to try."];
  }
  else {
    message = [NSString stringWithFormat:@"Sorry, that coin wasn't fake either! It's okay, I'll give you a new set of coins to try."];
  }
  
  UIAlertView *lostAlert = [[UIAlertView alloc] initWithTitle:@"Oh no!"
                                                       message:message
                                                      delegate:self
                                             cancelButtonTitle:@"Okay"
                                             otherButtonTitles: nil];
  lostAlert.tag = 3;
  [lostAlert show];
}

- (void)wonGame
{
  // Tell game controller to leave the view
  [self.delegate exitScalesGame:YES];
}

- (void)exitGame
{
  // Tell game controller to leave the view
  [self.delegate exitScalesGame:NO];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  if (alertView.tag == 1) {
    BOOL coinIsHeavier = [_guessCoin weight] > 1;
    BOOL coinIsLighter = [_guessCoin weight] < 1;
    
    if (((buttonIndex == 0) & coinIsHeavier) || ((buttonIndex == 1) & coinIsLighter)) {
      [self wonGame];
    }
    else {
      [self lostGameWithWeight:YES];
    }
  }
  else if (alertView.tag == 3) {
    [self.delegate startNewGame];
  }
}

@end
