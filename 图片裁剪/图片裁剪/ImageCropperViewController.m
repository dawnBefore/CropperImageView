//
//  ImageCropperViewController.m
//  图片裁剪
//
//  Created by 宋浩文的pro on 16/3/26.
//  Copyright © 2016年 宋浩文的pro. All rights reserved.
//

#import "ImageCropperViewController.h"
#import "UIView+Extension.h"
#import <math.h>
#import "Masonry.h"
#import "UIImage+Rotation.h"

static const CGFloat kCropViewHotArea = 50;
static const CGFloat kMinimumCropArea = 50;

static CGFloat distanceBetweenPoints(CGPoint point0, CGPoint point1) {
    return sqrt(pow(point1.x - point0.x, 2) + pow(point1.y - point0.y, 2));
}

#define ToolbarHeight 44
#define RGBCOLOR(R, G, B, ALPHA)   [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:ALPHA]
#define MaskColor RGBCOLOR(0, 0, 0, 0.6)

@interface CropView ()

@property (nonatomic, assign) BOOL isInCenter;

@property (nonatomic, assign) NSUInteger pointLocation;

@property (nonatomic, assign) CGFloat superViewMinX;
@property (nonatomic, assign) CGFloat superViewMaxX;
@property (nonatomic, assign) CGFloat superViewMinY;
@property (nonatomic, assign) CGFloat superViewMaxY;

@property (nonatomic, assign) CGRect originalRect;

@end

@implementation CropView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置自身属性
        self.layer.borderColor = RGBCOLOR(222, 222, 222, 1).CGColor;
        self.layer.borderWidth = 10;
        self.backgroundColor = [UIColor clearColor];
        
        _originalRect = frame;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    _superViewMinX = CGRectGetMinX(self.superview.frame);
    _superViewMaxX = CGRectGetMaxX(self.superview.frame);
    _superViewMinY = CGRectGetMinY(self.superview.frame);
    _superViewMaxY = CGRectGetMaxY(self.superview.frame);
    NSLog(@"%f   %f    %f   %f", _superViewMinX, _superViewMaxX, _superViewMinY, _superViewMaxY);
    
    if ([touches count] == 1) {
        CGPoint location = [[touches anyObject] locationInView:self];
        
        
        CGPoint p0 = CGPointMake(-10, -10);
        CGPoint p1 = CGPointMake(self.frame.size.width+10, -10);
        CGPoint p2 = CGPointMake(-10, self.frame.size.height+10);
        CGPoint p3 = CGPointMake(self.frame.size.width+10, self.frame.size.height+10);
        
        if (distanceBetweenPoints(location, p0) < kCropViewHotArea) {
            _pointLocation = leftTop;
        } else if (distanceBetweenPoints(location, p1) < kCropViewHotArea) {
            _pointLocation = rightTop;
        } else if (distanceBetweenPoints(location, p2) < kCropViewHotArea) {
            _pointLocation = leftBottom;
        } else if (distanceBetweenPoints(location, p3) < kCropViewHotArea) {
            _pointLocation = rightBottom;
        } else {
            _pointLocation = inCenter;
        }
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] == 1) {
        CGPoint location = [[touches anyObject] locationInView:self];
        CGPoint preLocation = [[touches anyObject] previousLocationInView:self];
        CGFloat offX = location.x - preLocation.x;         // 相对上次移动的X
        CGFloat offY = location.y - preLocation.y;         // 相对上次移动的Y
        
        CGRect frame = self.frame;
        
        CGFloat viewWidth = frame.size.width;
        CGFloat viewHeight = frame.size.height;
        CGFloat locationX = location.x;
        CGFloat locationY = location.y;
        
        NSLog(@"%f %f", self.x, offX);
        // 解决拖动中心超出边界问题
        if (self.x + offX < _originalRect.origin.x)
        {
            self.x = _originalRect.origin.x;
            offX = 0;
        }
        if (self.x + self.width + offX > _originalRect.size.width) {
            self.x = _originalRect.size.width - self.width;
            offX = 0;
        }
        if (self.y + offY < _originalRect.origin.y) {
            self.y = _originalRect.origin.y;
            offY = 0;
        }
        if (self.y + self.height + offY > _originalRect.size.height) {
            self.y = _originalRect.size.height - self.height;
            offY = 0;
        }
        
        
        if (_pointLocation == leftTop) {
            
            if ((viewWidth -= locationX) >= kMinimumCropArea) {
#warning 待解决： 扩大裁剪框的时候超出边界问题
                if (self.x + offX > _originalRect.origin.x) {
                    frame.origin.x += location.x;
                    frame.size.width -= location.x;
                } else {
                    self.x = _originalRect.origin.x;
                }
                
            }
            
            if ((viewHeight -= locationY) >= kMinimumCropArea) {
                frame.origin.y += location.y;
                frame.size.height -= location.y;
            }
            
            self.frame = frame;
        } else if (_pointLocation == rightTop) {
 
            if (locationX >= kMinimumCropArea) {
                frame.size.width = location.x;
            }
            if ((viewHeight -= locationY) >= kMinimumCropArea) {
                frame.origin.y += location.y;
                frame.size.height -= location.y;
            }
            self.frame = frame;
        } else if (_pointLocation == leftBottom) {

            
            if ((viewWidth -= locationX) >= kMinimumCropArea) {
                frame.origin.x += location.x;
                frame.size.width -= location.x;
            }
            
            if (locationY >= kMinimumCropArea) {
                frame.size.height = location.y;
            }
      
            self.frame = frame;
        } else if (_pointLocation == rightBottom) {
    
            if (locationX >= kMinimumCropArea) {
                frame.size.width = location.x;
            }
            if (locationY >= kMinimumCropArea) {
                frame.size.height = location.y;
            }
            self.frame = frame;
        } else {
            
            CGPoint viewCenter = self.center;
            viewCenter.x += offX;
            viewCenter.y += offY;
            self.center = viewCenter;
        }
        
        
        
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}


