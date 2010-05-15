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

#import "SameMenu.h"
#import "RoundedRect.h"
#import "SameMenuButton.h"
#import "SameView.h"
#import "SameViewController.h"

@implementation SameMenu

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        CGRect drawRect = CGRectInset([self bounds], 30, 40);
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, frame.size.width, 45)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:48.0];
        //titleLabel.shadowColor = [UIColor blackColor];
        //titleLabel.shadowOffset = CGSizeMake(-1, 1);
        titleLabel.text = @"SAME";
        [self addSubview:titleLabel];
        
        SameMenuButton * newGameButton = [[SameMenuButton alloc] initWithFrame:CGRectMake(drawRect.origin.x + 30, 140, 200, 50)];
        newGameButton.backgroundColor = [UIColor clearColor];
        newGameButton.title = @"Normal Game";
        [newGameButton addTarget:self action:@selector(newNormalGame:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:newGameButton];
        
        SameMenuButton * newTimedGameButton = [[SameMenuButton alloc] initWithFrame:CGRectMake(drawRect.origin.x + 30, 210, 200, 50)];
        newTimedGameButton.backgroundColor = [UIColor clearColor];
        newTimedGameButton.title = @"Timed Game";
        [newTimedGameButton addTarget:self action:@selector(newTimedGame:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:newTimedGameButton];
        
        SameMenuButton * scoresButton = [[SameMenuButton alloc] initWithFrame:CGRectMake(drawRect.origin.x + 30, 280, 200, 50)];
        scoresButton.backgroundColor = [UIColor clearColor];
        scoresButton.title = @"Scores";
        [scoresButton addTarget:self action:@selector(newNormalGame:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:scoresButton];
        
        SameMenuButton * preferencesButton = [[SameMenuButton alloc] initWithFrame:CGRectMake(drawRect.origin.x + 30, 350, 200, 50)];
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
    
    SameView * sv = (SameView*)[[SameViewController new] view];
    sv.userInteractionEnabled = YES;
    sv.timed = NO;
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

- (void)newTimedGame:(id)sender
{
    NSLog(@"new timed game");
    
    SameView * sv = (SameView*)[[SameViewController new] view];
    sv.userInteractionEnabled = YES;
    sv.timed = YES;
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
    
    CGFloat components[8] = { 0.2, 0.2, 0.2, 1.0,
                              0.0, 0.0, 0.0, 1.0 };
    
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
    
    CGGradientRelease(myGradient);
}

@end
