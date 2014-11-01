//
//  RoadGameView.m
//  SilkRoad
//
//  Created by CS121 on 10/18/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "RoadGameView.h"

@interface RoadGameView()
{
  NSMutableArray* _buttonGrid;
  UIButton* _lastButtonPressed;
  BOOL _waitingForPair;
  NSMutableDictionary* _connections;
  CGFloat _buttonSize;
}

@end

@implementation RoadGameView

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
      
      // There are 9 grid cells to display, and 10 lines between them
      CGFloat horizontalPadding = gameFrameWidth / 19.0;
      CGFloat verticalPadding = gameFrameHeight / 19.0;
      
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
        CGFloat xOffset = horizontalPadding;
        
        for (int col = 0; col < 9; col++) {
          CGRect buttonFrame = CGRectMake(xOffset, yOffset, _buttonSize, _buttonSize);
          UIButton* button = [[UIButton alloc] initWithFrame:buttonFrame];
          
          [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
          [button setTag: row * 10 + col];
          
          [[_buttonGrid objectAtIndex:row] addObject:button];
          [self addSubview:button];
          
          xOffset += 2 * _buttonSize;
        }
        yOffset += 2 * _buttonSize;
      }
      
      // Each click event needs to be paired with another, as the player is trying to
      // connect button nodes
      _waitingForPair = NO;
    }
    return self;
}

