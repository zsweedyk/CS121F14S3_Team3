//
//  MatchingGameView.h
//  SilkRoad
//
//  Created by CS121 on 10/11/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@protocol MatchingGameProtocol
-(void) exitMinigame:(BOOL)won;
-(void) checkForMatchWithLeftPhrase:(NSString*)leftPhrase andRightPhrase:(NSString*)rightPhrase;
@end

@interface MatchingGameView : UIView

@property (assign, nonatomic) id <MatchingGameProtocol> delegate;

-(id)initWithFrame:(CGRect)frame leftSidePhrases:(NSMutableArray*)leftSide andRightSidePhrases:(NSMutableArray*)rightSide;
-(void)matchFound:(BOOL)match;

@end