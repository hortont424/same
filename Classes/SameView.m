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

#import "SameView.h"
#import "SameAppDelegate.h"

CGRect CGRectFromTilePosition(int x, int y)
{
    return CGRectMake(12+(x*33),12+(y*33),32,32);
}

int score_for_tiles(int n)
{
    if(n < 3)
        return 0;
    
    return (n - 2) * (n - 2);
}

int timedcompare(NSNumber * a, NSNumber * b, void * context)
{
    return [a compare:b];
}

int rcompare(NSNumber * a, NSNumber * b, void * context)
{
    return [b compare:a];
}

@implementation SameView

@synthesize timed;

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)animationDone
{
    animCount--;
    
    if(animCount == 0 && (([self gameWon] || [self gameCompleted]) && !hud))
    {
        if([self gameWon])
        {
            overallScore += 1000;
            
            if(!timed)
            {
                scoreLabel.text = [NSString stringWithFormat:@"%d points", overallScore];
            }
            else
            {
                overallScore = (1.0 - timerView.percentage) / 0.001 / 30.0;
            }
        }
        else
        {
            if(timed)
            {
                [self shakeReload];
                
                return;
            }
        }
        
        hud = [[SameHUD alloc] initWithFrame:CGRectInset([self bounds], 50, 75)];
        hud.delegate = self;
        hud.timed = timed;
        [[self superview] addSubview:hud];
        
        if(timed && realTimer)
        {
            [realTimer invalidate];
            realTimer = nil;
        }
        
        NSMutableArray * scores;
        
        if(timed)
            scores = [(id)[[UIApplication sharedApplication] delegate] timedScores];
        else
            scores = [(id)[[UIApplication sharedApplication] delegate] scores];

        
        [scores addObject:[NSNumber numberWithInt:overallScore]];
        
        if(timed)
            [scores sortUsingFunction:&timedcompare context:nil];
        else
            [scores sortUsingFunction:&rcompare context:nil];
        
        if([scores count] > 5)
            [scores removeLastObject];
        
        [hud showHUDWithPoints:overallScore gameWon:[self gameWon]];
        
        CABasicAnimation * fin = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fin.duration = 1.0;
        fin.fromValue = [NSNumber numberWithFloat:1.0];
        fin.toValue = [NSNumber numberWithFloat:0.0];
        fin.removedOnCompletion = NO;
        fin.fillMode  = kCAFillModeForwards;
        fin.delegate = self;
        [self.layer addAnimation:fin forKey:@"fout"];
    }
}

- (void)animationStart
{
    animCount++;
}

- (void)initGame
{
    overallScore = 0;
    lastTile = nil;
    
    int x, y;
    
    for(y = 0; y < 12; y++)
    {
        for(x = 0; x < 9; x++)
        {
            SameTile * st = [[SameTile alloc] initWithFrame:CGRectFromTilePosition(x, 11-y)];
            st.x = x;
            st.y = y;
            tiles[x][y] = st;
            allTiles[y*9+x] = st;
            [self addSubview:st];
            st.hidden = YES;
            animCount = 0;
        }
    }
    
    if (!timed)
    {
        valueLabel.text = @"";
        scoreLabel.text = @"0 points";
    }
    else
    {
        timerView.percentage = 1.0;
    }
}

