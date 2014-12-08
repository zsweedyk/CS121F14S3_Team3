//
//  RoadGameView.m
//  SilkRoad
//
//  Created by CS121 on 10/18/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "RoadGameView.h"
#import "Constants.h"

@interface RoadGameView()
{
  NSMutableArray* _buttonGrid;
  UIButton* _lastButtonPressed;
  BOOL _waitingForPair;
  NSMutableDictionary* _connections;
  
  CGFloat _frameWidth;
  CGFloat _frameHeight;
  CGFloat _buttonSize;
}

@end

@implementation RoadGameView

-(id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Get the dimensions of the frame
    _frameWidth = CGRectGetWidth(frame);
    _frameHeight = CGRectGetHeight(frame);
    
    // The game frame will be 90% of the screen, the bottom 10% is for buttons
    // The grid is 9 x 9, so there are 10 spaces, dividing the frame into 19
    _buttonSize = MIN(_frameWidth / 19.0, _frameHeight * 0.90 / 19.0);
    
    [self initializeGridWithFrame:frame];
    
    // Each click event needs to be paired with another, as the player is trying to
    // connect button nodes
    _waitingForPair = NO;
    
    // Add the bottom buttons
    NSArray* buttonLabels = @[@"Return", @"New Puzzle", @"Reset Puzzle"];
    NSArray* buttonActions = @[@"exitGame", @"newGame", @"resetGame"];
    
    CGFloat yOffset = _frameHeight * 0.90;
    CGFloat xOffset = 20 * _buttonSize;
    for (int i = 0; i < 3; i++) {
      CGRect buttonFrame = CGRectMake(xOffset, yOffset, 5 * _buttonSize, _buttonSize);
      [self createButtonWithFrame:buttonFrame Action:NSSelectorFromString(buttonActions[i]) AndLabel:buttonLabels[i]];
      xOffset -= 6 * _buttonSize;
    }
  }
  return self;
}

-(void)setBackgroundForCivilization:(int)civilization
{
  // Setup a new context with the correct size
  UIImage* backgroundMap;
  if (civilization == INDIA) {
    backgroundMap = [UIImage imageNamed:@"AsiaMapBlank.png"];
  } else {
    backgroundMap = [UIImage imageNamed:@"ChinaBlankMap.png"];
  }
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(_frameWidth, _frameHeight), YES, 0.0);
  CGContextRef context = UIGraphicsGetCurrentContext();
  UIGraphicsPushContext(context);
  
  // Draw map image so that it's centered on this context
  CGPoint origin = CGPointMake((_frameWidth - backgroundMap.size.width) / 2.0f,
                               (_frameHeight - backgroundMap.size.height) / 2.0f);
  [backgroundMap drawAtPoint:origin];
  
  // Clean up and get the new image.
  UIGraphicsPopContext();
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  // Set the minigame background
  [self setBackgroundColor:[UIColor colorWithPatternImage:newImage]];
}

-(void)initializeGridWithFrame:(CGRect)frame
{
  // The game frame will be 90% of the screen, the bottom 10% is for the game
  //    bottom bar
  CGFloat gameFrameWidth = _frameWidth;
  CGFloat gameFrameHeight = _frameHeight * 0.90;
  
  CGFloat boxSize = MIN(_frameWidth, _frameHeight);
  // There are 9 grid cells to display, and 10 lines between them
  CGFloat horizontalPadding = gameFrameWidth / 19.0;
  CGFloat verticalPadding = gameFrameHeight / 19.0;
  
  CGFloat extraHorizontalSpace = _frameWidth - boxSize;
  CGFloat yOffset = verticalPadding;
  _buttonSize = MIN(horizontalPadding, verticalPadding);
  
  // Initialize the button grid
  _buttonGrid = [[NSMutableArray alloc] initWithCapacity:9];
  _connections = [[NSMutableDictionary alloc] init];
  
  // Add buttons to the grid, tag is a two digit number with the first number
  // representing row, and the second column. The space between buttons is
  // equal to the size of a button.
  for (int row = 0; row < 9; row++) {
    [_buttonGrid addObject:[[NSMutableArray alloc] initWithCapacity:9]];
    CGFloat xOffset = extraHorizontalSpace / 2.0;
    
    for (int col = 0; col < 9; col++) {
      CGRect buttonFrame = CGRectMake(xOffset, yOffset, _buttonSize, _buttonSize);
      UIButton* button = [[UIButton alloc] initWithFrame:buttonFrame];
      
      
      [button.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18]];
      
      
      [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      [button setTag: row * 10 + col];
      
      [[_buttonGrid objectAtIndex:row] addObject:button];
      [self addSubview:button];
      
      xOffset += 2 * _buttonSize;
    }
    yOffset += 2 * _buttonSize;
  }
}

