//
//  BeautyMainViewController.m
//  GoCamera
//
//  Created by Tomwu on 2017/5/6.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import "BeautyMainViewController.h"
#import "PECropViewController.h"

#import "CustomButton.h"
#import "PaintingView.h"
#import "FilterControl.h"
#import "CancelConfirmView.h"
#import "BeautyMainTopView.h"
#import "BeautyMainBottomView.h"
#import "BeautyMainMiddleView.h"
#import "ShowItemScrollView.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

#import "ImageModel.h"
#import "ImageHelper.h"
#import "GoCamera-Swift.h"

#import "FilterViewController.h"
#import "FilterValueModel.h"
#import "ProgressHUD.h"

@interface BeautyMainViewController ()
<
    BeautyMainTopViewDelegate,
    BeautyMainBottomViewDelegate,
    BeautyMainMiddleViewDelegate,
    PECropViewControllerDelegate,
    CancelConfirmViewDelegate,
    ShowItemScrollViewDelegate,
    FilterControlDelegate
> {
    BOOL isNeedAddTask;
}

@property (nonatomic, strong) BeautyMainTopView *mainTopView;
@property (nonatomic, strong) BeautyMainBottomView *mainBottomView;
@property (nonatomic, strong) BeautyMainMiddleView *mainMiddleView;
@property (nonatomic, strong) UIView *mainBackBottomView;
@property (nonatomic, strong) PaintingView *paintingView;
@property (nonatomic, strong) NSArray *magicDataArray;
@property (nonatomic, strong) CancelConfirmView *cancelConfirmView;
@property (nonatomic, strong) ShowItemScrollView *itemScrollView;
@property (nonatomic, strong) FilterControl *filterControlView;
@property (nonatomic, strong) APMosaicView *mosaicView;
@property (nonatomic, strong) SSTaskManager *taskManager;

@end

@implementation BeautyMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isNeedAddTask = YES;
    [self addMainTopView];
    [self addMainMiddleView];
    [self addMainBottomView];
    [self createTaskManager];
    [self addTask:[ImageModel shareInstance].currentImage];
    [[ImageModel shareInstance] addObserver:self forKeyPath:kCurrentImage options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)dealloc {
    [[ImageModel shareInstance] removeObserver:self forKeyPath:kCurrentImage];
}

- (NSArray *)magicDataArray {
    if (!_magicDataArray) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            [array addObject:[NSString stringWithFormat:@"pic%d",i]];
        }
        _magicDataArray = [array copy];
    }
    return _magicDataArray;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)redoButtonPressed:(UIButton *)sender {
    SSTask *task = [self.taskManager redo];
    if (task) {
        UIImage *image = task.image;
        isNeedAddTask = NO;
        [ImageModel shareInstance].currentImage = image;
    }
    [self updateUndoRedoButtonStates];
}

- (void)undoButtonPressed:(UIButton *)sender {
    SSTask *task = [self.taskManager undo];
    if (task) {
        UIImage *image = task.image;
        isNeedAddTask = NO;
        [ImageModel shareInstance].currentImage = image;
    }
    [self updateUndoRedoButtonStates];
}

- (void)shareButtonPressed:(UIButton *)sender {
    [self saveImageToPhotos:[ImageModel shareInstance].currentImage];
}

//实现该方法
- (void)saveImageToPhotos:(UIImage*)savedImage
{
    [ProgressHUD show:@"Please wait..."];
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

//回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
        [ProgressHUD showError:msg];
    }else{
        msg = @"保存图片成功" ;
        [ProgressHUD showSuccess:msg];
    }
    
