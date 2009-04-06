//
//  SameViewController.h
//  Same
//
//  Created by Tim Horton on 2009.04.06.
//  Copyright Rensselaer Polytechnic Institute 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SameTile.h"

@interface SameView : UIView <UIAlertViewDelegate>
{
	SameTile * tiles[9][12];
	
	SameTile * lastTile;
	
	NSMutableArray * litTiles;
	
	int overallScore;
	
	UILabel * valueLabel, * scoreLabel;
}

- (void)removeTiles:(NSMutableArray*)t;

@end