-(void)createButtonWithFrame:(CGRect)frame Action:(SEL)selector AndLabel:(NSString*)label
{
  UIButton* button = [[UIButton alloc] initWithFrame:frame];
  
  [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
  [button setTitle:label forState:UIControlStateNormal];
  [self styleButton:button];
  
  [self addSubview:button];
}

-(void)styleButton:(UIButton*)button
{
  [button setBackgroundColor:[UIColor blackColor]];
  button.layer.cornerRadius = 8;
  [[button layer] setBorderWidth:3.0f];
  [[button layer] setBorderColor:[UIColor whiteColor].CGColor];
}

// Called on initalization to set nodes with actual values to be black and rounded
-(void)setNodeBackgroundAtRow:(int)row AndColumn:(int)col
{
  UIButton* button = [[_buttonGrid objectAtIndex:row] objectAtIndex:col];
  button.layer.cornerRadius = _buttonSize / 2.0;
  [button setBackgroundColor:[UIColor blackColor]];
}

// Set the value of a node at a given row and column
-(void)setNodeValueAtRow:(int)row AndColumn:(int)col toValue:(int) value
{
  UIButton* button = [[_buttonGrid objectAtIndex:row] objectAtIndex:col];
  [button setTitle:[NSString stringWithFormat:@"%d", value] forState:UIControlStateNormal];
  
  [button addTarget:self action:@selector(drawLines:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)exitGame
{
  [self.delegate returnToPrevious];
}

-(void)newGame
{
  [self.delegate newGame];
}

-(void)drawLines:(id)sender
{
  UIButton* button = (UIButton*)sender;
  // Has button been clicked previously to this?
  // If not, set button to be highlighted, wait
  if (!_waitingForPair) {
    [button setBackgroundColor:[UIColor blueColor]];
    _lastButtonPressed = button;
    _waitingForPair = YES;
  }
  else {
    // Otherwise, see if current button and last button can be connected
    int oldRow = floor(_lastButtonPressed.tag / 10);
    int oldCol = _lastButtonPressed.tag % 10;
    int row = floor(button.tag / 10);
    int col = button.tag % 10;
    
    [_lastButtonPressed setBackgroundColor:[UIColor blackColor]];
    _waitingForPair = NO;
    
    if ([self.delegate checkConnectionValidBetweenRow:oldRow Col:oldCol AndRow:row Col:col]) {
      
      // Get the key to lookup the lines currently drawn between our nodes
      NSString* key = [self getKeyForNodeOne:button.tag NodeTwo:_lastButtonPressed.tag];
      
      // The new number of connections after updating
      NSInteger numConnections = [self.delegate createConnectionBetweenRow:oldRow Col:oldCol AndRow:row Col:col];
      

      if (numConnections == 1) {
        [button setBackgroundColor:[UIColor blackColor]];
        CGPoint lineStart = [_lastButtonPressed center];
        CGPoint lineEnd = [button center];
        
        if (row == oldRow) {
          if (col < oldCol) {
            lineStart.x -= _buttonSize / 2.0;
            lineEnd.x += _buttonSize / 2.0;
          }
          else {
            lineStart.x += _buttonSize / 2.0;
            lineEnd.x -= _buttonSize / 2.0;
          }
        }
        else {
          if (row < oldRow) {
            lineStart.y -= _buttonSize / 2.0;
            lineEnd.y += _buttonSize / 2.0;
          }
          else {
            lineStart.y += _buttonSize / 2.0;
            lineEnd.y -= _buttonSize / 2.0;
          }
        }
        // Create a new line
        CAShapeLayer* newLine = [self drawLineFromStart:lineStart ToEnd:lineEnd];
      
        // Add it to the view and update our connections dictionary to keep track of it
        [self.viewForBaselineLayout.layer addSublayer:newLine];
        NSMutableArray* lines = [[NSMutableArray alloc] initWithObjects:newLine, nil];
        [_connections setValue:lines forKey:key];
        
      }
      if (numConnections == 2) {
        NSMutableArray* lines = [_connections valueForKey:key];
        // Remove the first line, which is in the middle of the node
        // so that two new lines can be added which are spaced further apart
        [lines[0] removeFromSuperlayer];
        
        CGPoint LineOneStart, LineOneEnd, LineTwoStart, LineTwoEnd;
        
        // Vertical line
        if (col == oldCol) {
          // Set the lines to be at 1/4 and 3/4 along the node
          LineOneStart.x = [_lastButtonPressed center].x + _buttonSize / 4.0;
          LineOneEnd.x = [button center].x + _buttonSize / 4.0;
          LineTwoStart.x = LineOneStart.x - _buttonSize / 2.0;
          LineTwoEnd.x = LineOneEnd.x - _buttonSize / 2.0;
          
          if (row < oldRow) {
            LineOneStart.y = [_lastButtonPressed center].y - _buttonSize / 2.0;
            LineOneEnd.y = [button center].y + _buttonSize / 2.0;
          }
          else {
            LineOneStart.y = [_lastButtonPressed center].y + _buttonSize / 2.0;
            LineOneEnd.y = [button center].y - _buttonSize / 2.0;
          }
          LineTwoStart.y = LineOneStart.y;
          LineTwoEnd.y = LineOneEnd.y;

        }
        else {
          // Horizontal line
          LineOneStart.y = [_lastButtonPressed center].y + _buttonSize / 4.0;
          LineOneEnd.y = [button center].y + _buttonSize / 4.0;
          LineTwoStart.y = LineOneStart.y - _buttonSize / 2.0;
          LineTwoEnd.y = LineOneEnd.y - _buttonSize / 2.0;
          
          if (col < oldCol) {
            LineOneStart.x = [_lastButtonPressed center].x - _buttonSize / 2.0;
            LineOneEnd.x = [button center].x + _buttonSize / 2.0;
          }
          else {
            LineOneStart.x = [_lastButtonPressed center].x + _buttonSize / 2.0;
            LineOneEnd.x = [button center].x - _buttonSize / 2.0;
          }

          LineTwoStart.x = LineOneStart.x;
          LineTwoEnd.x = LineOneEnd.x;
        }

        // Create and add the first line
        CAShapeLayer* firstLine = [self drawLineFromStart:LineOneStart ToEnd:LineOneEnd];
        [self.viewForBaselineLayout.layer addSublayer:firstLine];
        [lines addObject:firstLine];
        
        // Create and add the second line
        CAShapeLayer* secondLine = [self drawLineFromStart:LineTwoStart ToEnd:LineTwoEnd];
        [self.viewForBaselineLayout.layer addSublayer:secondLine];
        [lines addObject:secondLine];
        
        // Store both of these as our new array of lines associated with this pair of nodes
        lines = [[NSMutableArray alloc] initWithObjects:firstLine, secondLine, nil];
        [_connections setValue:lines forKey:key];
      }
      if (numConnections == 0) {
        [self resetConnectionsForKey:key];
      }
    }
  }
}

-(CAShapeLayer*)drawLineFromStart:(CGPoint)start ToEnd:(CGPoint)end
{
  UIBezierPath* path = [UIBezierPath bezierPath];
  [path moveToPoint:start];
  [path addLineToPoint:end];
  
  CAShapeLayer* shapeLayer = [CAShapeLayer layer];
  shapeLayer.path = [path CGPath];
  shapeLayer.strokeColor = [[UIColor grayColor] CGColor];
  shapeLayer.lineWidth = 3.0;

  return shapeLayer;
}

-(NSString*)getKeyForNodeOne:(int)nodeOneTag NodeTwo:(int)nodeTwoTag
{
  // Reorder the tags so that it doesn't matter if the connection is
  // created by clicking from node one to node two or from node two to node one
  NSInteger tag1, tag2;
  if (nodeTwoTag < nodeOneTag) {
    tag1 = nodeTwoTag;
    tag2 = nodeOneTag;
  }
  else {
    tag2 = nodeTwoTag;
    tag1 = nodeOneTag;
  }
  
  // Each tag is the digit of the row, then column of the first node
  // followed by the row, col of the second node
  return [NSString stringWithFormat:@"%li%li", (long)tag1, (long)tag2];
}

// Remove all lines between two nodes
// key is string row, col, row, col of the nodes
-(void)resetConnectionsForKey:(NSString*)key {
  NSMutableArray* lines = [_connections valueForKey:key];
  for (int i = 0; i < [lines count]; i++) {
    [lines[i] removeFromSuperlayer];
  }
}

// Remove all lines on the board
-(void)resetLines
{
  for (id key in _connections) {
    [self resetConnectionsForKey:key];
  }
  _connections = [[NSMutableDictionary alloc] init];
}

-(void)resetGame
{
  [self.delegate resetGame];
}
@end
