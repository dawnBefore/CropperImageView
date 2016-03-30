//
//  ImageCropperViewController.h
//  图片裁剪
//
//  Created by 宋浩文的pro on 16/3/26.
//  Copyright © 2016年 宋浩文的pro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    leftTop,
    rightTop,
    leftBottom,
    rightBottom,
    inCenter
}pointLocation;


@interface CropView : UIView



@end

@class ImageCropperViewController;
@protocol ImageCropperViewControllerDelegate <NSObject>

- (void)imageCropperViewController:(ImageCropperViewController *)imageCropperViewController didFinishScreenShots:(UIImage *)image;

@end


@interface ImageCropperViewController : UIViewController

@property (nonatomic, strong) UIImage  *image;

- (instancetype)initWithImage:(UIImage *)image;



@property (nonatomic, assign) id<ImageCropperViewControllerDelegate> delegate;

@end
