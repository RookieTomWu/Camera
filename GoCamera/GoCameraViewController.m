//
//  GoCameraViewController.m
//  GoCamera
//
//  Created by wxd on 2017/3/16.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import "GoCameraViewController.h"
#import "BeautyMainViewController.h"
#import "GPUImageBeautifyFilter.h"
#import "AppSettings.h"

#import "GPUImage.h"
#import "ProgressHUD.h"
#import "cameraCountdownView.h"
#import "MTFilteriOSBlur.h"
#import "GPUImageCustomLookupFilter.h"
#import "FilterSelectionView.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "UIImage+fixOrientation.h"
#import "GPUImageStillCamera+ExpandFunction.h"

#import "ImageModel.h"

@interface GoCameraViewController ()<
    UIGestureRecognizerDelegate,
    CAAnimationDelegate,
    CameraFilterViewDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    CameraCountdownViewDelegate> {
    CALayer *_focusLayer;
    RatioType _currentRatio;
    FlashState _currentFlashMode;
    DelayCaptureMmode _delayCaptureMode;
    FilterSelectionView *_filterSelectionView;
    // 多任务切换时预览窗的模糊遮罩
    GPUImageView *_blurMaskView;
    GPUImageOutput<GPUImageInput> *_filter;
}
@property (weak, nonatomic) IBOutlet UIButton *shootBtn;
@property (weak, nonatomic) IBOutlet UIButton *screenRadioBtn;
@property (weak, nonatomic) IBOutlet UIButton *flashBtn;
@property (weak, nonatomic) IBOutlet UIButton *delayTimeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMaskHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBarHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (weak, nonatomic) IBOutlet UIView *previewContainer;

@property (nonatomic, strong) GPUImageView *previewView;
@property (nonatomic, strong) GPUImageStillCamera *stillCamera;
@property (nonatomic, strong) cameraCountdownView *countdownView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic , assign) CGFloat beginGestureScale;//当前的缩放比例
@property (nonatomic , assign) CGFloat effectiveScale;//最后的缩放比例

// 延时拍摄倒数计时中
@property (nonatomic, assign, getter = isBeingCountDownSecondsForCapturingPhoto) BOOL beingCountDownSecondsForCapturingPhoto;

@end

@implementation GoCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self config];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_stillCamera startCameraCapture];
    [self addBlurMaskView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Action
- (IBAction)rotationAction:(id)sender {
    [self.stillCamera stopCameraCapture];
    if (self.stillCamera.cameraPosition == AVCaptureDevicePositionBack) {
        _stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionFront];
    } else if (self.stillCamera.cameraPosition == AVCaptureDevicePositionFront) {
        _stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionBack];
    }
    //设置照片的方向为设备的定向
    _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    //设置是否为镜像
    _stillCamera.horizontallyMirrorFrontFacingCamera = YES;
    _stillCamera.horizontallyMirrorRearFacingCamera = NO;
    
    //添加滤镜
    _filter = [[GPUImageBeautifyFilter alloc] init];
    [_stillCamera addTarget:_filter];
    [_filter addTarget:_previewView];

    //启动相机捕获
    [_stillCamera startCameraCapture];
    [self addBlurMaskView];
}

- (IBAction)shootAction:(id)sender {
    if (self.isBeingCountDownSecondsForCapturingPhoto) {
        return;
    }
    
    if (_delayCaptureMode != DelayCaptureClose) {
        [_countdownView removeFromSuperview];
        NSInteger seconds = _delayCaptureMode == DelayCapture3s ? 3 : 6;
        _countdownView = [[cameraCountdownView alloc] initWithSeconds:seconds];
        _countdownView.userInteractionEnabled = NO;
        [self.view addSubview:_countdownView];
        [_countdownView setDelegate:self];
        _beingCountDownSecondsForCapturingPhoto = YES;
        [_countdownView startCountdownTimer];
    } else {
        [self writePhotoToAsset];
    }
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)filterSwitchAction:(id)sender {
    [_filterSelectionView show];
}

