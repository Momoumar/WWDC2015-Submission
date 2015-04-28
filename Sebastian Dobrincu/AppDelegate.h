//
//  AppDelegate.h
//  Sebastian Dobrincu
//
//  Created by Sebastian Dobrincu on 19/04/15.
//  Copyright (c) 2015 Sebastian Dobrincu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "ProjectsViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    CMMotionManager *motionManager;
}

@property (readonly) CMMotionManager *motionManager;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ProjectsViewController *pvc;

@end

