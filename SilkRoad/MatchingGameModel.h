//
//  MatchingGameModel.h
//  SilkRoad
//
//  Created by CS121 on 10/11/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchingGameModel : NSObject

-(void)initializeGameForLevel:(int)level;
-(NSMutableArray*)getLeftSidePhrases;
-(NSMutableArray*)getRightSidePhrases;
-(BOOL)checkMatchBetweenLeftPhrase:(NSString*)leftPhrase andRightPhrase:(NSString*)rightPhrase;

@end