- (IBAction)radioChangeAction:(id)sender {
    switch (_currentRatio) {
        case RatioType1V1:
            _currentRatio = RatioType3V4;
            break;
        case RatioType3V4:
            _currentRatio = RatioType1V1;
            break;
        default:
            break;
    }
    
    [self switchRadioTypeWithAnimation:YES];
    [self screenRadioBtnState:_currentRatio];
}
- (IBAction)changeFlashState:(id)sender {
    switch (_currentFlashMode) {
        case FlashStateAtuo:
            _currentFlashMode = FlashStateOn;
            [self.flashBtn setImage:IMAGENAMED(@"icon_flashon_normal") forState:UIControlStateNormal];
            [self.flashBtn setImage:IMAGENAMED(@"icon_flashon_prsd") forState:UIControlStateHighlighted];
            break;
        case FlashStateOff:
            _currentFlashMode = FlashStateAtuo;
            [self.flashBtn setImage:IMAGENAMED(@"icon_flashatuo_normal") forState:UIControlStateNormal];
            [self.flashBtn setImage:IMAGENAMED(@"icon_flashatuo_prsd") forState:UIControlStateHighlighted];
            break;
        case FlashStateOn:
            _currentFlashMode = FlashStateOff;
            [self.flashBtn setImage:IMAGENAMED(@"icon_flashoff_normal") forState:UIControlStateNormal];
            [self.flashBtn setImage:IMAGENAMED(@"icon_flashoff_prsd") forState:UIControlStateHighlighted];
            break;
            
        default:
            break;
    }
    [self setFlashMode:_currentFlashMode];
}

#pragma mark - Private Methods
- (void)config {
    self.shootBtn.layer.cornerRadius = self.shootBtn.bounds.size.width/2;
    self.shootBtn.layer.borderWidth = 4;
    self.shootBtn.layer.borderColor = [UIColor colorWithRed:252/255.0 green:99/255.0 blue:93/255.0 alpha:1].CGColor;
    
    _currentFlashMode = FlashStateOff;
    _currentRatio = RatioType3V4;
    _delayCaptureMode = DelayCaptureClose;
    
    _stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionBack];
    
    _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    _stillCamera.horizontallyMirrorFrontFacingCamera = YES;//设置是否为镜像
    _stillCamera.horizontallyMirrorRearFacingCamera = NO;
    
    //添加滤镜
    _filter = [[GPUImageBeautifyFilter alloc] init];
    [self.stillCamera addTarget:_filter];
    
    //输出源
    _previewView = [[GPUImageView alloc] initWithFrame:_previewContainer.bounds];
    _previewView.autoresizingMask = UIViewAutoresizingAll;
    //拍摄视图填充方式
    _previewView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [_filter addTarget:_previewView];

    
    [self setfocusImage:IMAGENAMED(@"icon_focus")];
    
    [self setBeginGestureScale:1.0f];
    [self setEffectiveScale:1.0f];
    
    [_previewContainer addSubview:_previewView];
    [_previewContainer sendSubviewToBack:_previewView];
    
    [self addCameraFilterView];
}

