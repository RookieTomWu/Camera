//
//  MTFilteriOSBlur.m
//  MYXJ
//
//  Created by Ryan on 16/5/13.
//  Copyright © 2016年 Meitu. All rights reserved.
//

#import "MTFilteriOSBlur.h"
#import "GPUImageSaturationFilter.h"
#import "GPUImageGaussianBlurFilter.h"
#import "GPUImageLuminanceRangeFilter.h"
#import "GPUImageBrightnessFilter.h"

@implementation MTFilteriOSBlur

@synthesize blurRadiusInPixels;
@synthesize downsampling = _downsampling;

#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    // Second pass: apply a strong Gaussian blur
    blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    [self addFilter:blurFilter];
    
    self.initialFilters = [NSArray arrayWithObject:blurFilter];
    self.terminalFilter = blurFilter;
    
    self.blurRadiusInPixels = 12.0;
    self.downsampling = 4.0;
    
    return self;
}

- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex;
{
    if (_downsampling > 1.0)
    {
        CGSize rotatedSize = [blurFilter rotatedSize:newSize forIndex:textureIndex];
        
        [blurFilter forceProcessingAtSize:CGSizeMake(rotatedSize.width / _downsampling, rotatedSize.height / _downsampling)];
        [blurFilter forceProcessingAtSize:rotatedSize];
    }
    
    [super setInputSize:newSize atIndex:textureIndex];
}

#pragma mark Accessors

// From Apple's UIImage+ImageEffects category:

// A description of how to compute the box kernel width from the Gaussian
// radius (aka standard deviation) appears in the SVG spec:
// http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
//
// For larger values of 's' (s >= 2.0), an approximation can be used: Three
// successive box-blurs build a piece-wise quadratic convolution kernel, which
// approximates the Gaussian kernel to within roughly 3%.
//
// let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
//
// ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.


- (void)setBlurRadiusInPixels:(CGFloat)newValue;
{
    blurFilter.blurRadiusInPixels = newValue;
}

- (CGFloat)blurRadiusInPixels;
{
    return blurFilter.blurRadiusInPixels;
}

- (void)setDownsampling:(CGFloat)newValue;
{
    _downsampling = newValue;
}


@end

