//
//  ViewController.m
//  图片裁剪
//
//  Created by 宋浩文的pro on 16/3/26.
//  Copyright © 2016年 宋浩文的pro. All rights reserved.
//

#import "ViewController.h"
#import "ImageCropperViewController.h"

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, ImageCropperViewControllerDelegate>{
    //图片2进制路径
    NSString* filePath;
}
@property (weak, nonatomic) IBOutlet UIImageView *screenShotImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.screenShotImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.screenShotImageView.clipsToBounds = YES;
    self.screenShotImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editImage:)];
    [self.screenShotImageView addGestureRecognizer:tapGR];
}

- (void)editImage:(UITapGestureRecognizer *)tapGR
{
    ImageCropperViewController *imageCropperVC = [[ImageCropperViewController alloc] initWithImage:self.screenShotImageView.image];
    imageCropperVC.image = self.screenShotImageView.image;
    NSLog(@"imageView的image: %@", self.screenShotImageView.image);
    imageCropperVC.delegate = self;
    [self presentViewController:imageCropperVC animated:YES completion:nil];
}




//当选择一张图片后进入这里
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.screenShotImageView.image = image;

        NSLog(@"原生image: %@", image);
        
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    //关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imageCropperViewController:(ImageCropperViewController *)imageCropperViewController didFinishScreenShots:(UIImage *)image
{
    self.screenShotImageView.image = image;
}


//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}


- (IBAction)openMenu:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"标题" message:@"这个是UIAlertController" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"%@",action);
    }];
    
    __typeof(self) weakSelf = self;
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"打开照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf takePhoto];
    }];
    
    UIAlertAction *pictureAction = [UIAlertAction actionWithTitle:@"从手机相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf LocalPhoto];
    }];
    
    [alertController addAction:photoAction];
    [alertController addAction:pictureAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}


@end
