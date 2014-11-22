//
//  CharacterDescriptionView.m
//  SilkRoad
//
//  Created by CS121 on 11/22/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "CharacterDescriptionView.h"
#import "Constants.h"

@interface CharacterDescriptionView()
{
  UIButton* _character;
  UIButton* _description;
}

@end

@implementation CharacterDescriptionView

-(id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  
  if (self) {
    // Create the box used to hold the character
    [self initCharacterWithFrame:frame];
    
    // Create and style the box used to hold the character description
    [self initDescriptionBoxWithFrame:frame];
    
    [self initContinueButtonWithFrame:frame];
  
  }
  
  return self;
}

-(void)initContinueButtonWithFrame:(CGRect)frame
{
  CGFloat frameWidth = CGRectGetWidth(frame);
  CGFloat frameHeight = CGRectGetHeight(frame);
  
  int continueButtonHeight = frameHeight * 0.05;
  int continueButtonWidth = frameWidth * 0.10;
  
  CGRect continueButtonFrame = CGRectMake(frameWidth * 0.58, frameHeight * 0.9, continueButtonWidth, continueButtonHeight);
  UIButton* continueButton = [[UIButton alloc] initWithFrame:continueButtonFrame];
  [continueButton setTitle:@"Continue" forState:UIControlStateNormal];
  [continueButton addTarget:self action:@selector(continueToStage) forControlEvents:UIControlEventTouchUpInside];
  [continueButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [self addSubview:continueButton];

}

-(void)continueToStage
{
  [self.delegate hideCharacterDescription];
}
-(void)setToCivilization:(int)civilization
{
  // Set the background of the character button
  [self setCharacterForCivilization:civilization];
  
  // Set the text of the box based on the current civilization
  [self setDescriptionForCivilization:civilization];
}

-(void)initDescriptionBoxWithFrame:(CGRect)frame
{
  CGFloat frameWidth = CGRectGetWidth(frame);
  CGFloat frameHeight = CGRectGetHeight(frame);
  
  int descriptionHeight = frameHeight * 0.80;
  int descriptionWidth = frameWidth * 0.60;
  
  // Vertically center the description box
  int descriptionYOffset = (frameHeight - descriptionHeight) / 2.0;
  int descriptionXOffset = frameWidth * 0.32;
  CGRect descriptionFrame = CGRectMake(descriptionXOffset, descriptionYOffset, descriptionWidth, descriptionHeight);
  
  _description = [[UIButton alloc] initWithFrame:descriptionFrame];
  
  // Set background color to offwhite
  [_description setBackgroundColor:[[UIColor alloc] initWithRed:0.98 green:0.94 blue:0.89 alpha:1]];
  [_description setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
  
  // Create border
  [[_description layer] setBorderWidth:3.0f];
  [[_description layer] setBorderColor:[UIColor brownColor].CGColor];
  
  // Top and left align text in dialogue box, let it be multiline
  [_description.titleLabel setAdjustsFontSizeToFitWidth:NO];
  [_description.titleLabel setNumberOfLines:0];
  _description.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
  _description.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
  
  // Add padding around text
  _description.contentEdgeInsets= UIEdgeInsetsMake(30, 30, 30, 30);
  _description.titleLabel.font = [UIFont systemFontOfSize:24];

  [self addSubview:_description];
}

-(void)setDescriptionForCivilization:(int)civilization
{
  NSString *path;
  NSError *error;
  
  NSString* filename;
  if (civilization == INDIA) {
    filename = @"indiaDescription";
  } else {
    filename = @"chinaDescription";
  }

  path = [[NSBundle mainBundle] pathForResource:filename ofType:@"txt"];
  
  NSString* descriptionText = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
  [_description setTitle:descriptionText forState:UIControlStateNormal];
 }

-(void)initCharacterWithFrame:(CGRect)frame
{
  CGFloat frameWidth = CGRectGetWidth(frame);
  CGFloat frameHeight = CGRectGetHeight(frame);
  
  // Make character box 40% the height of the frame and 20% the width,
  //   with padding equal to 5% of the width on either side
  int characterBoxHeight = frameHeight * 0.60;
  int characterBoxWidth = frameWidth * 0.30;
  
  // The y-offset is equal to the height of the interior frame, minus the
  //   height of the character box
  int characterBoxYOffset = frameHeight - characterBoxHeight;
  CGRect characterBoxFrame = CGRectMake(0, characterBoxYOffset, characterBoxWidth, characterBoxHeight);
  
  // Add the box to the subview
  _character = [[UIButton alloc] initWithFrame:characterBoxFrame];
  
  
  [self addSubview:_character];
}

-(void)setCharacterForCivilization:(int)civilization
{
  // Set the character's picture based on the current civilization
  UIImage* characterImage;
  if (civilization == INDIA) {
    characterImage = [UIImage imageNamed:@"IndiaWoman1"];
  } else {
    characterImage = [UIImage imageNamed:@"ChineseMan1"];
  }
  [_character setBackgroundImage:characterImage forState:UIControlStateNormal];

}

@end
