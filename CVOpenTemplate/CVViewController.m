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
    UIImagePickerController *imagePicker;
    BOOL isStitching;
}

@end

@implementation CVViewController

- (void)viewDidLoad {
    imageArray = [NSMutableArray array];
    imagePicker = [[UIImagePickerController alloc] init];
    isStitching = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (!isStitching) {
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES; //TODO disable editing
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;

        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"Stitch" forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, 30, 320, 10)];
        [button.titleLabel setBackgroundColor:[UIColor redColor]];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [button addTarget:self action:@selector(stitch) forControlEvents:UIControlEventTouchUpInside];
        [imagePicker.view addSubview:button];

        [self presentModalViewController:imagePicker animated:YES];
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
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    [self.spinner startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        UIImage* stitchedImage = [CVWrapper processWithArray:imageArray];
        dispatch_async(dispatch_get_main_queue(), ^{

            NSLog (@"stitchedImage %@",stitchedImage);
            if (!stitchedImage) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Stitch error" message:@"Couldn't stitch the provided images" delegate:self cancelButtonTitle:@":(" otherButtonTitles:nil];
                [alert show];
            }

            UIImageWriteToSavedPhotosAlbum(stitchedImage, nil, nil, nil);

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