//
//  ViewController.h
//  Sebastian Dobrincu
//
//  Created by Sebastian Dobrincu on 19/04/15.
//  Copyright (c) 2015 Sebastian Dobrincu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SDiPhoneVersion.h"

@interface ViewController : UIViewController <UIGestureRecognizerDelegate> {
    UISwipeGestureRecognizer *swipeGesture;
    AVCaptureSession *session;
}

@property (strong, nonatomic) IBOutlet UIView *cameraView;
@property (strong, nonatomic) IBOutlet UIView *avatarView;

@end

