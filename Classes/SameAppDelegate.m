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

#import "SameAppDelegate.h"
#import "SameView.h"
#import "SameMenu.h"

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
	NSString * path = [self pathForDataFile];
	NSDictionary * rootObject;
	
	srand(time(NULL));
	
	rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
	scores = [[NSMutableArray alloc] initWithArray:[rootObject valueForKey:@"scores"]];
	if(!scores)
		scores = [[NSMutableArray alloc] init];

	window = [[UIWindow alloc] initWithFrame:CGRectMake(0,0,320,480)];
	
	SameMenu * smenu = [[SameMenu alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	smenu.userInteractionEnabled = YES;
	window.userInteractionEnabled = YES;
	[window addSubview:smenu];
	
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
