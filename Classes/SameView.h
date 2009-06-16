//
//  SameViewController.h
//  Same
//
//  Created by Tim Horton on 2009.04.06.
//  Copyright Rensselaer Polytechnic Institute 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SameTile.h"
#import "SameHUD.h"

@interface SameView : UIView <UIAlertViewDelegate>
{
	SameTile * tiles[9][12];
	SameTile * allTiles[108];
	
	SameTile * lastTile;
	
	NSMutableArray * litTiles;
	
	int overallScore, animCount;
	
	UILabel * valueLabel, * scoreLabel;
	SameHUD * hud;
}

- (void)removeTiles:(NSMutableArray*)t;

- (void)animationStart;
- (void)animationDone;

- (BOOL)gameCompleted;
- (BOOL)gameWon;

@end

