//
//  GPUImageCustomLookupFilter.m
//  GoCamera
//
//  Created by Tomwu on 2017/5/30.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import "GPUImageCustomLookupFilter.h"

@implementation GPUImageCustomLookupFilter

- (id) initWithLookupImageName:(NSString *)imageName {
    self = [super init];
    if (self) {
        
        UIImage *image = [UIImage imageNamed:imageName];
        lookupImageSource = [[GPUImagePicture alloc] initWithImage:image];
        GPUImageLookupFilter *lookupFilter = [[GPUImageLookupFilter alloc] init];
        [self addTarget:lookupFilter];
        [lookupImageSource addTarget:lookupFilter atTextureLocation:1];
        [lookupImageSource processImage];
        self.initialFilters = @[lookupFilter];
        self.terminalFilter = lookupFilter;
    }
    return self;
}

@end