- (void)switchRadioTypeWithAnimation:(BOOL)animated {
    CGFloat topSpaceConstant = self.topSpace.constant;
    CGFloat topBarHeightConstant = self.topBarHeight.constant;
    CGFloat bottomMaskHeightConstant = self.bottomMaskHeight.constant;
    if (_currentRatio == RatioType1V1) {
        bottomMaskHeightConstant = 95;
        topBarHeightConstant = 75;
        topSpaceConstant = 75;
    } else if (_currentRatio == RatioType3V4) {
        bottomMaskHeightConstant = 0;
        topBarHeightConstant = 44;
        topSpaceConstant = 44;
    }
    [self.view layoutIfNeeded];
    [self addBlurMaskView];
    
    CGFloat duration = animated ? 0.25f : 0.00;
    [UIView animateWithDuration:duration animations:^{
        self.topSpace.constant = topSpaceConstant;
        self.topBarHeight.constant = topBarHeightConstant;
        self.bottomMaskHeight.constant = bottomMaskHeightConstant;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

//切换屏幕比例时添加蒙层
- (void)addBlurMaskView {
    if (_blurMaskView) {
        return;
    }
    self.view.userInteractionEnabled = NO;
    CGRect frame = CGRectZero;
    if (_currentRatio == RatioTypeFull) {
        frame = self.view.frame;
    } else {
        frame = self.previewView.bounds;
    }
    _blurMaskView = [[GPUImageView alloc] initWithFrame:frame];
    _blurMaskView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    MTFilteriOSBlur *squareFilter = [[MTFilteriOSBlur alloc]init];
    [squareFilter addTarget:_blurMaskView];
    squareFilter.blurRadiusInPixels = 18;
    [squareFilter forceProcessingAtSize:_blurMaskView.frame.size];
    [_stillCamera addTarget:squareFilter];
    _blurMaskView.autoresizingMask = UIViewAutoresizingAll;
    [_previewContainer insertSubview:_blurMaskView aboveSubview:_previewView];
    _blurMaskView.alpha = 1.0f;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
        [_stillCamera pauseCameraCapture];
        [squareFilter removeTarget:_blurMaskView];
        [_stillCamera removeTarget:squareFilter];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.33f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
        if (!_blurMaskView) {
            self.view.userInteractionEnabled = YES;
            return;
        }
        
        [_stillCamera resumeCameraCapture];
        [UIView animateWithDuration:0.33 animations:^ {
            _blurMaskView.alpha = 0;
        } completion:^ (BOOL finished) {
            [_blurMaskView removeFromSuperview];
            _blurMaskView = nil;
            self.view.userInteractionEnabled = YES;
        }];
    });
}

- (void)screenRadioBtnState:(RatioType)type {
    if (type == RatioType1V1) {
        [self.screenRadioBtn setImage:IMAGENAMED(@"icon_screen1V1_normal") forState:UIControlStateNormal];
        [self.screenRadioBtn setImage:IMAGENAMED(@"icon_screen1V1_prsd") forState:UIControlStateHighlighted];
    } else if (type == RatioType3V4) {
        [self.screenRadioBtn setImage:IMAGENAMED(@"icon_screen3V4_normal") forState:UIControlStateNormal];
        [self.screenRadioBtn setImage:IMAGENAMED(@"icon_screen3V4_prsd") forState:UIControlStateHighlighted];
    }
}

//设置聚焦图片
- (void)setfocusImage:(UIImage *)focusImage {
    if (!focusImage) return;
    
    if (!_focusLayer) {
        //增加tap手势，用于聚焦及曝光
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focus:)];
        [self.previewView addGestureRecognizer:tap];
        //增加pinch手势，用于调整焦距
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(focusDisdance:)];
        [self.previewView addGestureRecognizer:pinch];
        pinch.delegate = self;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, focusImage.size.width, focusImage.size.height)];
    imageView.image = focusImage;
    CALayer *layer = imageView.layer;
    layer.hidden = YES;
    [self.previewView.layer addSublayer:layer];
    _focusLayer = layer;
}

//调整焦距方法
-(void)focusDisdance:(UIPinchGestureRecognizer*)pinch {
    self.effectiveScale = self.beginGestureScale * pinch.scale;
    if (self.effectiveScale < 1.0f) {
        self.effectiveScale = 1.0f;
    }
    CGFloat maxScaleAndCropFactor = 3.0f;//设置最大放大倍数为3倍
    if (self.effectiveScale > maxScaleAndCropFactor)
        self.effectiveScale = maxScaleAndCropFactor;
    [CATransaction begin];
    [CATransaction setAnimationDuration:.025];
    NSError *error;
    if([self.stillCamera.inputCamera lockForConfiguration:&error]){
        [self.stillCamera.inputCamera setVideoZoomFactor:self.effectiveScale];
        [self.stillCamera.inputCamera unlockForConfiguration];
    }
    else {
        NSLog(@"ERROR = %@", error);
    }
    
    [CATransaction commit];
}

