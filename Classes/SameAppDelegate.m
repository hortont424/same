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
	srand(time(NULL));
	
	window = [[UIWindow alloc] initWithFrame:CGRectMake(0,0,320,480)];
	SameView * sv = [[SameView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	sv.userInteractionEnabled = YES;
	window.userInteractionEnabled = YES;
	[window addSubview:sv];

    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
