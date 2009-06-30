//
//  SameHUD.m
//  Same
//
//  Created by Tim Horton on 2009.04.06.
//  Copyright 2009 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "SameHUD.h"
#import "SameAppDelegate.h"
#import "SameView.h"
#import "RoundedRect.h"

@implementation SameHUD

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
	{
		self.userInteractionEnabled = YES;
		[self setOpaque:NO];
		
		titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, 45)];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.textColor = [UIColor whiteColor];
		titleLabel.textAlignment = UITextAlignmentCenter;
		titleLabel.font = [UIFont boldSystemFontOfSize:26];
		titleLabel.text = @"Same";
		[self addSubview:titleLabel];
		
		scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, frame.size.width, 40)];
		scoreLabel.backgroundColor = [UIColor clearColor];
		scoreLabel.textColor = [UIColor whiteColor];
		scoreLabel.textAlignment = UITextAlignmentCenter;
		scoreLabel.font = [UIFont systemFontOfSize:24];
		scoreLabel.text = @"Game Won!";
		[self addSubview:scoreLabel];
		
		hsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, frame.size.width, 40)];
		hsLabel.backgroundColor = [UIColor clearColor];
		hsLabel.textColor = [UIColor whiteColor];
		hsLabel.textAlignment = UITextAlignmentCenter;
		hsLabel.font = [UIFont boldSystemFontOfSize:14];
		hsLabel.text = @"HIGH SCORES";
		[self addSubview:hsLabel];
		
		continueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, frame.size.width, 40)];
		continueLabel.backgroundColor = [UIColor clearColor];
		continueLabel.textColor = [UIColor whiteColor];
		continueLabel.textAlignment = UITextAlignmentCenter;
		continueLabel.font = [UIFont boldSystemFontOfSize:18];
		continueLabel.text = @"Tap to Continue";
		[self addSubview:continueLabel];
		
		self.userInteractionEnabled = YES;
				
		self.hidden = YES;
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self hideHUD:touches];
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGRect drawRect = CGRectInset([self bounds], 10, 10);
	CGRect scoresRect = CGRectMake(40, 100, 140, 130);
	
	CGContextSaveGState(context);
	
	CGContextAddRoundedRect(context, drawRect, 10);
	CGContextClip(context);
	
	CGGradientRef myGradient;
	CGColorSpaceRef myColorspace;
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 1.0 };
	CGFloat components[8] = { 0.2, 0.2, 0.2, 1.0,  // Start color
	                          0.0, 0.0, 0.0, 1.0 }; // End color

	myColorspace = CGColorSpaceCreateDeviceRGB();
	myGradient = CGGradientCreateWithColorComponents (myColorspace, components,
	                          locations, num_locations);
	
	CGPoint myEndPoint;
	myEndPoint.x = drawRect.origin.x;
	myEndPoint.y = drawRect.origin.y + drawRect.size.height;
	CGContextDrawLinearGradient(context, myGradient, drawRect.origin, myEndPoint, 0);
	CGGradientRelease(myGradient);
	
	CGContextRestoreGState(context);
	
	CGContextSaveGState(context);
	
	CGContextSetLineWidth(context, 2);
	CGContextSetRGBStrokeColor(context, 0.9, 0.9, 0.9, 0.5);
	CGContextAddRoundedRect(context, drawRect, 10);
	CGContextDrawPath(context, kCGPathStroke);
	CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
	CGContextSetRGBStrokeColor(context, 0.9, 0.9, 0.9, 0.3);
	CGContextSetLineWidth(context, 1);
	CGContextAddRoundedRect(context, scoresRect, 10);
	CGContextDrawPath(context, kCGPathFillStroke);
	
	CGContextRestoreGState(context);
}

- (void)showHUDWithPoints:(int)points gameWon:(int)won
{
	[titleLabel.text release];
	[scoreLabel.text release];
	
	titleLabel.text = won ? @"Game Won!" : @"Game Over!";
	scoreLabel.text = [NSString stringWithFormat:@"%d points", points];
	
	NSMutableArray * scores = [(id)[[UIApplication sharedApplication] delegate] scores];
	int y = 0;
	
	for(NSNumber * score in scores)
	{
		UILabel * l = [[UILabel alloc] initWithFrame:CGRectMake(0, 130 + (18 * y), [self frame].size.width, 18)];
		l.backgroundColor = [UIColor clearColor];
		l.textColor = [UIColor whiteColor];
		l.layer.opacity = ([score intValue] == points) ? 1.0 : 0.5;
		l.textAlignment = UITextAlignmentCenter;
		l.font = [UIFont systemFontOfSize:14];
		l.text = [NSString stringWithFormat:@"%d points", [score intValue]];
		[self addSubview:l];
		y++;
	}
	
	self.hidden = NO;
	
	CABasicAnimation * outAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	outAnimation.duration = 0.7;
	outAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(self.layer.transform, 0.1, 0.1, 0.1)];
	outAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(self.layer.transform, 1, 1, 1)];
	outAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	outAnimation.fillMode  = kCAFillModeForwards;
	outAnimation.removedOnCompletion = NO;
	
	CABasicAnimation * fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeAnimation.duration = 0.7;
	fadeAnimation.fromValue = [NSNumber numberWithFloat:0.0];
	fadeAnimation.toValue = [NSNumber numberWithFloat:1.0];
	outAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	fadeAnimation.removedOnCompletion = NO;
	fadeAnimation.fillMode  = kCAFillModeForwards;
	fadeAnimation.delegate = self;
	
	[self.layer addAnimation:outAnimation forKey:@"out"];
	[self.layer addAnimation:fadeAnimation forKey:@"fade"];
}

- (void)hideHUD:(id)sender
{
	CABasicAnimation * outAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	outAnimation.duration = 0.7;
	outAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(self.layer.transform, 1, 1, 1)];
	outAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(self.layer.transform, .1, .1, .1)];
	outAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	outAnimation.fillMode  = kCAFillModeForwards;
	outAnimation.removedOnCompletion = NO;
	
	CABasicAnimation * fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeAnimation.duration = 0.7;
	fadeAnimation.fromValue = [NSNumber numberWithFloat:1.0];
	fadeAnimation.toValue = [NSNumber numberWithFloat:0.0];
	outAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	fadeAnimation.removedOnCompletion = NO;
	fadeAnimation.fillMode  = kCAFillModeForwards;
	fadeAnimation.delegate = self;
	
	[self.layer removeAnimationForKey:@"out"];
	[self.layer removeAnimationForKey:@"fade"];
	
	[self.layer addAnimation:outAnimation forKey:@"hide-out"];
	[self.layer addAnimation:fadeAnimation forKey:@"hide-fade"];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	if(theAnimation == [self.layer animationForKey:@"hide-fade"])
	{
		[delegate dismissedHUD];
		[self.layer removeAllAnimations];
	}
}


- (void)dealloc
{
	[titleLabel removeFromSuperview];
	[titleLabel release];
	
	[scoreLabel removeFromSuperview];
	[scoreLabel release];
	
	[hsLabel removeFromSuperview];
	[hsLabel release];
	
	[segmentedControl removeFromSuperview];
	[segmentedControl release];
	
	[super dealloc];
}

@end