//    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Picture Saved"
//                                                                       message:msg
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
//                                                            style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action) {}];
//    [alertView addAction:defaultAction];
//
//    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)beautyBottomButtonPressed:(UIButton *)sender {
    
    NSInteger buttonTag = sender.tag - kBeautyMainBottomButtonStartTag;
    
    switch (buttonTag) {
        case 0:{
            PECropViewController *editVC = [[PECropViewController alloc]init];
            editVC.delegate = self;
            UIImage *image = [ImageModel shareInstance].currentImage;
            editVC.image = image;
            CGFloat width = image.size.width;
            CGFloat height = image.size.height;
            CGFloat length = MIN(width, height);
            editVC.imageCropRect = CGRectMake((width - length) / 2,(height - length) / 2, length, length);
            [self.navigationController pushViewController:editVC animated:YES];
        }
            break;
        case 1: {
            [self showFilterVC];
        }
            break;
        case 2: {
            [self addItemScrollViewWithArray:self.magicDataArray];
            [self addCancelConfirmView:sender.titleLabel.text];
            [self switchToDetailViewWithAnimation];
            if (self.paintingView != nil) {
                [self.paintingView removeFromSuperview];
            }
            self.paintingView = [[PaintingView alloc] initWithFrame:CGRectMake(0, 0, self.mainMiddleView.mainMiddleScrollView.imageView.frame.size.width, self.mainMiddleView.mainMiddleScrollView.imageView.frame.size.height)];
            self.paintingView.backgroundColor = [UIColor clearColor];
            [self.mainMiddleView.mainMiddleScrollView.imageView addSubview:self.paintingView];
            [self.paintingView setstampPicName:@"pic0"];
            self.paintingView.imageSize = 30;
        }
            break;
        case 3: {
            [self addMosaicView];
            [self addCancelConfirmView:sender.titleLabel.text];
            [self addFilterControView];
            [self switchToDetailViewWithAnimation];
            [_mosaicView setPathColor:[UIColor whiteColor] strokeColor:[UIColor blackColor]];
        }
            break;
            
        default:
            break;
    }
}

- (void)compareImageViewTaped:(UILongPressGestureRecognizer *)longPressGesture {
    
}

- (void)cropViewController:(PECropViewController *)controller
    didFinishCroppingImage:(UIImage *)croppedImage {
    [ImageModel shareInstance].currentImage = croppedImage;
}

- (void)cancelButtonPressed {
    [self resetBeautyMainViewWithAnimation];
}

- (void)confirmButtonPressed {
    [self resetBeautyMainViewWithAnimation];
    [ImageModel shareInstance].currentImage = [ImageHelper saveViewToImage:self.mainMiddleView.mainMiddleScrollView.imageView];
}

- (void)itemScrollButtonPressed:(UIButton *)button {
    if (self.paintingView) {
        [self.paintingView setstampPicName:[NSString stringWithFormat:@"pic%ld",(button.tag - 11030)]];
    }
}

- (void)selectedFilterIndex:(NSInteger)index {
    _mosaicView.sizeBrush = (CGFloat)(index * 20.0);
}

#pragma mark - PrivateMethods

- (void)addMainTopView {
    self.mainTopView = [[BeautyMainTopView alloc] initWithFrame:CGRectMake(0,  0, KScreenWidth, 44)];
    self.mainTopView.beautyMainTopViewDelegate = self;
    [self.view addSubview:self.mainTopView];
}

- (void)addMainMiddleView {
    self.mainMiddleView = [[BeautyMainMiddleView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - kBeautyMainBottomHeight - 44)];
    self.mainMiddleView.beautyMainMiddleDelegate = self;
    [self.view addSubview:self.mainMiddleView];
}

- (void)addMainBottomView {
    self.mainBottomView = [[BeautyMainBottomView alloc] initWithFrame:CGRectMake(10, KScreenHeight - kBeautyMainBottomHeight, KScreenHeight - 20, kBeautyMainBottomHeight)];
    self.mainBottomView.beautyMainBottomViewDelegate = self;
    self.mainBackBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, kBeautyMainBottomHeight)];
    [self.view addSubview:self.mainBottomView];
    [self.view addSubview:self.mainBackBottomView];
}

- (void)addItemScrollViewWithArray:(NSArray *)array {
    self.itemScrollView = [[ShowItemScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kBeautyMainBottomHeight) imageArray:array];
    self.itemScrollView.itemScrollViewDelegate = self;
    [_mainBackBottomView addSubview:self.itemScrollView];
}

- (void)addCancelConfirmView:(NSString *)title {
    self.cancelConfirmView = [[CancelConfirmView alloc] initWithFrame:CGRectMake(0, -44, KScreenWidth, 44)];
    self.cancelConfirmView.title = title;
    self.cancelConfirmView.cancelConfirmViewDelegate = self;
    [self.view addSubview:self.cancelConfirmView];
}

