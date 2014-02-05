//
//  CVViewController.m
//  CVOpenTemplate
//
//  Created by Washe on 02/01/2013.
//  Copyright (c) 2013 foundry. All rights reserved.
//

#import "CVViewController.h"
#import "CVWrapper.h"

@interface CVViewController () {
    NSMutableArray *imageArray;
    UIImagePickerController *picker;
    BOOL isStitching;
}

@end

@implementation CVViewController

- (void)viewDidLoad {
    imageArray = [NSMutableArray array];
    picker = [[UIImagePickerController alloc] init];
    isStitching = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (!isStitching) {
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;

        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"Stitch" forState:UIControlStateNormal];
        [button setFrame:CGRectMake(30, 200, 100, 30)];
        [button addTarget:self action:@selector(stitch) forControlEvents:UIControlEventTouchUpInside];
        [picker.view addSubview:button];

        [self presentModalViewController:picker animated:YES];

    }

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [imageArray addObject:chosenImage];
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [picker dismissModalViewControllerAnimated:YES];

}

- (void) stitch
{
    isStitching = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.spinner startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        UIImage* stitchedImage = [CVWrapper processWithArray:imageArray];
        dispatch_async(dispatch_get_main_queue(), ^{

            NSLog (@"stitchedImage %@",stitchedImage);
            if (!stitchedImage) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"dff" message:@"dfdsf" delegate:self cancelButtonTitle:@"don" otherButtonTitles:@"sd", nil];
                [alert show];
            }
            UIImageView* imageView = [[UIImageView alloc] initWithImage:stitchedImage];
            self.imageView = imageView;
            [self.scrollView addSubview:imageView];
            self.scrollView.backgroundColor = [UIColor blackColor];
            self.scrollView.contentSize = self.imageView.bounds.size;
            self.scrollView.maximumZoomScale = 4.0;
            self.scrollView.minimumZoomScale = 0.05;
            self.scrollView.contentOffset = CGPointMake(-(self.scrollView.bounds.size.width-self.imageView.bounds.size.width)/2, -(self.scrollView.bounds.size.height-self.imageView.bounds.size.height)/2);
            NSLog (@"scrollview contentSize %@",NSStringFromCGSize(self.scrollView.contentSize));
            [self.spinner stopAnimating];

        });
    });
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
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


@end