//
//  ViewController.m
//  Sebastian Dobrincu
//
//  Created by Sebastian Dobrincu on 19/04/15.
//  Copyright (c) 2015 Sebastian Dobrincu. All rights reserved.
//

#import "ViewController.h"
#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

@implementation ViewController

#pragma mark - Controller Delegates

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create camera session
    session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetMedium;
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    captureVideoPreviewLayer.frame = self.cameraView.frame;
    CGRect bounds = self.cameraView.layer.bounds;
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    captureVideoPreviewLayer.bounds = bounds;
    captureVideoPreviewLayer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    [self.cameraView.layer addSublayer:captureVideoPreviewLayer];
    // Select camera
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input)
        // Handle the error appropriately.
        NSLog(@"ERROR: trying to open camera: %@", error);
    else{
        [session addInput:input];
        [session startRunning];
    }
    
    // Apply blur effect to camera view
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
    blurView.frame = self.cameraView.frame;
    [self.view addSubview:blurView];

    // Add blurred image
    UIImageView *blurImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blur"]];
    blurImage.clipsToBounds = YES;
    blurImage.contentMode = UIViewContentModeScaleAspectFill;
    blurImage.alpha = 0.78f;
    blurImage.frame = self.view.frame;
    [self.view addSubview:blurImage];
    
    // Add avatar image view
    UIImageView *avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 136, 136)];
    [avatarImage setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/4)];
    avatarImage.contentMode = UIViewContentModeScaleAspectFill;
    [avatarImage setImage:[UIImage imageNamed:@"me"]];
    avatarImage.clipsToBounds = YES;
    avatarImage.layer.cornerRadius = avatarImage.frame.size.width/2;
    avatarImage.layer.borderColor = [UIColor whiteColor].CGColor;
    avatarImage.layer.borderWidth = 3;
    [self.view addSubview:avatarImage];
    
    // Add arrow icon
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [icon setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-50)];
    if ([SDiPhoneVersion deviceSize] == iPhone4inch)
        icon.frame = CGRectMake(icon.frame.origin.x, icon.frame.origin.y, 40, 40);
    icon.contentMode = UIViewContentModeScaleAspectFit;
    icon.image = [UIImage imageNamed:@"icon-arrow"];
    [self.view addSubview:icon];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, avatarImage.frame.origin.y+avatarImage.frame.size.height+8, self.view.frame.size.width, 50)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:27];
    if ([SDiPhoneVersion deviceSize] == iPhone4inch)
        nameLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:26];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = @"Sebastian Dobrincu";
    [self.view addSubview:nameLabel];

    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, nameLabel.frame.origin.y+nameLabel.frame.size.height+20, self.view.frame.size.width-100, 200)];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:19];
    descriptionLabel.textColor = [UIColor whiteColor];
    descriptionLabel.text = @"Hi! I’m a software developer living in Bucharest, Romania 🌇. Most of my days are spent writing Objective-C and Swift.";
    if ([SDiPhoneVersion deviceSize] == iPhone4inch) {
        [descriptionLabel setFrame:CGRectMake(30, nameLabel.frame.origin.y+nameLabel.frame.size.height+20, self.view.frame.size.width-60, 130)];
        descriptionLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:17];
    }
    [self.view addSubview:descriptionLabel];
    
    // Create Swipable Area
    UIView *swipableArea = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-250, self.view.frame.size.width, 250)];
    [self.view addSubview:swipableArea];
    
    // Create swipe gesture
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedUp:)];
    swipeGesture.enabled = NO;
    swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [swipableArea addGestureRecognizer:swipeGesture];

    avatarImage.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(200));
    avatarImage.transform = CGAffineTransformMakeScale(0, 0);
    nameLabel.alpha = 0;
    descriptionLabel.transform = CGAffineTransformMakeTranslation(-descriptionLabel.frame.size.width-50, 0);
    icon.transform = CGAffineTransformMakeTranslation(0, 100);
    
    [UIView animateWithDuration:0.45 delay:0 usingSpringWithDamping:10 initialSpringVelocity:40 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        

        avatarImage.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(140));
        avatarImage.transform = CGAffineTransformMakeScale(1, 1);

        nameLabel.alpha = 1;

    } completion:^(BOOL finished) {

        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:15 initialSpringVelocity:50 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
            descriptionLabel.transform = CGAffineTransformMakeTranslation(0, 0);
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.3 animations:^{
                if([SDiPhoneVersion deviceSize] != iPhone35inch)
                    icon.transform = CGAffineTransformMakeTranslation(0, 0);
                
            } completion:^(BOOL finished2) {
                
                if (finished && finished2) {
                    
                    if([SDiPhoneVersion deviceSize] != iPhone35inch){
                        swipeGesture.enabled = YES;
                        [self recursiveFloatingAnimation:icon];
                    }else{
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Ooops!" message:@"Sorry! You need at least an iPhone 5 to explore my app." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                  
                }
            }];
            
        }];
        
    }];
}

-(void)viewDidDisappear:(BOOL)animated{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [session stopRunning];
    });
}

#pragma mark - Floating Animation

-(void)recursiveFloatingAnimation:(UIView*)view{
    
    // Abort recursive animation
    if (!view)
        return;
    
    CGPoint oldPoint = CGPointMake(view.frame.origin.x, view.frame.origin.y);
    [UIView animateWithDuration:0.6
                     animations: ^{ view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y - 15, view.frame.size.width, view.frame.size.height); }
                     completion:
     ^(BOOL finished) {
         
         if (finished) {
             
             [UIView animateWithDuration:0.6
                              animations:^{ view.frame = CGRectMake(oldPoint.x, oldPoint.y, view.frame.size.width, view.frame.size.height);}
                              completion:
              ^(BOOL finished2) {
                  
                  if(finished2)
                      [self recursiveFloatingAnimation:view];
              }];
             
         }
     }];
}

#pragma mark - Swipe Gesture Recognizer

-(void)swipedUp:(UISwipeGestureRecognizer*)gestureRecognizer{
    // Stop the floating animation to avoid blocking the main thread
    [self recursiveFloatingAnimation:nil];
    
    // Go to the main menu screen
    [self performSegueWithIdentifier:@"bottom" sender:self];
}


@end
