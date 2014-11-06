//
//  ScalesGameCoin.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/22/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "ScalesGameCoin.h"

@implementation ScalesGameCoin

- (id)init {
  self = [super init];
  
  if (self) {
    [self setName:@"Coin 0"];
    [self setWeight:1];
  }
  
  return self;
}

@end
