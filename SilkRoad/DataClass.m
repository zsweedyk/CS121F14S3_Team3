//
//  DataClass.m
//  SilkRoad
//
//  Created by Sarah Trisorus on 12/6/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import "DataClass.h"

@implementation DataClass

static DataClass *instance = nil;

+(DataClass*)getInstance
{
  @synchronized(self) {
    if (instance == nil) {
      instance = [DataClass new];
      [instance setSoundOn:YES];
    }
  }
  
  return instance;
}

@end
