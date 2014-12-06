//
//  CreditsView.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 11/22/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "CreditsView.h"

@implementation CreditsView

-(id)initWithFrame:(CGRect)frame
{
  NSLog(@"Showing the credits!");
  self = [super initWithFrame:frame];
  
  if (self) {
    // Set the background
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"silkroadsplash"]]];
    // Read the credits text from the file
    NSString *path;
    NSError *error;
    
    path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Credits"] ofType:@"txt"];
    
    NSString *creditString = [[NSString alloc] initWithContentsOfFile:path
                                                              encoding:NSUTF8StringEncoding error:&error];
    
    CGFloat frameWidth = CGRectGetWidth(frame);
    CGFloat frameHeight = CGRectGetHeight(frame);

    // Create the label with the credits text
    CGRect creditFrame = CGRectMake(0.05*frameWidth, 0.05*frameHeight, 0.80*frameWidth, 0.80*frameHeight);
    UILabel *creditText = [[UILabel alloc] initWithFrame:creditFrame];
    [creditText setTextColor:[UIColor blackColor]];
    [creditText setNumberOfLines:0];
    [creditText setPreferredMaxLayoutWidth:0.80*frameWidth];
    [creditText setText:creditString];
    [creditText sizeToFit];
    
    // Create a scrolling view for the credits text
    creditFrame = CGRectMake(0.05*frameWidth, 0.05*frameHeight, 0.90*frameWidth, 0.90*frameHeight);
    UIScrollView *creditBox = [[UIScrollView alloc] initWithFrame:creditFrame];
    [creditBox setContentSize:CGSizeMake(creditText.frame.size.width, creditText.frame.size.height)];
    [creditBox setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.65]];
    
    [self addSubview:creditBox];
    [creditBox addSubview:creditText];
    
    // Create the back button
     UIButton *backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton addTarget:self action:@selector(returnToMenu) forControlEvents:UIControlEventTouchUpInside];
    [backButton setHidden:NO];
    [self addSubview:backButton];
  }
  
  return self;
}

-(void)returnToMenu
{
  NSLog(@"Go back to the menu");
  [self.delegate hideCredits];
}

@end
