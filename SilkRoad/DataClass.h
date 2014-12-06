//
//  DataClass.h
//  SilkRoad
//
//  Created by Sarah Trisorus on 12/6/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataClass : NSObject

@property (assign, nonatomic) BOOL soundOn;

+(DataClass*)getInstance;

@end
