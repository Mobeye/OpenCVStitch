//
//  CVViewController.m
//  CVOpenTemplate
//
//  Created by Washe on 02/01/2013.
//  Copyright (c) 2013 foundry. All rights reserved.
//

#import "CVViewController.h"
#import "CVWrapper.h"
#import "CVAVFViewController.h"
#import "UIImage+fixOrientation.h"

@interface CVViewController () {
    NSMutableArray *imageArray;
    CVAVFViewController *camera;
    BOOL isStitching;
    UIImageView *outputImageView;
}

@end

@implementation CVViewController

- (void)viewDidLoad {
    imageArray = [NSMutableArray array];
    isStitching = NO;
    camera = [[CVAVFViewController alloc] init];
    [camera setDelegate:self];
    [camera.photoCamera setDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (!isStitching) {
        [self presentViewController:camera animated:YES completion:nil];
    }
}

- (void)photoCamera:(CvPhotoCamera *)photoCamera capturedImage:(UIImage *)image {

    UIImage *images = [image fixOrientation];


    CGSize imageSize = images.size;

    NSLog(NSStringFromCGSize(imageSize));

    [imageArray addObject:images];
    for (UIView *view in self.view.subviews) {
        if (view.tag == 1337) {
            [view removeFromSuperview];
        }
    }

    if (imageArray.count > 0) {
        UIImage *lastimg = (UIImage *)imageArray.lastObject;
        [camera.lastImageView setImage:lastimg];
        [camera reloadInputViews];
    }
}

- (void)photoCameraCancel:(CvPhotoCamera *)photoCamera {

}

- (void) stitch
{
    isStitching = YES;
    [camera dismissViewControllerAnimated:YES completion:nil];
    [self.spinner startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        UIImage* stitchedImage = [CVWrapper processWithArray:imageArray];
        dispatch_async(dispatch_get_main_queue(), ^{

            NSLog (@"stitchedImage %@",stitchedImage);
            if (!stitchedImage) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Stitch error" message:@"Couldn't stitch the provided images" delegate:self cancelButtonTitle:@":(" otherButtonTitles:nil];
                [alert show];
            } else {
                UIImageWriteToSavedPhotosAlbum(stitchedImage, nil, nil, nil);

                outputImageView = [[UIImageView alloc] initWithImage:stitchedImage];
                self.imageView = outputImageView;
                [self.scrollView addSubview:outputImageView];
                self.scrollView.backgroundColor = [UIColor blackColor];
                self.scrollView.contentSize = self.imageView.bounds.size;
                self.scrollView.maximumZoomScale = 4.0;
                self.scrollView.minimumZoomScale = 0.05;
                self.scrollView.contentOffset = CGPointMake(-(self.scrollView.bounds.size.width-self.imageView.bounds.size.width)/2, -(self.scrollView.bounds.size.height-self.imageView.bounds.size.height)/2);
                NSLog (@"scrollview contentSize %@",NSStringFromCGSize(self.scrollView.contentSize));
            }
            
            [self.spinner stopAnimating];

        });
    });
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - scroll view delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


- (IBAction)retry:(id)sender {
    imageArray = [NSMutableArray array];
    isStitching = NO;
    camera = [[CVAVFViewController alloc] init];
    [camera setDelegate:self];
    [camera.photoCamera setDelegate:self];
    [outputImageView removeFromSuperview];
    [self presentViewController:camera animated:YES completion:nil];
}
@end