
//
//  ImageHelper.m
//  GoCamera
//
//  Created by Tomwu on 2017/5/7.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import "ImageHelper.h"

@implementation ImageHelper

+ (UIImage *)saveViewToImage:(UIImageView *)imageView {
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, true, 0);
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGSize newSize = imageView.image.size;
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}

+ (UIImage *)pixelImage:(UIImage *)image {
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    CGRect r = inputImage.extent;
    CGFloat scale = (MAX(r.size.width, r.size.height) / 60.0) * [UIScreen mainScreen].scale;
    CIImage *maskImage = [[CIImage alloc] initWithColor:[CIColor colorWithRed:0.0 green:1.0 blue:1.0]];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIPixellate"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:scale] forKey:@"inputScale"];
    CIImage *pixellatedImage = filter.outputImage;
    
    CIFilter *maskFilter = [CIFilter filterWithName:@"CIBlendWithMask"];
    [maskFilter setValue:pixellatedImage forKey:kCIInputImageKey];
    [maskFilter setValue:maskImage forKey:@"inputMaskImage"];
    [maskFilter setValue:inputImage forKey:kCIInputBackgroundImageKey];
    
    CIImage *result = maskFilter.outputImage;
    
    return ([UIImage imageWithCIImage:result]);
}

@end
