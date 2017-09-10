//
//  ImageModel.m
//  GoCamera
//
//  Created by Tomwu on 2017/5/5.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import "ImageModel.h"

@implementation ImageModel

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static id object;
    dispatch_once(&onceToken, ^{
        object = [[self alloc] init];
    });
    return object;
}

@end