- (void)addFilterControView {
    if (_filterControlView == nil) {
        _filterControlView = [[FilterControl alloc] initWithFrame:CGRectMake(KScreenWidth/4, 0, KScreenWidth/2, kBeautyMainBottomHeight)];
    }
    _filterControlView.delegate = self;
    [_mainBackBottomView addSubview:_filterControlView];
}

- (void)addMosaicView {
    _mosaicView = [[APMosaicView alloc] initWithFrame:CGRectMake(0, 0, _mainMiddleView.mainMiddleScrollView.imageView.bounds.size.width, _mainMiddleView.mainMiddleScrollView.imageView.bounds.size.height)];
    UIImageView *mosaicImageView = [[UIImageView alloc] initWithFrame:_mosaicView.frame];
    UIImage *mosaicImage = [ImageHelper pixelImage:_mainMiddleView.mainMiddleScrollView.imageView.image];
    mosaicImageView.image = mosaicImage;
    [_mosaicView setHiddenView:mosaicImageView];
    [_mainMiddleView.mainMiddleScrollView.imageView addSubview:_mosaicView];
    [self addFilterControView];
}

- (void)createTaskManager {
    [SSTask emptyDirectory];
    self.taskManager = [[SSTaskManager alloc] init];
    [self.taskManager reset];
}

- (void)addTask:(UIImage *)image {
    SSTask *task = [[SSTask alloc] init];
    task.image = image;
    task = [self.taskManager addTask:task];
    [self updateUndoRedoButtonStates];
}

- (void)updateUndoRedoButtonStates {
    self.mainTopView.undoButton.enabled = [self.taskManager undoable];
    self.mainTopView.redoButton.enabled = [self.taskManager redoable];
}

- (void)updateImageView {
    if (isNeedAddTask) {
        if ([ImageModel shareInstance].currentImage) {
            [self addTask:[ImageModel shareInstance].currentImage];
        }
    }
    isNeedAddTask = YES;
    self.mainMiddleView.mainMiddleScrollView.imageView.image = [ImageModel shareInstance].currentImage;
    [self.mainMiddleView.mainMiddleScrollView setImageSize];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (keyPath == kCurrentImage) {
        [self updateImageView];
    }
    
}

#pragma mark - Animation
- (void)switchToDetailViewWithAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        [self setY:KScreenHeight view:self.mainBottomView];
        [self setY:-self.mainTopView.frame.size.height view:self.mainTopView];
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.3 animations:^{
                [self setY:KScreenHeight - kBeautyMainBottomHeight view:self.mainBackBottomView];
                [self setY:0 view:self.cancelConfirmView];
            } completion:^(BOOL finished) {
                
            }];
        }
    }];
}

- (void)resetBeautyMainViewWithAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        self.itemScrollView.alpha = 0;
        self.filterControlView.alpha = 0;
        self.cancelConfirmView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self setY:KScreenHeight view:self.mainBackBottomView];
            [self.itemScrollView removeFromSuperview];
            [self.cancelConfirmView removeFromSuperview];
            [self.filterControlView removeFromSuperview];
            [UIView animateWithDuration:0.3 animations:^{
                [self setY:(KScreenHeight - kBeautyMainBottomHeight) view:self.mainBottomView];
                [self setY:0 view:self.mainTopView];
            } completion:^(BOOL finished) {
                [self.paintingView removeFromSuperview];
                [self.mosaicView removeFromSuperview];
            }];
        }
    }];
}

- (void)setY:(CGFloat)y view:(UIView *)view {
    view.frame = CGRectMake(view.frame.origin.x, y, view.frame.size.width, view.frame.size.height);
}

- (void) showFilterVC {
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    [imageArray addObject:[ImageModel shareInstance].currentImage];
    
    NSMutableArray *filterValueArray = [[NSMutableArray alloc] init];
    [filterValueArray addObject:[[FilterValueModel alloc] init]];
    
    FilterViewController *vc = [[FilterViewController alloc] init];
    vc.imageArray = imageArray;
    vc.filterValueArray = filterValueArray;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
