//
//  SameHUD.h
//  Same
//
//  Created by Tim Horton on 2009.04.06.
//  Copyright 2009 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CoreAnimation.h>

@interface SameHUD : UIView
{
	UILabel * titleLabel, * scoreLabel, * hsLabel, * continueLabel;
	UISegmentedControl * segmentedControl;
	
	id delegate;
}

- (void)showHUDWithPoints:(int)points gameWon:(int)won;

@property (nonatomic,assign) id delegate;

@end