@end





@interface ImageCropperViewController ()

/** image */
@property (nonatomic, strong) UIImage *cropImage;

/** imageView */
@property (nonatomic, strong) UIImageView *cropImageView;

/** 截图框 */
@property (nonatomic, strong) CropView *cropView;

/** 图片原来的大小 */
@property (nonatomic, assign) CGSize orginalSize;

/** 现在的图片size */
@property (nonatomic, assign) CGSize nowSize;

/** 记录旋转后的图片size */
@property (nonatomic, assign) CGSize rotateSize;

// masks
@property (nonatomic, strong) UIView *topMask;
@property (nonatomic, strong) UIView *leftMask;
@property (nonatomic, strong) UIView *bottomMask;
@property (nonatomic, strong) UIView *rightMask;


@property (nonatomic, weak) UIView *toolbar;

@end

@implementation ImageCropperViewController



- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super init]) {
        self.cropImage = image;
        _orginalSize = image.size;
        _cropImageView = [[UIImageView alloc] init];
        _cropImageView.userInteractionEnabled = YES;
        [self.view addSubview:_cropImageView];
        _cropImageView.image = image;
        
        [self aspectRatio:image.size];
        
        _nowSize = self.cropImageView.size;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 设置底部工具条
    [self setToolbar];
    
}


- (void)setCropView
{
    _cropView = [[CropView alloc] initWithFrame:_cropImageView.bounds];
    [_cropImageView addSubview:_cropView];
    
    
    _topMask = [UIView new];
    _topMask.backgroundColor = MaskColor;
    [self.view addSubview:_topMask];
    [_topMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(_cropView.mas_right);
        make.bottom.equalTo(_cropView.mas_top);
    }];
    
    _leftMask = [UIView new];
    _leftMask.backgroundColor = MaskColor;
    [self.view addSubview:_leftMask];
    [_leftMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(_cropView.mas_top);
        make.right.equalTo(_cropView.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    _bottomMask = [UIView new];
    _bottomMask.backgroundColor = MaskColor;
    [self.view addSubview:_bottomMask];
    [_bottomMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cropView.mas_left);
        make.top.equalTo(_cropView.mas_bottom);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    _rightMask = [UIView new];
    _rightMask.backgroundColor = MaskColor;
    [self.view addSubview:_rightMask];
    [_rightMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cropView.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(_cropView.mas_bottom);
    }];
    
}

