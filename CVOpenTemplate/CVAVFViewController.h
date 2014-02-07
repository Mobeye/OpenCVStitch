//
//  CVAVFViewController.h
//  CVOpenStitch
//
//  Created by Francis Visoiu Mistrih on 06/02/2014.
//  Copyright (c) 2014 foundry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/CGImageProperties.h>
#import <AVFoundation/AVFoundation.h>
#import <opencv2/highgui/cap_ios.h>

@interface CVAVFViewController : UIViewController

@property CvPhotoCamera *photoCamera;

@property id delegate;

@property UIImageView *lastImageView;

@end