- (void)showGame
{
    int x, y;
    
    self.layer.opacity = 1.0;
    
    /*CABasicAnimation * fin = [CABasicAnimation animationWithKeyPath:@"opacity"];
     fin.duration = 1.0;
     fin.fromValue = [NSNumber numberWithFloat:0.0];
     fin.toValue = [NSNumber numberWithFloat:1.0];
     fin.removedOnCompletion = NO;
     fin.fillMode  = kCAFillModeForwards;
     fin.delegate = self;
     [self.layer addAnimation:fin forKey:@"fin"];*/
    
    for(y = 0; y < 12; y++)
    {
        for(x = 0; x < 9; x++)
        {
            allTiles[y*9+x].hidden = NO;
        }
    }
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if(theAnimation == [self.layer animationForKey:@"fin"])
    {
        self.layer.opacity = 1.0;
        [self.layer removeAnimationForKey:@"fin"];
        //[(id)[[UIApplication sharedApplication] delegate] removeImage];
    }
    
    if(theAnimation == [self.layer animationForKey:@"fout"])
    {
        self.layer.opacity = 0.0;
        [self.layer removeAnimationForKey:@"fout"];
        
        // Remove remaining tiles
        int x, y;
        
        for(UIView * view in self.subviews)
        {
            if(view != valueLabel && view != scoreLabel && view != timerView)
                [view removeFromSuperview];
        }
        
        for(y = 0; y < 12; y++)
        {
            for(x = 0; x < 9; x++)
            {
                @try
                {
                    SameTile * t = allTiles[y*9+x];
                    if(t)
                    {
                        [t removeFromSuperview];
                        [t release];
                        allTiles[y*9+x] = nil;
                    }
                }
                @catch (NSException * e) {}
            }
        }
        
        [self performSelector:@selector(initGame) withObject:self afterDelay:0];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor blackColor];
        
        valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 413, 160 - 16, 40)];
        valueLabel.backgroundColor = [UIColor blackColor];
        valueLabel.textColor = [UIColor whiteColor];
        valueLabel.textAlignment = UITextAlignmentRight;
        valueLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:valueLabel];
        
        scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 413, 160, 40)];
        scoreLabel.backgroundColor = [UIColor blackColor];
        scoreLabel.textColor = [UIColor whiteColor];
        scoreLabel.textAlignment = UITextAlignmentLeft;
        scoreLabel.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:scoreLabel];
        
        [self initGame];
        [self showGame];
        
        [self becomeFirstResponder];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setTimed:(BOOL)isTimed
{
    timed = isTimed;
    
    if (timerView)
    {
        [timerView removeFromSuperview];
        [timerView release];
        timerView = nil;
    }
    
    if (realTimer)
    {
        [realTimer invalidate];
        [realTimer release];
        realTimer = nil;
    }
    
    if (self.timed)
    {
        timerView = [[SameTimerView alloc] initWithFrame:CGRectMake(11, 420, 298, 25)];
        realTimer = [NSTimer scheduledTimerWithTimeInterval:1./30. target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
        [self addSubview:timerView];
        timerView.percentage = 1.0;
        scoreLabel.text = valueLabel.text = @"";
    }
}

- (void)updateTimer:(id)stuff
{
    timerView.percentage -= 0.001;
    
    if(timerView.percentage <= 0.0)
        [self shakeReload];
}

- (NSMutableArray *)_tilesConnectedTo:(SameTile*)tile
{
    NSMutableArray * connected = [[NSMutableArray alloc] init];
    
    if(tile.visited || tile.state == NO)
        return connected;
    
    int x = tile.x;
    int y = tile.y;
    
    tile.visited = YES;
    
    [connected addObject:tile];
    
    NSMutableArray * temp;
    
    if((y + 1 < 12) && (tile.color == tiles[x][y+1].color))
    {
        temp = [self _tilesConnectedTo:tiles[x][y+1]];
        [connected addObjectsFromArray:temp];
        [temp release];
    }
    
    if((y - 1 >= 0) && (tile.color == tiles[x][y-1].color))
    {
        temp = [self _tilesConnectedTo:tiles[x][y-1]];
        [connected addObjectsFromArray:temp];
        [temp release];
    }
    
    if((x + 1 < 9) && (tile.color == tiles[x+1][y].color))
    {
        temp = [self _tilesConnectedTo:tiles[x+1][y]];
        [connected addObjectsFromArray:temp];
        [temp release];
    }
    
    if((x - 1 >= 0) && (tile.color == tiles[x-1][y].color))
    {
        temp = [self _tilesConnectedTo:tiles[x-1][y]];
        [connected addObjectsFromArray:temp];
        [temp release];
    }
    
    return connected;
}

- (NSMutableArray *)tilesConnectedTo:(SameTile*)tile
{
    int x, y;
    
    for(y = 0; y < 12; y++)
        for(x = 0; x < 9; x++)
            tiles[x][y].visited = NO;
    
    return [self _tilesConnectedTo:tile];
}

- (void)unlightTiles
{
    if(litTiles)
        for(SameTile * tile in litTiles)
        {
            [tile unlight];
        }
    
    [litTiles release];
    litTiles = nil;
    
    if(!timed)
        valueLabel.text = @"";
}

- (void)lightTiles:(NSMutableArray*)t
{
    [self unlightTiles];
    
    for(SameTile * tile in t)
    {
        [tile light];
    }
    
    if(!timed)
        valueLabel.text = [NSString stringWithFormat:@"+%d",score_for_tiles([t count])];
    
    litTiles = [t copy];
}

- (BOOL)gameCompleted
{
    int x, y;
    
    for(y = 0; y < 12; y++)
    {
        for(x = 0; x < 9; x++)
        {
            if(tiles[x][y] && [tiles[x][y] state])
            {
                NSMutableArray * tc = [self tilesConnectedTo:tiles[x][y]];
                if([tc count] > 1)
                {
                    [tc release];
                    return NO;
                }
                [tc release];
            }
        }
    }
    
    return YES;
}

- (BOOL)gameWon
{
    int x, y;
    
    for(y = 0; y < 12; y++)
        for(x = 0; x < 9; x++)
            if(tiles[x][y] && [tiles[x][y] state])
                return NO;
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(animCount > 0)
        return;
    
    UITouch * t = [touches anyObject];
    int x, y;
    
    for(y = 0; y < 12; y++)
        for(x = 0; x < 9; x++)
            if(CGRectContainsPoint([tiles[x][y] frame], [t locationInView:self]))
            {
                if(tiles[x][y] == lastTile)
                    return;
                
                NSMutableArray * t = [self tilesConnectedTo:tiles[x][y]];
                if([t count] > 1)
                    [self lightTiles:t];
                [t release];
                
                lastTile = tiles[x][y];
                
                return;
            }
    
    [self unlightTiles];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(animCount > 0)
        return;
    
    UITouch * t = [touches anyObject];
    int x, y;
    
    for(y = 0; y < 12; y++)
    {
        for(x = 0; x < 9; x++)
        {
            if(CGRectContainsPoint([tiles[x][y] frame], [t locationInView:self]))
            {
                NSMutableArray * rm = [self tilesConnectedTo:tiles[x][y]];
                [self removeTiles:rm];
                [rm release];
            }
        }
    }
}

- (void)dismissedHUD
{
    [hud removeFromSuperview];
    [hud release];
    hud = nil;
    
    [self showGame];
    [self setTimed:self.timed];
}

- (void)removeTiles:(NSMutableArray*)t
{
    if([t count] <= 1)
        return;
    
    [self unlightTiles];
    
    for(SameTile * tile in t)
    {
        [tile closeTile];
    }
    
    int realX = 0, y = 0, x = 0;
    
    for(x = 0; x < 9; x++)
    {
        if(!tiles[x][0])
            continue;
        
        NSMutableArray * goodLights = [[NSMutableArray alloc] init];
        
        for(y = 0; y < 12; y++)
        {
            SameTile * tile = tiles[x][y];
            
            if(tile && tile.state)
                [goodLights addObject:tile];
        }
        
        y = 0;
        
        for(SameTile * tile in goodLights)
            tiles[realX][y++] = tile;
        
        int savey=y;
        
        for(; y < 12; y++)
            tiles[realX][y] = nil;
        
        [goodLights release];
        
        BOOL emptyCol = YES;
        
        for(y = 0; y < savey; y++)
        {
            SameTile * tile = tiles[realX][y];
            tile.x = realX;
            tile.y = y;
            
            if(tile.state)
            {
                CGPoint newPt = CGRectFromTilePosition(realX, 11-y).origin;
                
                if(newPt.x != tile.frame.origin.x || newPt.y != tile.frame.origin.y)
                    [tile moveTo:CGPointMake(16 + newPt.x, 16 + newPt.y)];
                
                emptyCol = NO;
            }
        }
        
        if(!emptyCol)
            realX++;
    }
    
    for(; realX < 9; realX++)
        for(y = 0; y < 12; y++)
            tiles[realX][y] = nil;
    
    litTiles = nil;
    
    overallScore += score_for_tiles([t count]);
    
    if(!timed)
        scoreLabel.text = [NSString stringWithFormat:@"%d points",overallScore];
}

- (void)shakeReload
{
    int x, y;
    
    for(UIView * view in self.subviews)
    {
        if(view != valueLabel && view != scoreLabel && view != timerView)
            [view removeFromSuperview];
    }
    
    for(y = 0; y < 12; y++)
    {
        for(x = 0; x < 9; x++)
        {
            @try
            {
                SameTile * t = allTiles[y*9+x];
                if(t)
                {
                    [t removeFromSuperview];
                    [t release];
                    allTiles[y*9+x] = nil;
                }
            }
            @catch (NSException * e) {}
        }
    }
    
    [self performSelector:@selector(initGame) withObject:self afterDelay:0];
    [self performSelector:@selector(showGame) withObject:self afterDelay:0.2];
}

- (void)dealloc
{
    int x, y;
    
    for(y = 0; y < 12; y++)
    {
        for(x = 0; x < 9; x++)
        {
            // lol ugly as hell.
            
            @try
            {
                [tiles[x][y] removeFromSuperview];
                [tiles[x][y] release];
                tiles[x][y] = nil;
            }
            @catch (NSException * e) {}
        }
    }
    
    [valueLabel removeFromSuperview];
    [valueLabel release];
    
    [scoreLabel removeFromSuperview];
    [scoreLabel release];
    
    [litTiles release];
    
    [super dealloc];
}

@end
