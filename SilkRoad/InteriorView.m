//
//  InteriorView.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "InteriorView.h"

@implementation InteriorView {
  UIButton *_dialogueBox;
  UILabel *_characterBox;
}

-(id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  
  if (self) {
    // Set the background image
    [self setInteriorBGTo:@"default"];
    [self setCharacterTo:@"Lisa" withImage:[UIImage imageNamed:@"IndianWoman1"]];
    
    // Create the dialogue box
    [self initDialogueBox];
    
    // Create the character box
    [self initCharacterBox];
  }
  
  return self;
}

-(void)initDialogueBox
{
  // Get interior frame dimensions
  CGRect frame = self.frame;
  CGFloat frameWidth = CGRectGetWidth(frame);
  CGFloat frameHeight = CGRectGetHeight(frame);
  
  // Make dialogue box 20% the height of the frame and 100% the width,
  //   with padding equal to 5% of the width on either side
  int dialogueBoxPadding = frameWidth * 0.05;
  int dialogueBoxHeight = frameHeight * 0.20;
  int dialogueBoxWidth = frameWidth - (5.5 * dialogueBoxPadding);
  
  // The x-offset is equal to the horizontal padding
  // The y-offset is equal to the height of the interior frame, minus the
  //   height of the dialogue box (including padding)
  int dialogueBoxXOffset = dialogueBoxPadding;
  int dialogueBoxYOffset = frameHeight - (dialogueBoxHeight + dialogueBoxPadding);
  CGRect dialogueBoxFrame = CGRectMake(dialogueBoxXOffset, dialogueBoxYOffset, dialogueBoxWidth, dialogueBoxHeight);
  
  // Add the box to the subview
  _dialogueBox = [[UIButton alloc] initWithFrame:dialogueBoxFrame];
  
  // Set background color to offwhite
  [_dialogueBox setBackgroundColor:[[UIColor alloc] initWithRed:0.98 green:0.94 blue:0.89 alpha:1]];
  [_dialogueBox setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
  
  // Create border
  [[_dialogueBox layer] setBorderWidth:3.0f];
  [[_dialogueBox layer] setBorderColor:[UIColor brownColor].CGColor];
  
  // Top and left align text in dialogue box, let it be multiline
  [_dialogueBox.titleLabel setAdjustsFontSizeToFitWidth:NO];
  [_dialogueBox.titleLabel setNumberOfLines:0];
  _dialogueBox.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
  _dialogueBox.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
  
  // Add padding around text
  _dialogueBox.contentEdgeInsets= UIEdgeInsetsMake(30, 30, 30, 30);
  _dialogueBox.titleLabel.font = [UIFont systemFontOfSize:24];
  
  [self addSubview:_dialogueBox];
  
  [_dialogueBox addTarget:self action:@selector(progressDialogue) forControlEvents:UIControlEventTouchUpInside];
}

-(void)initCharacterBox
{
  // Get interior frame dimensions
  CGRect frame = self.frame;
  CGFloat frameWidth = CGRectGetWidth(frame);
  CGFloat frameHeight = CGRectGetHeight(frame);
  
  // Make character box 40% the height of the frame and 20% the width,
  //   with padding equal to 5% of the width on either side
  int characterBoxPadding = frameWidth * 0.05;
  int characterBoxHeight = frameHeight * 0.60;
  int characterBoxWidth = frameWidth * 0.30;
  
  // The x-offset is equal to the width of the frame, minus the width of the
  //   character box (including padding)
  // The y-offset is equal to the height of the interior frame, minus the
  //   height of the character box
  int characterBoxXOffset = frameWidth - (characterBoxWidth);
  int characterBoxYOffset = frameHeight - characterBoxHeight;
  CGRect characterBoxFrame = CGRectMake(characterBoxXOffset, characterBoxYOffset, characterBoxWidth, characterBoxHeight);
  
  // Add the box to the subview
  _characterBox = [[UILabel alloc] initWithFrame:characterBoxFrame];
  [self addSubview:_characterBox];
}

-(void)setInteriorBGTo:(NSString*)backgroundName
{
  if ([backgroundName isEqual:@"default"]) {
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mohenjodaro.jpg"]]];
  }
  else {
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:backgroundName]]];
  }
}

-(void)setCharacterTo:(NSString*)characterName withImage:(UIImage*)image
{
  CGSize imgSize = _characterBox.frame.size;
  
  UIGraphicsBeginImageContext(imgSize);
  [image drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
  UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
    [_characterBox setBackgroundColor:[UIColor colorWithPatternImage:newImage]];
}

-(void)setDialogueTextTo:(NSString*)dialogueText
{
  [_dialogueBox setTitle:dialogueText forState:UIControlStateNormal];
}

-(void)progressDialogue
{
  [UIView animateWithDuration:0.5 animations:^{_dialogueBox.titleLabel.alpha = 0.0;}];
  [self.delegate progressDialogue];
  [UIView animateWithDuration:0.5 animations:^{_dialogueBox.titleLabel.alpha = 1;}];
}

-(void)endOfDialogue
{
  // TODO: Temporarily let clicking on the dialogue box go to the minigame
  [self.delegate enterMinigame];
}

@end
