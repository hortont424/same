//
//  SameAppDelegate.m
//  Same
//
//  Created by Tim Horton on 2009.04.06.
//  Copyright Rensselaer Polytechnic Institute 2009. All rights reserved.
//

#import "SameAppDelegate.h"
#import "SameView.h"

#import "SameHUD.h"

@implementation SameAppDelegate

@synthesize window, scores;

- (NSString *)pathForDataFile
{
	return [NSString stringWithFormat:@"%@%@",
			[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0],
			@"/scores.ini"];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	UIImageView * im = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Default" ofType:@"png"]]];
	
	NSString * path = [self pathForDataFile];
	NSDictionary * rootObject;
	
	srand(time(NULL));
	
	rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
	scores = [[NSMutableArray alloc] initWithArray:[rootObject valueForKey:@"scores"]];
	if(!scores)
		scores = [[NSMutableArray alloc] init];

	window = [[UIWindow alloc] initWithFrame:CGRectMake(0,0,320,480)];
	[window addSubview:im];
	
	SameView * sv = [[SameView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	sv.userInteractionEnabled = YES;
	window.userInteractionEnabled = YES;
	[window addSubview:sv];
	
    [window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	NSString * path = [self pathForDataFile];

	NSMutableDictionary * rootObject;
	rootObject = [NSMutableDictionary dictionary];

	[rootObject setValue:scores forKey:@"scores"];
	[NSKeyedArchiver archiveRootObject:rootObject toFile:path];
	
	[super dealloc];
	
}

- (void)dealloc
{
    [window release];
    [super dealloc];
}


@end
