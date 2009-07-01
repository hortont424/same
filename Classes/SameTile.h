//
//  SameTile.h
//  Same
//
//  Created by Tim Horton on 2009.04.06.
//  Copyright 2009 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CoreAnimation.h>

@interface SameTile : NSObject
{
	int color;
	BOOL visited;
	BOOL state;
	BOOL lit;
	int animating;
	
	int x;
	int y;
	
	CGRect frame;
	
	CGPoint newPoint, originalPoint, delta;
}

@property (nonatomic) int color;
@property (nonatomic) BOOL visited;
@property (nonatomic) BOOL state;
@property (nonatomic) BOOL lit;
@property (nonatomic) int animating;
@property (nonatomic) int x;
@property (nonatomic) int y;

@property (nonatomic,assign) CGRect frame;
@property (nonatomic,assign) CGPoint newPoint;
@property (nonatomic,assign) CGPoint originalPoint;
@property (nonatomic,assign) CGPoint delta;

@end
