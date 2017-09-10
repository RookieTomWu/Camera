//
//  GPUImageCustomLookupFilter.h
//  GoCamera
//
//  Created by Tomwu on 2017/5/30.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import <GPUImage/GPUImage.h>

@interface GPUImageCustomLookupFilter : GPUImageFilterGroup {
    
    GPUImagePicture *lookupImageSource;
}

- (id) initWithLookupImageName:(NSString *)imageName;
@end
