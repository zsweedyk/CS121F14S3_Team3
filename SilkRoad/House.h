//
//  House.h
//  SilkRoad
//
//  Created by Melissa Galonsky on 10/21/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface House : NSObject

@property BOOL visited;
@property NSString* label;
@property CGFloat xCord;
@property CGFloat yCord;
@property UIImage* image;

@end