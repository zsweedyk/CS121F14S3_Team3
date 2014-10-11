//
//  MatchingGameView.m
//  SilkRoad
//
//  Created by CS121 on 10/11/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "MatchingGameView.h"

// completely arbitrary right now
static int const xOffsetForLeftPhrases = 10;
static int const xOffsetForRightPhrases = 100;
static int const phraseButtonWidth = 50;
static int const phraseButtonHeight = 20;
static int const padding = 10;

@interface MatchingGameView()
{
  NSMutableArray* _leftSidePhraseButtons;
  NSMutableArray* _rightSidePhraseButtons;
}
@end

@implementation MatchingGameView

- (id)initWithFrame:(CGRect)frame leftSidePhrases:(NSMutableArray*)leftSide andRightSidePhrases:(NSMutableArray*)rightSide
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    CGFloat yOffset = padding;
    
    int count = [leftSide count];
    for (int i = 0; i < count; i++) {
      // Create a button containing a phrase on the left side
      CGRect buttonFrame = CGRectMake(xOffsetForLeftPhrases, yOffset, phraseButtonWidth, phraseButtonHeight);
      UIButton* phraseButton = [[UIButton alloc] initWithFrame:buttonFrame];
      [phraseButton setTitle:[leftSide objectAtIndex:count] forState:UIControlStateNormal];
      [_leftSidePhraseButtons addObject:phraseButton];
      [self addSubview:phraseButton];
      
      // Same for the right side
      buttonFrame = CGRectMake(xOffsetForRightPhrases, yOffset, phraseButtonWidth, phraseButtonHeight);
      phraseButton = [[UIButton alloc] initWithFrame:buttonFrame];
      [phraseButton setTitle:[rightSide objectAtIndex:count] forState:UIControlStateNormal];
      [_rightSidePhraseButtons addObject:phraseButton];
      [self addSubview:phraseButton];
      
      yOffset += phraseButtonHeight + padding;
    }
  }
  return self;
}

@end
