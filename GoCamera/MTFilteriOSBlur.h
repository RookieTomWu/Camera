//
//  MTFilteriOSBlur.h
//  MYXJ
//
//  Created by Ryan on 16/5/13.
//  Copyright © 2016年 Meitu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImageFilterGroup.h"
@class GPUImageGaussianBlurFilter;

@interface MTFilteriOSBlur : GPUImageFilterGroup
{
    GPUImageGaussianBlurFilter *blurFilter;
}

/** A radius in pixels to use for the blur, with a default of 12.0. This adjusts the sigma variable in the Gaussian distribution function.
 */
@property (readwrite, nonatomic) CGFloat blurRadiusInPixels;

/** The degree to which to downsample, then upsample the incoming image to minimize computations within the Gaussian blur, default of 4.0
 */
@property (readwrite, nonatomic) CGFloat downsampling;


@end
