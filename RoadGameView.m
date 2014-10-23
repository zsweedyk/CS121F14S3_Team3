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
      CGFloat buttonSize = MIN(horizontalPadding, verticalPadding);
      
      // Initialize the button grid
      _buttonGrid = [[NSMutableArray alloc] initWithCapacity:9];
      
      // Add buttons to the grid, tag is a two digit number with the first number
      // representing row, and the second column. The space between buttons is
      // equal to the size of a button.
      for (int row = 0; row < 9; row++) {
        [_buttonGrid addObject:[[NSMutableArray alloc] initWithCapacity:9]];
        CGFloat xOffset = horizontalPadding;
        
        for (int col = 0; col < 9; col++) {
          CGRect buttonFrame = CGRectMake(xOffset, yOffset, buttonSize, buttonSize);
          UIButton* button = [[UIButton alloc] initWithFrame:buttonFrame];
          
          [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
          [button setTag: row * 10 + col];
          
          [[_buttonGrid objectAtIndex:row] addObject:button];
          [self addSubview:button];
          
          xOffset += 2 * buttonSize;
        }
        yOffset += 2 * buttonSize;
      }
      
      // Each click event needs to be paired with another, as the player is trying to
      // connect button nodes
      _waitingForPair = NO;
    }
    return self;
}

-(void)setNodeValueAtRow:(int)row AndColumn:(int)col toValue:(int) value
{
  UIButton* button = [[_buttonGrid objectAtIndex:row] objectAtIndex:col];
  [button setTitle:[NSString stringWithFormat:@"%d", value] forState:UIControlStateNormal];
  [button setBackgroundColor:[UIColor redColor]];
  [button addTarget:self action:@selector(complicatedAsAllHell:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)complicatedAsAllHell:(id)sender
{
  UIButton* button = (UIButton*)sender;
  [button setBackgroundColor:[UIColor blueColor]];
  // Has button been clicked previously to this?
  // If not, set button to be highlighted, wait
  if (!_waitingForPair) {
    _lastButtonPressed = button;
    _waitingForPair = YES;
  } else {
    // Otherwise, see if current button and last button can be connected
    int oldRow = _lastButtonPressed.tag / 10;
    int oldCol = _lastButtonPressed.tag % 10;
    int row = button.tag / 10;
    int col = button.tag % 10;
    if ([self.delegate checkConnectionValidBetweenRow:oldRow Col:oldCol AndRow:row Col:col]) {
      [_lastButtonPressed setBackgroundColor:[UIColor redColor]];
      [button setBackgroundColor:[UIColor redColor]];
      
      UIBezierPath* path = [UIBezierPath bezierPath];
      [path moveToPoint:[_lastButtonPressed center]];
      [path addLineToPoint:[button center]];
      
      CAShapeLayer* shapeLayer = [CAShapeLayer layer];
      shapeLayer.path = [path CGPath];
      shapeLayer.strokeColor = [[UIColor grayColor] CGColor];
      shapeLayer.lineWidth = 3.0;
      
      [self.viewForBaselineLayout.layer addSublayer:shapeLayer];
      
    }
    _waitingForPair = NO;
  }
  
  // If not, dehighlight both
  // If yes, dehighlight both and add line between them
}
@end
