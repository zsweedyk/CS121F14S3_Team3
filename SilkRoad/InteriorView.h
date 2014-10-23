//
//  InteriorView.h
//  SilkRoad
//
//  Created by Sarah Trisorus on 10/10/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeaveInterior
-(void)leaveInterior;
@end

@protocol EnterMinigame
-(void)enterMinigame;
@end

@protocol ProgressDialogue
-(void)progressDialogue;
@end

@interface InteriorView : UIView

@property (assign, nonatomic) id <LeaveInterior, EnterMinigame, ProgressDialogue> delegate;

-(void)setInteriorBGTo:(NSString*)backgroundName;
-(void)setCharacterTo:(NSString*)characterName withImage:(UIImage*)image;
-(void)setDialogueTextTo:(NSString*)dialogueText;

@end
