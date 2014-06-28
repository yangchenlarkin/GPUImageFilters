//
//  ViewController.m
//  GPUImageWaveFilterDemo
//
//  Created by 杨晨 on 6/28/14.
//  Copyright (c) 2014 剑川道长. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "GPUImage.h"
#import "GPUImageWaveFilter.h"

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) UISlider *slider;

@end

@implementation ViewController

#pragma mark - load views

- (void)viewDidLoad {
  [super viewDidLoad];
  [self loadNavigationItem];
  [self loadSlider];
  [self loadImageView];
}

- (void)loadNavigationItem {
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相机" style:UIBarButtonItemStyleDone target:self action:@selector(camera)];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStyleDone target:self action:@selector(album)];
}

- (void)loadSlider {
  self.slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 64 + 320, 280, 44)];
  self.slider.minimumValue = 0;
  self.slider.maximumValue = 10;
  [self.view addSubview:self.slider];
  
  [self.slider addTarget:self action:@selector(slider:) forControlEvents:UIControlEventValueChanged];
}

- (void)loadImageView {
  self.showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 320, 320)];
  [self.view addSubview:self.showImageView];
}

#pragma mark - image picker

- (void)camera {
  [self picker:UIImagePickerControllerSourceTypeCamera];
}

- (void)album {
  [self picker:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

- (void)picker:(UIImagePickerControllerSourceType)type {
  UIImagePickerController *vc = [[UIImagePickerController alloc] init];
  vc.delegate = self;
  vc.sourceType = type;
  [self.navigationController presentViewController:vc animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
  if ([info[UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage]) {
    self.originImage = [self manageImage:info[UIImagePickerControllerOriginalImage]];
    self.showImageView.image = self.originImage;
    [self managerImageFrame];
  }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - image manager

- (UIImage *)manageImage:(UIImage *)image {
  return image.size.width > image.size.height ? [self resizeImage:image toHeight:320] : [self resizeImage:image toWidth:320];
}

- (UIImage *)resizeImage:(UIImage *)image toHeight:(CGFloat)height {
  CGRect rect = CGRectMake(0, 0, image.size.width * height / image.size.height, height);
  UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
  [image drawInRect:rect];
  UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
  return resultImage;
}

- (UIImage *)resizeImage:(UIImage *)image toWidth:(CGFloat)width {
  CGRect rect = CGRectMake(0, 0, width, image.size.height * width / image.size.width);
  UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
  [image drawInRect:rect];
  UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
  return resultImage;
}

- (void)managerImageFrame {
  CGSize imageSize = self.originImage.size;
  CGRect frame;
  if (imageSize.width > imageSize.height) {
    imageSize = CGSizeMake(320, imageSize.height * (320 / imageSize.width));
    frame.size = imageSize;
    frame.origin = CGPointMake(0, 64 + (320 - imageSize.height) / 2);
  } else {
    imageSize = CGSizeMake(imageSize.width * (320 / imageSize.height), 320);
    frame.size = imageSize;
    frame.origin = CGPointMake((320 - imageSize.width) / 2, 64);
  }
  
  self.showImageView.frame = frame;
}

#pragma mark - slider action

- (void)slider:(UISlider *)slider {
  if (self.originImage) {
    GPUImageWaveFilter *filter = [[GPUImageWaveFilter alloc] init];
    filter.normalizedPhase = slider.value;
    self.showImageView.image = [filter imageByFilteringImage:self.originImage];
  }
}

@end
