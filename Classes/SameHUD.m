//
//  SameHUD.m
//  Same
//
//  Created by Tim Horton on 2009.04.06.
//  Copyright 2009 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "SameHUD.h"

@implementation SameHUD

void CGContextAddRoundedRect(CGContextRef c, CGRect rect, int corner_radius)
{
	int x_left = rect.origin.x;
	int x_left_center = rect.origin.x + corner_radius;
	int x_right_center = rect.origin.x + rect.size.width - corner_radius;
	int x_right = rect.origin.x + rect.size.width;
	int y_top = rect.origin.y;
	int y_top_center = rect.origin.y + corner_radius;
	int y_bottom_center = rect.origin.y + rect.size.height - corner_radius;
	int y_bottom = rect.origin.y + rect.size.height;
	
	/* Begin! */
	CGContextBeginPath(c);
	CGContextMoveToPoint(c, x_left, y_top_center);
	
	/* First corner */
	CGContextAddArcToPoint(c, x_left, y_top, x_left_center, y_top, corner_radius);
	CGContextAddLineToPoint(c, x_right_center, y_top);
	
	/* Second corner */
	CGContextAddArcToPoint(c, x_right, y_top, x_right, y_top_center, corner_radius);
	CGContextAddLineToPoint(c, x_right, y_bottom_center);
	
	/* Third corner */
	CGContextAddArcToPoint(c, x_right, y_bottom, x_right_center, y_bottom, corner_radius);
	CGContextAddLineToPoint(c, x_left_center, y_bottom);
	
	/* Fourth corner */
	CGContextAddArcToPoint(c, x_left, y_bottom, x_left, y_bottom_center, corner_radius);
	CGContextAddLineToPoint(c, x_left, y_top_center);
	
	/* Done */
	CGContextClosePath(c);
	
}

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
		[self addSubview:titleLabel];
		
		scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, frame.size.width, 40)];
		scoreLabel.backgroundColor = [UIColor clearColor];
		scoreLabel.textColor = [UIColor whiteColor];
		scoreLabel.textAlignment = UITextAlignmentCenter;
		scoreLabel.font = [UIFont systemFontOfSize:24];
		scoreLabel.text = @"Game Won!";
		[self addSubview:scoreLabel];
		
		NSArray *segmentTextContent = [NSArray arrayWithObjects:@"Play Again", nil];
		UISegmentedControl* segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
		segmentedControl.frame = CGRectMake(15, frame.size.height - 60, frame.size.width - 30, 44);
		segmentedControl.momentary = YES;
		segmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment;
		segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		segmentedControl.segmentedControlStyle = UISegmentedControlStyleBordered;
		[segmentedControl addTarget:self action:@selector(hideHUD:) forControlEvents:UIControlEventValueChanged];
		[self addSubview:segmentedControl];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGRect drawRect = CGRectInset([self bounds], 10, 10);
	
	CGContextSaveGState(context);
	CGContextSetLineWidth(context, 2);
	CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.85);
	CGContextSetRGBStrokeColor(context, 0.9, 0.9, 0.9, 0.5);
	CGContextAddRoundedRect(context, drawRect, 10);
	CGContextDrawPath(context, kCGPathFillStroke);
	CGContextRestoreGState(context);
}

- (void)showHUDWithPoints:(int)points gameWon:(int)won
{
	titleLabel.text = won ? @"Game Won!" : @"Game Over!";
	scoreLabel.text = [NSString stringWithFormat:@"%d points", points];
	
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
		[[self superview] dismissedHUD];
	}
}


- (void)dealloc
{
	[super dealloc];
}


@end
