//
//  CVViewController.h
//  CVOpenTemplate
//
//  Created by Washe on 02/01/2013.
//  Copyright (c) 2013 foundry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/highgui/cap_ios.h>

@interface CVViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CvPhotoCameraDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* spinner;
@property (nonatomic, weak) IBOutlet UIImageView* imageView;
@property (nonatomic, weak) IBOutlet UIScrollView* scrollView;
@end
