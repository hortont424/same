//
//  SameAppDelegate.m
//  Same
//
//  Created by Tim Horton on 2009.04.06.
//  Copyright Rensselaer Polytechnic Institute 2009. All rights reserved.
//

#import "SameAppDelegate.h"
#import "SameView.h"

@implementation SameAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	SameView * sv = [[[SameView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] retain];
	[window addSubview:sv];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
