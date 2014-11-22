//
//  CharacterDescriptionView.h
//  SilkRoad
//
//  Created by CS121 on 11/22/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Continue
-(void)hideCharacterDescription;
@end

@interface CharacterDescriptionView : UIView

@property (assign, nonatomic) id <Continue> delegate;


-(id)initWithFrame:(CGRect)frame;
-(void)setToCivilization:(int)civilization;

@end