// Set the value of a node at a given row and column
// Change the background color to green when it has been fully connected, otherwise make it black
// Called on intialization, so changing background to black is needed then
// Also if player undoes a connection of a green node
-(void)setNodeValueAtRow:(int)row AndColumn:(int)col toValue:(int) value
{
  UIButton* button = [[_buttonGrid objectAtIndex:row] objectAtIndex:col];
  [button setTitle:[NSString stringWithFormat:@"%d", value] forState:UIControlStateNormal];
  
  NSLog(@"%d", value);
  if (value == 0) {
    [button setBackgroundColor:[UIColor greenColor]];
  } else {
    [button setBackgroundColor:[UIColor blackColor]];
  }
  
  [button addTarget:self action:@selector(complicatedAsAllHell:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)complicatedAsAllHell:(id)sender
{
  UIButton* button = (UIButton*)sender;
  // Has button been clicked previously to this?
  // If not, set button to be highlighted, wait
  if (!_waitingForPair) {
    [button setBackgroundColor:[UIColor blueColor]];
    _lastButtonPressed = button;
    _waitingForPair = YES;
  } else {
    // Otherwise, see if current button and last button can be connected
    int oldRow = floor(_lastButtonPressed.tag / 10);
    int oldCol = _lastButtonPressed.tag % 10;
    int row = floor(button.tag / 10);
    int col = button.tag % 10;
    
    [_lastButtonPressed setBackgroundColor:[UIColor blackColor]];
    _waitingForPair = NO;
    
    if ([self.delegate checkConnectionValidBetweenRow:oldRow Col:oldCol AndRow:row Col:col]) {
      
      NSInteger tag1, tag2;
      if (_lastButtonPressed.tag < button.tag) {
        tag1 = _lastButtonPressed.tag;
        tag2 = button.tag;
      } else {
        tag2 = _lastButtonPressed.tag;
        tag1 = button.tag;
      }
      NSInteger numConnections = [self.delegate createConnectionBetweenRow:oldRow Col:oldCol AndRow:row Col:col];
      NSString* key = [NSString stringWithFormat:@"%li%li", (long)tag1, (long)tag2];

      if (numConnections == 1) {
        [button setBackgroundColor:[UIColor blackColor]];
        CGPoint lineStart = [_lastButtonPressed center];
        CGPoint lineEnd = [button center];
        
        if (row == oldRow) {
          if (col < oldCol) {
            lineStart.x -= _buttonSize / 2.0;
            lineEnd.x += _buttonSize / 2.0;
          } else {
            lineStart.x += _buttonSize / 2.0;
            lineEnd.x -= _buttonSize / 2.0;
          }
        } else {
          if (row < oldRow) {
            lineStart.y -= _buttonSize / 2.0;
            lineEnd.y += _buttonSize / 2.0;
          } else {
            lineStart.y += _buttonSize / 2.0;
            lineEnd.y -= _buttonSize / 2.0;
          }
        }
        
        UIBezierPath* path = [UIBezierPath bezierPath];
        [path moveToPoint:lineStart];
        [path addLineToPoint:lineEnd];
      
        CAShapeLayer* shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = [path CGPath];
        shapeLayer.strokeColor = [[UIColor grayColor] CGColor];
        shapeLayer.lineWidth = 3.0;
      
        [self.viewForBaselineLayout.layer addSublayer:shapeLayer];
        NSMutableArray* lines = [[NSMutableArray alloc] initWithObjects:shapeLayer, nil];
        [_connections setValue:lines forKey:key];
        
      }
      if (numConnections == 2) {
        NSMutableArray* lines = [_connections valueForKey:key];
        [lines[0] removeFromSuperlayer];
        
        CGPoint LineOneStart, LineOneEnd, LineTwoStart, LineTwoEnd;
        
        // Vertical line
        if (col == oldCol) {
          // Set the lines to be at 1/4 and 3/4 along the button
          LineOneStart.x = [_lastButtonPressed center].x + _buttonSize / 4.0;
          LineOneEnd.x = [button center].x + _buttonSize / 4.0;
          LineTwoStart.x = LineOneStart.x - _buttonSize / 2.0;
          LineTwoEnd.x = LineOneEnd.x - _buttonSize / 2.0;
          
          if (row < oldRow) {
            LineOneStart.y = [_lastButtonPressed center].y - _buttonSize / 2.0;
            LineOneEnd.y = [button center].y + _buttonSize / 2.0;
          } else {
            LineOneStart.y = [_lastButtonPressed center].y + _buttonSize / 2.0;
            LineOneEnd.y = [button center].y - _buttonSize / 2.0;
          }
          LineTwoStart.y = LineOneStart.y;
          LineTwoEnd.y = LineOneEnd.y;

        } else {
          // Horizontal line
          LineOneStart.y = [_lastButtonPressed center].y + _buttonSize / 4.0;
          LineOneEnd.y = [button center].y + _buttonSize / 4.0;
          LineTwoStart.y = LineOneStart.y - _buttonSize / 2.0;
          LineTwoEnd.y = LineOneEnd.y - _buttonSize / 2.0;
          
          if (col < oldCol) {
            LineOneStart.x = [_lastButtonPressed center].x - _buttonSize / 2.0;
            LineOneEnd.x = [button center].x + _buttonSize / 2.0;
          } else {
            LineOneStart.x = [_lastButtonPressed center].x + _buttonSize / 2.0;
            LineOneEnd.x = [button center].x - _buttonSize / 2.0;
          }

          LineTwoStart.x = LineOneStart.x;
          LineTwoEnd.x = LineOneEnd.x;
        }

        UIBezierPath* path = [UIBezierPath bezierPath];
        [path moveToPoint:LineOneStart];
        [path addLineToPoint:LineOneEnd];
        
        CAShapeLayer* shapeLayer1 = [CAShapeLayer layer];
        shapeLayer1.path = [path CGPath];
        shapeLayer1.strokeColor = [[UIColor grayColor] CGColor];
        shapeLayer1.lineWidth = 3.0;
        
        [self.viewForBaselineLayout.layer addSublayer:shapeLayer1];
        [lines addObject:shapeLayer1];
        
        path = [UIBezierPath bezierPath];
        [path moveToPoint:LineTwoStart];
        [path addLineToPoint:LineTwoEnd];
        
        CAShapeLayer* shapeLayer2 = [CAShapeLayer layer];
        shapeLayer2.path = [path CGPath];
        shapeLayer2.strokeColor = [[UIColor grayColor] CGColor];
        shapeLayer2.lineWidth = 3.0;
        
        [self.viewForBaselineLayout.layer addSublayer:shapeLayer2];
        [lines addObject:shapeLayer2];
        
        lines = [[NSMutableArray alloc] initWithObjects:shapeLayer1, shapeLayer2, nil];
        [_connections setValue:lines forKey:key];
      }
      if (numConnections == 0) {
        NSMutableArray* lines = [_connections valueForKey:key];
        for (int i = 0; i < [lines count]; i++) {
          [lines[i] removeFromSuperlayer];
        }
      }
    }
  }
}
@end