- (void)setToolbar
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeigth - ToolbarHeight , ScreenWidth, ToolbarHeight)];
    self.toolbar = toolbar;
    toolbar.backgroundColor = [UIColor lightGrayColor];
    [window addSubview:toolbar];
    
    UIButton *confirmBtn = [[UIButton alloc] init];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    CGFloat btnW = 44;
    CGFloat btnH = 30;
    confirmBtn.frame = CGRectMake(ScreenWidth - btnW, 0, btnW, btnH);
    [toolbar addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rotateBtn = [[UIButton alloc] init];
    [rotateBtn setTitle:@"旋转" forState:UIControlStateNormal];
    rotateBtn.frame = CGRectMake(0, 0, btnW, btnH);
    [toolbar addSubview:rotateBtn];
    [rotateBtn addTarget:self action:@selector(rotateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cutBtn = [[UIButton alloc] init];
    [cutBtn setTitle:@"裁剪" forState:UIControlStateNormal];
    cutBtn.frame = CGRectMake(CGRectGetMaxX(rotateBtn.frame) + 20, 0, btnW, btnH);
    [toolbar addSubview:cutBtn];
    [cutBtn addTarget:self action:@selector(cutBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)cutBtnClicked:(UIButton *)btn
{
    
    
    // 设置截图框
    [self setCropView];
    
}

- (void)rotateBtnClicked:(UIButton *)btn
{
    // 完成旋转
    self.cropImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.cropImageView.transform = CGAffineTransformRotate(self.cropImageView.transform, M_PI_2);
    [UIView commitAnimations];
    
    // 调整宽高
    [UIView animateWithDuration:0.5 animations:^{
        if (_rotateSize.width != 0) {
            _rotateSize = CGSizeMake(_rotateSize.height, _rotateSize.width);
        } else {
            _rotateSize = CGSizeMake(self.cropImage.size.height, self.cropImage.size.width);
        }
        
        [self aspectRatio:_rotateSize];
        _nowSize = self.cropImageView.size;
    }];
    
    
}

- (void)confirmBtnClicked:(UIButton *)btn
{
    [self.toolbar removeFromSuperview];
    
    float rotate = [[self.cropImageView.layer valueForKeyPath:@"transform.rotation.z"] floatValue];
    float zoomScale = [[self.cropImageView.layer valueForKeyPath:@"transform.scale.x"] floatValue];
    NSLog(@"zoomScale %f", zoomScale);
    // 转换坐标系
    CGRect rect = [self.view convertRect:self.cropView.frame toView:self.cropImageView];
    
    NSLog(@"_nowSize: %@", NSStringFromCGSize(_nowSize));
    float imageScale = _orginalSize.width/_nowSize.width;
    
    
    // 解决奇异矩阵的问题
    if((NSInteger)rect.size.width % 2 == 1)
    {
        rect.size.width = ceil(rect.size.width);
    }
    if((NSInteger)rect.size.height % 2 == 1)
    {
        rect.size.height = ceil(rect.size.height);
    }
   
    CGRect nowRect = CGRectMake((NSInteger)(rect.origin.x * imageScale), (NSInteger)(rect.origin.y * imageScale), (NSInteger)(rect.size.width * imageScale), (NSInteger)(rect.size.height * imageScale));
    NSLog(@"nowRect: %@", NSStringFromCGRect(nowRect));
    
    UIImage *rotInputImage = [self.cropImageView.image imageRotatedByRadians:rotate];
    CGImageRef tmp = CGImageCreateWithImageInRect([rotInputImage CGImage], nowRect);
    UIImage *image = [UIImage imageWithCGImage:tmp scale:self.cropImageView.image.scale orientation:self.cropImageView.image.imageOrientation];
    
    if ([self.delegate respondsToSelector:@selector(imageCropperViewController:didFinishScreenShots:)]) {
        [self.delegate imageCropperViewController:self didFinishScreenShots:image];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}

// 宽高比自适应屏幕
- (void)aspectRatio:(CGSize)imageSize
{
    CGFloat imageRatio = imageSize.height / imageSize.width;
    CGFloat screenRatio = (ScreenHeigth - ToolbarHeight) / ScreenWidth;
    if (imageRatio > screenRatio) {
        _cropImageView.height = ScreenHeigth - ToolbarHeight;
        _cropImageView.width = imageSize.width * (_cropImageView.height) / imageSize.height;
        _cropImageView.y = 0;
        _cropImageView.x = ScreenWidth / 2 - _cropImageView.width / 2;
    } else {
        
        _cropImageView.width = ScreenWidth;
        _cropImageView.height = self.cropImageView.width * imageSize.height / imageSize.width;
        _cropImageView.x = 0;
        _cropImageView.y = (ScreenHeigth - ToolbarHeight) / 2 - _cropImageView.height / 2;
    }
}


@end
