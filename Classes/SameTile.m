//
//  SameTile.m
//  Same
//
//  Created by Tim Horton on 2009.04.06.
//  Copyright 2009 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "SameTile.h"
#import "SameTileImages.h"

@implementation SameTile

@synthesize color, visited, state, x, y;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
	{
		UIImage * colorImage;
		
		state = YES;
		visited = NO;
		color = rand() % 4;
		
		switch(color)
		{
			case 0: colorImage = [[SameTileImages shared] redImage]; break;
			case 1: colorImage = [[SameTileImages shared] greenImage]; break;
			case 2: colorImage = [[SameTileImages shared] blueImage]; break;
			case 3: colorImage = [[SameTileImages shared] yellowImage]; break;
			default: colorImage = [[SameTileImages shared] redImage]; break;
		}
		
		self.userInteractionEnabled = NO;
		self.layer.opacity = 0.8;
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		
		imageView = [[UIImageView alloc] initWithImage:colorImage];
		imageView.frame = CGRectMake(0,0,32,32);
		imageView.opaque = NO;
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
	globalNewPt = pt;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	if(theAnimation == fadeAnimation)
		self.layer.opacity = 0.0;
	else
		[self.layer setFrame:CGRectMake(globalNewPt.x - 16, globalNewPt.y - 16, self.frame.size.width, self.frame.size.height)];
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
    [super dealloc];
}


@end
