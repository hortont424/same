//
//  SameAppDelegate.h
//  Same
//
//  Created by Tim Horton on 2009.04.06.
//  Copyright Rensselaer Polytechnic Institute 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SameViewController;

@interface SameAppDelegate : NSObject <UIApplicationDelegate>
{
	NSMutableArray * scores;
    UIWindow * window;
}

@property (nonatomic, retain) IBOutlet UIWindow * window;
@property (nonatomic, assign) NSMutableArray * scores;

@end
