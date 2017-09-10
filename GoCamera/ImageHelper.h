//
//  ImageHelper.h
//  GoCamera
//
//  Created by Tomwu on 2017/5/7.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageHelper : NSObject

+ (UIImage *)saveViewToImage:(UIImageView *)imageView;

+ (UIImage *)pixelImage:(UIImage *)image;

@end
