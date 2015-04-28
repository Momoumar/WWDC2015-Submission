//
//  AboutViewController.h
//  Sebastian Dobrincu
//
//  Created by Sebastian Dobrincu on 19/04/15.
//  Copyright (c) 2015 Sebastian Dobrincu. All rights reserved.
//

#import "SDTransitionViewController.h"
#import "FDDrawView.h"
#import "FDColorPickController.h"
#import "NKOColorPickerView.h"
#import <Firebase/Firebase.h>
#import <MapKit/MapKit.h>
#import "ALScrollViewPaging.h"
#import "UIView+RSAdditions.h"

@interface AboutViewController : SDTransitionViewController <FDDrawViewDelegate, FDColorPickerDelegate, UIGestureRecognizerDelegate, MKMapViewDelegate, CLLocationManagerDelegate>{
    ALScrollViewPaging *scrollView;
    UIView *shadowView;
    UIView *shadowView2;
    UIView *shadowView3;
    UIImageView *bgImage;
    UILabel *infoLabel;
    UILabel *mapLabel;
    UILabel *distanceLabel;
    UILabel *socialLabel;
    NSMutableArray *_cameras;
    NSInteger messageIndex;
    NSArray *messagesArray;
    MKMapView *map;
}

@property (nonatomic, strong) Firebase *firebase;
@property (nonatomic, strong) NSMutableArray *paths;
@property (nonatomic, strong) FDDrawView *drawView;
@property (nonatomic, strong) UIButton *colorButton;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) NSMutableSet *outstandingPaths;
@property (nonatomic) FirebaseHandle childAddedHandle;
@property(nonatomic, retain) CLLocationManager *locationManager;

@end
