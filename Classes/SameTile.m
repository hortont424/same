//
//  SameTile.m
//  Same
//
//  Created by Tim Horton on 2009.04.06.
//  Copyright 2009 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "SameTile.h"
#import "SameTileImages.h"
#import "SameView.h"

@implementation SameTile

@synthesize color, visited, state, x, y, frame, lit, animating, newPoint, originalPoint, delta;

- (id)init
{
    if (self = [super init])
	{		
		state = YES;
		visited = NO;
		color = rand() % 3;
	}
    return self;
}

- (void)closeTile
{
	state = NO;
	
	/*CABasicAnimation * outAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	outAnimation.duration = 0.5;
	outAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(self.layer.transform, 2, 2, 2)];
	outAnimation.fillMode  = kCAFillModeForwards;
	outAnimation.removedOnCompletion = NO;
	
	fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeAnimation.duration = 0.5;
	fadeAnimation.toValue = [NSNumber numberWithFloat:0];
	fadeAnimation.removedOnCompletion = NO;
	fadeAnimation.fillMode  = kCAFillModeForwards;
	fadeAnimation.delegate = self;
	
	[self.layer addAnimation:outAnimation forKey:@"out"];
	[self.layer addAnimation:fadeAnimation forKey:@"fade"];
	[(SameView*)[self superview] animationStart];*/
}

/*- (void)hideTile
{
	state = NO;
	self.layer.opacity = 0.2;
}*/

- (void)moveTo:(CGPoint)pt
{
	/*CABasicAnimation * moveXAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
	moveXAnimation.duration = 0.5;
	moveXAnimation.toValue = [NSNumber numberWithFloat:pt.x];
	moveXAnimation.removedOnCompletion = NO;
	moveXAnimation.fillMode  = kCAFillModeForwards;
	moveXAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	moveXAnimation.delegate = self;
	
	CABasicAnimation * moveYAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
	moveYAnimation.duration = 0.5;
	moveYAnimation.toValue = [NSNumber numberWithFloat:pt.y];
	moveYAnimation.removedOnCompletion = NO;
	moveYAnimation.fillMode  = kCAFillModeForwards;
	moveYAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	
	[self.layer addAnimation:moveXAnimation forKey:@"moveX"];
	[self.layer addAnimation:moveYAnimation forKey:@"moveY"];
	[(SameView*)[self superview] animationStart];
	globalNewPt = pt;*/
	
	newPoint.x = pt.x;
	newPoint.y = pt.y;
	
	originalPoint = frame.origin;
	
	delta.x = (newPoint.x - originalPoint.x) / 20.0;
	delta.y = (newPoint.y - originalPoint.y) / 20.0;
	
	animating = YES;
}

/*- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	if(theAnimation == [self.layer animationForKey:@"fade"])
	{
		self.layer.opacity = 0.0;
		[self.layer removeAnimationForKey:@"fade"];
		[(SameView*)[self superview] animationDone];
	}
	
	if(theAnimation == [self.layer animationForKey:@"out"])
	{
		[self.layer removeAnimationForKey:@"out"];
		[self removeFromSuperview];
	}
	
	if(theAnimation == [self.layer animationForKey:@"moveX"] ||
	   theAnimation == [self.layer animationForKey:@"moveY"])
	{
		[self.layer setFrame:CGRectMake(globalNewPt.x - 16, globalNewPt.y - 16, self.frame.size.width, self.frame.size.height)];
		[self.layer removeAnimationForKey:@"moveX"];
		[self.layer removeAnimationForKey:@"moveY"];
		[(SameView*)[self superview] animationDone];
	}
}

- (void)light
{
	if(state)
		self.layer.opacity = 1.0;
}

- (void)unlight
{
	if(state)
		self.layer.opacity = 0.8;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

- (void)dealloc
{
	[imageView removeFromSuperview];
	[imageView release];
	
	[super dealloc];
}*/


@end
