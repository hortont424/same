//
//  SameViewController.m
//  Same
//
//  Created by Tim Horton on 2009.04.06.
//  Copyright Rensselaer Polytechnic Institute 2009. All rights reserved.
//

#import "SameView.h"

CGRect CGRectFromTilePosition(int x, int y)
{
	return CGRectMake(12+(x*33),12+(y*33),33,33);
}

int score_for_tiles(int n)
{
	if(n < 3)
		return 0;
	
	return (n - 2) * (n - 2);
}

@implementation SameView

int rcompare(NSNumber * a, NSNumber * b, void * context)
{
    return [b compare:a];
}

- (void)animationDone
{
	animCount--;
	
	if(animCount == 0 && (([self gameWon] || [self gameCompleted]) && !hud))
	{
		hud = [[SameHUD alloc] initWithFrame:CGRectInset([self bounds], 50, 75)];
		hud.delegate = self;
		[[self superview] addSubview:hud];
		
		if([self gameWon])
		{
			overallScore += 1000;
			
			scoreLabel.text = [NSString stringWithFormat:@"%d points", overallScore];
		}
		
		NSMutableArray * scores = [[[UIApplication sharedApplication] delegate] scores];
		
		[scores addObject:[NSNumber numberWithInt:overallScore]];
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
	
	valueLabel.text = @"";
	scoreLabel.text = @"0 points";

}

- (void)showGame
{
	int x, y;
	
	self.layer.opacity = 0.0;
	
	CABasicAnimation * fin = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fin.duration = 1.0;
	fin.fromValue = [NSNumber numberWithFloat:0.0];
	fin.toValue = [NSNumber numberWithFloat:1.0];
	fin.removedOnCompletion = NO;
	fin.fillMode  = kCAFillModeForwards;
	fin.delegate = self;
	[self.layer addAnimation:fin forKey:@"fin"];
	
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
	}
	
	if(theAnimation == [self.layer animationForKey:@"fout"])
	{
		self.layer.opacity = 0.0;
		[self.layer removeAnimationForKey:@"fout"];
		
		// Remove remaining tiles
		int x, y;

		for(UIView * view in self.subviews)
		{
			if(view != valueLabel && view != scoreLabel)
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
    }
    return self;
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
	
	valueLabel.text = @"";
}

- (void)lightTiles:(NSMutableArray*)t
{
	[self unlightTiles];
	
	for(SameTile * tile in t)
	{
		[tile light];
	}
	
	valueLabel.text = [NSString stringWithFormat:@"+%d",score_for_tiles([t count])];
	
	litTiles = [t copy];
}

- (BOOL)gameCompleted
{
	int x, y;
	
	for(y = 0; y < 12; y++)
		for(x = 0; x < 9; x++)
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
	
	scoreLabel.text = [NSString stringWithFormat:@"%d points",overallScore];
}

- (void)viewDidUnload
{
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
