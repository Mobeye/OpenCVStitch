//
//  CVAVFViewController.m
//  CVOpenStitch
//
//  Created by Francis Visoiu Mistrih on 06/02/2014.
//  Copyright (c) 2014 foundry. All rights reserved.
//

#import "CVWrapper.h"
#import "CVAVFViewController.h"
#import "UIImage+fixOrientation.h"

@interface CVAVFViewController () {
    BOOL isStitching;
    UIImageView *cameraPreview;

    UIButton *stitchButton;
    UIButton *takePhotoButton;
}

@end

@implementation CVAVFViewController

-(void)viewDidAppear:(BOOL)animated
{
    [self.view addSubview:cameraPreview];

    [self.view addSubview:self.lastImageView];

    takePhotoButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [takePhotoButton setFrame:CGRectMake(130, 500, 50, 50)];
    [takePhotoButton addTarget:self action:@selector(captureNow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takePhotoButton];

    stitchButton = [[UIButton alloc] init];
    [stitchButton setTitle:@"Stitch" forState:UIControlStateNormal];
    [stitchButton setFrame:CGRectMake(0, 30, 320, 10)];
    [stitchButton.titleLabel setBackgroundColor:[UIColor redColor]];
    [stitchButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [stitchButton addTarget:self.delegate action:@selector(stitch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stitchButton];

    [self.photoCamera start];
}

- (id)init {
    if (self = [super init]) {
        cameraPreview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.photoCamera = [[CvPhotoCamera alloc] initWithParentView:cameraPreview];
        self.photoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
        self.photoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetPhoto;
        self.photoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
        self.photoCamera.defaultFPS = 30;

        self.lastImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-(self.view.frame.size.width/2), 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.lastImageView setImage:nil];
        [self.lastImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.lastImageView setAlpha:0.5];
        [self.lastImageView setTag:1337];
    }
    return self;
}

- (void)captureNow {
    [self.photoCamera takePicture];
}

@end
