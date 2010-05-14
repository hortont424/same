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
