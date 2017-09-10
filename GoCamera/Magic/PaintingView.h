//
//  PaintingView.h
//  Aico
//
//  Created by wxd.
//  Copyright wxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaintingView : UIView {
	NSMutableArray *operationArray_;        //撤销、恢复数组
	
	NSString       *stampPicName_;          //按钮名称
	
    CGPoint        lastPoint_;              //上一个点坐标
    CGFloat        imageSize_;              //图片外接圆直径
    NSTimer       *touchEndTimer_;          //手指离开屏幕时间定时器
    CGFloat        lastImageSize_;          //上个点所绘制图片大小
    CGSize         layerSize_;              //依据图片计算出的显示每个小图的layer大小
}
@property(nonatomic,strong) NSMutableArray *operationArray;
@property(nonatomic,copy)   NSString       *stampPicName;
@property(nonatomic,assign) CGFloat        imageSize;
@property(nonatomic,assign) int        maxScaleRatio;
@property(nonatomic,strong) NSTimer *touchEndTimer;

- (UIImage *)getImageAtEachPoint;

- (void)addAnimationLayerWithImageName:(UIImage *)image atPoint:(CGPoint)point;
/**
 * 更新撤销和恢复图片
 */
- (void)updateUndoAndRedo;

/**
 * @brief 
 * 截取当前绘画视图
 * @return 截取的图片
 */
- (UIImage *)getCurrentPic;
/**
 * @brief 
 * 撤销操作
 */
- (void)backwardDrawing;
/**
 * 恢复操作
 */
- (void)forwardDrawing;

/**
 * @brief 
 * 设置当前徽章图片名称
 *
 * @param pictureName 图片名称
 */
- (void)setstampPicName:(NSString *)pictureName;

/**
 * @brief 
 * 更新ReUnManager  snapimage
 */
- (void)updateImageSnap;


/**
 * @brief 
 * 将最后的layer设置为不透明
 */
-(void)setLastLayerOpacity;
@end
