//
//  SameMenuButton.h
//  Same
//
//  Created by Timothy Horton on 2009.06.30.
//  Copyright 2009 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SameMenuButton : UIControl
{
	BOOL selected;
	NSString * title;
}

@property (nonatomic,retain) NSString * title;

@end
