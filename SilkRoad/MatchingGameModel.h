//
//  MatchingGameModel.h
//  SilkRoad
//
//  Created by CS121 on 10/11/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchingGameModel : NSObject

-(void)initializePhrasesAndMatches;
-(NSMutableArray*)getLeftSidePhrases;
-(NSMutableArray*)getRightSidePhrases;

@end
