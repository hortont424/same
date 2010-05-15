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

#import "SameTimerView.h"
#import "RoundedRect.h"

@implementation SameTimerView

- (float)percentage
{
    return percentage;
}

- (void)setPercentage:(float)inPercentage
{
    percentage = inPercentage;
    
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect drawRect = CGRectInset([self bounds], 3, 3);
    
    CGContextSaveGState(context);
    
    CGContextSetLineWidth(context, 2);
    
    CGContextSetRGBStrokeColor(context, 0.9, 0.9, 0.9, 0.5);
    CGContextSetRGBFillColor(context, 0.2, 0.2, 0.2, 1.0);
    
    CGContextAddRoundedRect(context, drawRect, 5);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextSetRGBFillColor(context, 0.8, 0.8, 0.8, 1.0);
    
    drawRect.size.width *= percentage;
    
    if(drawRect.size.width > 5)
    {
        CGContextAddRoundedRect(context, drawRect, 5);
        CGContextDrawPath(context, kCGPathFill);
    }
    
    CGContextRestoreGState(context);
}

@end