//对焦方法
- (void)focus:(UITapGestureRecognizer *)tap {
    self.previewView.userInteractionEnabled = NO;
    CGPoint touchPoint = [tap locationInView:tap.view];
    // CGContextRef *touchContext = UIGraphicsGetCurrentContext();
    [self layerAnimationWithPoint:touchPoint];
   
    if(_stillCamera.cameraPosition == AVCaptureDevicePositionBack){
        touchPoint = CGPointMake( touchPoint.y /tap.view.bounds.size.height ,1-touchPoint.x/tap.view.bounds.size.width);
    }
    else
        touchPoint = CGPointMake(touchPoint.y /tap.view.bounds.size.height ,touchPoint.x/tap.view.bounds.size.width);
    /*相机的聚焦和曝光设置，前置不支持聚焦但是可以曝光处理，后置相机两者都支持，下面的方法是通过点击一个点同时设置聚焦和曝光
     */
    if([self.stillCamera.inputCamera isExposurePointOfInterestSupported] && [self.stillCamera.inputCamera isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
        NSError *error;
        if ([self.stillCamera.inputCamera lockForConfiguration:&error]) {
            [self.stillCamera.inputCamera setExposurePointOfInterest:touchPoint];
            [self.stillCamera.inputCamera setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            if ([self.stillCamera.inputCamera isFocusPointOfInterestSupported] &&
                [self.stillCamera.inputCamera isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
                [self.stillCamera.inputCamera setFocusPointOfInterest:touchPoint];
                [self.stillCamera.inputCamera setFocusMode:AVCaptureFocusModeAutoFocus];
            }
            [self.stillCamera.inputCamera unlockForConfiguration];
        } else {
            NSLog(@"ERROR = %@", error);
        }
    }
}

//对焦动画
- (void)layerAnimationWithPoint:(CGPoint)point {
    if (_focusLayer) {
        ///聚焦点聚焦动画设置
        CALayer *focusLayer = _focusLayer;
        focusLayer.hidden = NO;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [focusLayer setPosition:point];
        focusLayer.transform = CATransform3DMakeScale(2.0f,2.0f,1.0f);
        [CATransaction commit];
        
        CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath: @"transform" ];
        animation.toValue = [ NSValue valueWithCATransform3D: CATransform3DMakeScale(1.0f,1.0f,1.0f)];
        animation.delegate = self;
        animation.duration = 0.3f;
        animation.repeatCount = 1;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [focusLayer addAnimation: animation forKey:@"animation"];
    }
}

- (void)cameraCountdownDidCompleted {
    self.beingCountDownSecondsForCapturingPhoto = NO;
}

- (void)writePhotoToAsset {
    
    [self.shootBtn setEnabled:NO];
    [ProgressHUD show:@"Please wait..."];
    
    __weak typeof(self) weakSelf = self;
    [self.stillCamera capturePhotoAsJPEGProcessedUpToFilter:_filter withCompletionHandler:^(NSData *processedJPEG, NSError *error){
    
        UIImage *image = [UIImage imageWithData:processedJPEG];
        [image fixOrientation];
        NSData *imageData = UIImagePNGRepresentation(image);
        // Save to assets library
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        [library writeImageDataToSavedPhotosAlbum:imageData metadata:self.stillCamera.currentCaptureMetadata completionBlock:^(NSURL *assetURL, NSError *error2)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 if (error) {
//                     UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Error"
//                                                                                        message:@"Picture Saving Failed"
//                                                                                 preferredStyle:UIAlertControllerStyleAlert];
//                     
//                     UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
//                                                                             style:UIAlertActionStyleDefault
//                                                                           handler:^(UIAlertAction * action) {}];
//                     [alertView addAction:defaultAction];
//                     [weakSelf presentViewController:alertView animated:YES completion:nil];
                     [ProgressHUD showError:@"图片保存失败"];
                 } else {
//                     UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Picture Saved"
//                                                                                        message:@"已存储到相册"
//                                                                                 preferredStyle:UIAlertControllerStyleAlert];
//                     
//                     UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
//                                                                             style:UIAlertActionStyleDefault
//                                                                           handler:^(UIAlertAction * action) {}];
//                     [alertView addAction:defaultAction];
//                     [weakSelf presentViewController:alertView animated:YES completion:nil];
                     [ProgressHUD showSuccess:@"已存储到相册"];
                 }
                 [weakSelf.shootBtn setEnabled:YES];
             });
         }];
    }];
}

#pragma mark - CAAnimationDelegate
//动画的delegate方法
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    //    1秒钟延时
    [self performSelector:@selector(focusLayerNormal) withObject:self afterDelay:0.5f];
}

//focusLayer回到初始化状态
- (void)focusLayerNormal {
    self.previewView.userInteractionEnabled = YES;
    _focusLayer.hidden = YES;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}

