//
//  ImageModel.h
//  GoCamera
//
//  Created by Tomwu on 2017/5/5.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *kCurrentImage = @"currentImage";

@interface ImageModel : NSObject

@property (nonatomic, strong) UIImage *rawImage;
@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, strong) UIImage *scaledImage;

+ (instancetype)shareInstance;

@end
