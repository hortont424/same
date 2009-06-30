//
//  SameMenuButton.m
//  Same
//
//  Created by Timothy Horton on 2009.06.30.
//  Copyright 2009 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "SameMenuButton.h"
#import "RoundedRect.h"

@implementation SameMenuButton

@synthesize title;

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		self.userInteractionEnabled = YES;
		selected = NO;
	}
	return self;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGRect drawRect = CGRectInset([self bounds], 3, 3);
	
	CGContextSaveGState(context);
	
	CGContextSetLineWidth(context, 2);
	
	if(selected)
	{
		CGContextSetRGBStrokeColor(context, 0.9, 0.9, 0.9, 0.5);
		CGContextSetRGBFillColor(context, 0.2, 0.2, 0.2, 1.0);
	}
	else
	{
		CGContextSetRGBStrokeColor(context, 0.9, 0.9, 0.9, 0.5);
		CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
	}
	
	CGContextAddRoundedRect(context, drawRect, 10);
	CGContextDrawPath(context, kCGPathFillStroke);
	
	[[UIColor whiteColor] set];
	[title drawInRect:CGRectInset(rect, 0, 12) withFont:[UIFont boldSystemFontOfSize:20.0] lineBreakMode:UILineBreakModeMiddleTruncation alignment:UITextAlignmentCenter];
	
	CGContextRestoreGState(context);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	selected = YES;
	
	[self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	selected = [self pointInside:[[touches anyObject] locationInView:self] withEvent:event];
	
	[self setNeedsDisplay];
		
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(selected)
		[self sendActionsForControlEvents:UIControlEventTouchUpInside];
	
	selected = NO;
	
	[self setNeedsDisplay];
}

@end
