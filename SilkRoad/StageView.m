//
//  StageView.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "StageView.h"

@interface StageView()
{
    NSMutableArray* _houseButtons;
    
    
}
@end


@implementation StageView

const CGFloat tempButtonSize = 100;


//Creates the view and adds the background
-(id)initWithFrame:(CGRect)frame background:(UIImage*)background
{
    UIImageView* backgroundView = [[UIImageView alloc] initWithImage:background];
    self = [super initWithFrame:frame];
    backgroundView.frame = frame;
    [self addSubview:backgroundView];

    return self;
}

// Convert the UIImage to a UIButton, set up target action, and add the button to the array of house buttons
-(void)createHouseWithImage:(UIImage*)image atXCoord:(CGFloat)x andYCoord:(CGFloat)y withLabel:(NSString*)label tag:(NSInteger)tag
{
    
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    NSLog(@"Creating a button at coords (%f, %f) with size (%f, %f", x, y, tempButtonSize, tempButtonSize);
    CGRect buttonFrame = CGRectMake(x, y, width/2.3, height/2.3);
    UIButton* house = [[UIButton alloc] initWithFrame:buttonFrame];
    [house setBackgroundImage:image forState:UIControlStateNormal];
    [house setTitle:label forState:UIControlStateNormal];
    [house setTag:tag];
    
    [house addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:house];
    [_houseButtons addObject:house];
}


// Loop over every house and call create house with image
-(void)loadNewStageWithHouses: (NSMutableArray*) houses
{
    House* currHouse;
    for (int i = 0; i < [houses count]; i++) {
        currHouse = [houses objectAtIndex:i];
        CGFloat xCord = currHouse.xCord;
        CGFloat yCord = currHouse.yCord;
        UIImage* image = currHouse.image;
        NSString* title = currHouse.label;
        NSInteger tag = currHouse.tag;
        [self createHouseWithImage:image atXCoord:xCord andYCoord:yCord withLabel:title tag:tag];
    }
}

-(void)buttonPressed:(id)button
{
    [_delegate buttonPressed:button];
}

@end
