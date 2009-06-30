//
//  SameMenu.m
//  Same
//
//  Created by Timothy Horton on 2009.06.30.
//  Copyright 2009 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "SameMenu.h"
#import "RoundedRect.h"
#import "SameMenuButton.h"
#import "SameView.h"

@implementation SameMenu

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		CGRect drawRect = CGRectInset([self bounds], 30, 40);
		
		UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, frame.size.width, 45)];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.textColor = [UIColor whiteColor];
		titleLabel.textAlignment = UITextAlignmentCenter;
		titleLabel.font = [UIFont boldSystemFontOfSize:48.0];
		//titleLabel.shadowColor = [UIColor blackColor];
		//titleLabel.shadowOffset = CGSizeMake(-1, 1);
		titleLabel.text = @"SAME";
		[self addSubview:titleLabel];
		
		SameMenuButton * newGameButton = [[SameMenuButton alloc] initWithFrame:CGRectMake(drawRect.origin.x + 30, 150, 200, 50)];
		newGameButton.backgroundColor = [UIColor clearColor];
		newGameButton.title = @"Normal Game";
		[newGameButton addTarget:self action:@selector(newNormalGame:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:newGameButton];
		
		SameMenuButton * newTimedGameButton = [[SameMenuButton alloc] initWithFrame:CGRectMake(drawRect.origin.x + 30, 220, 200, 50)];
		newTimedGameButton.backgroundColor = [UIColor clearColor];
		newTimedGameButton.title = @"Timed Game";
		[newTimedGameButton addTarget:self action:@selector(newNormalGame:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:newTimedGameButton];
		
		SameMenuButton * preferencesButton = [[SameMenuButton alloc] initWithFrame:CGRectMake(drawRect.origin.x + 30, 290, 200, 50)];
		preferencesButton.backgroundColor = [UIColor clearColor];
		preferencesButton.title = @"Settings";
		[preferencesButton addTarget:self action:@selector(newNormalGame:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:preferencesButton];
	}
	return self;
}

- (void)newNormalGame:(id)sender
{
	NSLog(@"new normal game");
	
	SameView * sv = [[SameView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	sv.userInteractionEnabled = YES;
	[[self window] addSubview:sv];
	[[self window] sendSubviewToBack:sv];
	
	CABasicAnimation * fin = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fin.duration = 1.0;
	fin.fromValue = [NSNumber numberWithFloat:1.0];
	fin.toValue = [NSNumber numberWithFloat:0.0];
	fin.removedOnCompletion = NO;
	fin.fillMode  = kCAFillModeForwards;
	fin.delegate = self;
	[self.layer addAnimation:fin forKey:@"fin"];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	if(theAnimation == [self.layer animationForKey:@"fin"])
	{
		self.layer.opacity = 0.0;
		[self.layer removeAnimationForKey:@"fin"];
		self.userInteractionEnabled = NO;
	}
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
	CGContextFillRect(context, rect);
	
	CGRect drawRect = CGRectInset([self bounds], 30, 40);
	
	CGContextSaveGState(context);
	
	CGContextAddRoundedRect(context, drawRect, 10);
	CGContextClip(context);
	
	CGGradientRef myGradient;
	CGColorSpaceRef myColorspace;
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 1.0 };
	//CGFloat components[8] = { 0.24, 0.30, 0.48, 1.0,  // Start color
	//                          0.06, 0.07, 0.12, 1.0 }; // End color
	
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
	
	CGContextRestoreGState(context);
}

@end
