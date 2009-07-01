//
//  SameTileImages.m
//  Same
//
//  Created by Tim Horton on 2009.04.06.
//  Copyright 2009 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "SameTileImages.h"

@implementation SameTileImages

@synthesize redImage, blueImage, greenImage, yellowImage;

- (id) init
{
	self = [super init];
	if (self != nil)
	{
		redImage = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"red" ofType:@"png"]] retain];
		blueImage = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"blue" ofType:@"png"]] retain];
		greenImage = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"green" ofType:@"png"]] retain];
		yellowImage = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"yellow" ofType:@"png"]] retain];
	}
	return self;
}


+ (SameTileImages *)shared
{
    static SameTileImages *shared;
    
    if (!shared)
        shared = [[SameTileImages alloc] init];
    
    return shared;
}

- (UIImage *)imageForColor:(int)c
{
	switch(c)
	{
		case 0: return redImage;
		case 1: return blueImage;
		case 2: return greenImage;
		case 3: return yellowImage;
	}
	
	return redImage;
}

@end
