//
//  SameTileImages.h
//  Same
//
//  Created by Tim Horton on 2009.04.06.
//  Copyright 2009 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SameTileImages : NSObject
{
	UIImage * redImage, * blueImage, * yellowImage, * greenImage;
}

@property (nonatomic,readonly) UIImage * redImage;
@property (nonatomic,readonly) UIImage * blueImage;
@property (nonatomic,readonly) UIImage * yellowImage;
@property (nonatomic,readonly) UIImage * greenImage;

+ (SameTileImages*)shared;

@end
