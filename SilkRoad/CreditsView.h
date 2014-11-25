//
//  CreditsView.h
//  SilkRoad
//
//  Created by Sarah Trisorus on 11/22/14.
//  Copyright (c) 2014 Kate Finlay, Melissa Galonsky, Rachel Macfarlane, and Sarah Trisorus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreditsProtocol
-(void)hideCredits;
@end

@interface CreditsView : UIView

@property (assign, nonatomic) id <CreditsProtocol> delegate;

@end
