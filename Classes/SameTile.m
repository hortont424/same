/* Same for iPhone OS
 *
 * Copyright 2010 Tim Horton. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *    1. Redistributions of source code must retain the above copyright notice,
 *       this list of conditions and the following disclaimer.
 *
 *    2. Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY TIM HORTON "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 * EVENT SHALL TIM HORTON OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "SameTile.h"
#import "SameTileImages.h"
#import "SameView.h"

@implementation SameTile

@synthesize color, visited, state, x, y;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
	{
		UIImage * colorImage;
		
		state = YES;
		visited = NO;
		color = arc4random() % 3;
		
		switch(color)
		{
			case 0: colorImage = [[SameTileImages shared] redImage]; break;
			case 1: colorImage = [[SameTileImages shared] greenImage]; break;
			case 2: colorImage = [[SameTileImages shared] blueImage]; break;
			case 3: colorImage = [[SameTileImages shared] yellowImage]; break;
			default: colorImage = [[SameTileImages shared] redImage]; break;
		}
		
		[colorImage retain];
		
		self.userInteractionEnabled = NO;
		self.layer.opacity = 0.8;
		self.opaque = YES;
		self.backgroundColor = [UIColor clearColor];
		
		imageView = [[UIImageView alloc] initWithImage:colorImage];
		imageView.frame = CGRectMake(0,0,32,32);
		imageView.opaque = YES;
		imageView.backgroundColor = [UIColor clearColor];
		[self addSubview:imageView];
    }
    return self;
}

- (void)closeTile
{
	state = NO;
	
	CABasicAnimation * outAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
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
	[(SameView*)[self superview] animationStart];
}

- (void)hideTile
{
	state = NO;
	self.layer.opacity = 0.2;
}

- (void)moveTo:(CGPoint)pt
{
	CABasicAnimation * moveXAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
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
	globalNewPt = pt;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
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
}


@end
