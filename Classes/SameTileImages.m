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
		redImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"red" ofType:@"png"]];
		blueImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"blue" ofType:@"png"]];
		greenImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"green" ofType:@"png"]];
		yellowImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"yellow" ofType:@"png"]];
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

@end
