//
//  SameTile.h
//  Same
//
//  Created by Tim Horton on 2009.04.06.
//  Copyright 2009 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CoreAnimation.h>

@interface SameTile : UIView
{
	UIImageView * imageView;
	int color;
	BOOL visited;
	BOOL state;
	
	int x;
	int y;
	
	CGPoint globalNewPt;
	
	CABasicAnimation * fadeAnimation;
}

@property (nonatomic) int color;
@property (nonatomic) BOOL visited;
@property (nonatomic) BOOL state;
@property (nonatomic) int x;
@property (nonatomic) int y;

- (void)moveTo:(CGPoint)pt;
- (void)closeTile;
- (void)hideTile;
- (void)light;
- (void)unlight;

@end