//设置闪光灯模式
- (void)setFlashMode:(FlashState)flashMode {
    AVCaptureDevice *device = self.stillCamera.inputCamera;
    [self.stillCamera.inputCamera lockForConfiguration:nil];
    switch (flashMode) {
        case FlashStateAtuo: {
            if ([device isFlashModeSupported:AVCaptureFlashModeAuto]) {
                [device setFlashMode:AVCaptureFlashModeAuto];
            }
            if ([device isTorchModeSupported:AVCaptureTorchModeOff]) {
                [device setTorchMode:AVCaptureTorchModeOff];
            }
        }
            break;
        case FlashStateOff: {
            if ([device isFlashModeSupported:AVCaptureFlashModeOff]) {
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            if ([device isTorchModeSupported:AVCaptureTorchModeOff]) {
                [device setTorchMode:AVCaptureTorchModeOff];
            }
        }
            break;
        case FlashStateOn: {
            if ([device isFlashModeSupported:AVCaptureFlashModeOn]) {
                [device setFlashMode:AVCaptureFlashModeOn];
            }
            if ([device isTorchModeSupported:AVCaptureTorchModeOff]) {
                [device setTorchMode:AVCaptureTorchModeOff];
            }
        }
            break;
        default:{
        }
            break;
    }
    [self.stillCamera.inputCamera unlockForConfiguration];
}

//添加滤镜视图到主视图上
- (void)addCameraFilterView {
    NSString *strNibName = NSStringFromClass([FilterSelectionView class]);
    UINib *nib = [UINib nibWithNibName:strNibName bundle:nil];
    _filterSelectionView = [[nib instantiateWithOwner:nil options:nil] lastObject];
    CGRect effectSelectionViewFrame = _filterSelectionView.frame;
    // 默认初始为隐藏状态
    effectSelectionViewFrame.origin.y = CGRectGetHeight(self.view.bounds);
    effectSelectionViewFrame.size.width = CGRectGetWidth(self.view.bounds);
    _filterSelectionView.frame = effectSelectionViewFrame;
    [self.view addSubview:_filterSelectionView];
    _filterSelectionView.cameraFilterDelegate = self;

}
- (IBAction)albumAction:(id)sender {
    [self imagePicker];
}

- (void)switchCameraFilter:(NSInteger)index {
    [self.stillCamera removeAllTargets];
    switch (index) {
        case 0:
            _filter = [[GPUImageFilter alloc] init];//原图
            break;
        case 1:
            _filter = [[GPUImageBeautifyFilter alloc] init];//美颜
            break;
        case 2:{
            //阳光
            GPUImageHazeFilter *hazeFilterBrighter = [[GPUImageHazeFilter alloc] init];
            hazeFilterBrighter.distance = -0.3;
            _filter = hazeFilterBrighter;
        }
            break;
        case 3: {
            //幽暗
            GPUImageHazeFilter *hazeFilterDarker = [[GPUImageHazeFilter alloc] init];
            hazeFilterDarker.distance = 0.3;
            _filter = hazeFilterDarker;
        }
            break;
        case 4: {
            _filter = [[GPUImageGrayscaleFilter alloc] init];//灰白
        }
            break;
        case 5:
             _filter = [[GPUImageSepiaFilter alloc] init];//怀旧
            break;
        case 6:
            _filter = [[GPUImageSketchFilter alloc] init]; //素描
            break;
        case 7:
            _filter = [[GPUImageCustomLookupFilter alloc] initWithLookupImageName:@"lookupFennen"]; //可爱
            break;
        case 8:
            _filter = [[GPUImageCustomLookupFilter alloc] initWithLookupImageName:@"lookupWeimei"]; //唯美
            break;
        case 9:
            _filter = [[GPUImageCustomLookupFilter alloc] initWithLookupImageName:@"lookupRouguang"]; //柔光
            break;
        case 10:
            _filter = [[GPUImageCustomLookupFilter alloc] initWithLookupImageName:@"lookupTianmei"];  //甜美
            break;
        default:
            _filter = [[GPUImageFilter alloc] init];
            break;
    }
    
    [self.stillCamera addTarget:_filter];
    [_filter addTarget:_previewView];
}

#pragma mark - ImagePicker
- (void)imagePicker {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.delegate = self; //设置委托
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//代理方法
- (void)imagePickerController:(UIImagePickerController *)picker
    didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //成功获取照片
    UIImage *image = (UIImage *)info[UIImagePickerControllerOriginalImage];
    [ImageModel shareInstance].currentImage = image;
    [ImageModel shareInstance].rawImage = image;
    BeautyMainViewController *beautyMainVC = [[BeautyMainViewController alloc] init];
    [self.navigationController pushViewController:beautyMainVC animated:YES];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //获取照片失败
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)cameraCountdownViewDidCompleted {
    _beingCountDownSecondsForCapturingPhoto = NO;
    [_countdownView removeFromSuperview];
    [self writePhotoToAsset];
}

- (IBAction)delayTimeSwitchAction:(id)sender {
    if (_delayCaptureMode == DelayCaptureClose) {
        [self.delayTimeBtn setImage:IMAGENAMED(@"icon_delaytime3s_normal") forState:UIControlStateNormal];
        _delayCaptureMode = DelayCapture3s;
    } else if (_delayCaptureMode == DelayCapture3s) {
        [self.delayTimeBtn setImage:IMAGENAMED(@"icon_delaytime6s_normal") forState:UIControlStateNormal];
        _delayCaptureMode = DelayCapture6s;
    } else if (_delayCaptureMode == DelayCapture6s) {
        [self.delayTimeBtn setImage:IMAGENAMED(@"icon_delaytime0s_normal") forState:UIControlStateNormal];
        _delayCaptureMode = DelayCaptureClose;
    }
}
@end
