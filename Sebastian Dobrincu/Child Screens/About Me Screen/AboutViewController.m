//
//  AboutViewController.m
//  Sebastian Dobrincu
//
//  Created by Sebastian Dobrincu on 19/04/15.
//  Copyright (c) 2015 Sebastian Dobrincu. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
static NSString * const FirebaseURL = @"INSERT FIREBASE URL HERE";
static NSString * const mapTitle = @"My Sweet Home 🏡";
static NSString * const mapSubtitle = @"This is where the magic happens.";
static float const lat = 44.4292981;
static float const lon = 26.1036473;
static float const boxCornerRadius = 8;

#pragma mark - Controller Delegates

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create the data-source
    messageIndex = 0;
    messagesArray = @[@"My name is Sebastian. 👱🏼",
                      @"I'm 16 yo and I'm from Bucharest, Romania. 🏰",
                      @"In my free time I like to watch good 🎬.",
                      @"Or have fun with my friends 🎉.",
                      @"I often 📖 and 🏊🏼.",
                      @"Oh, I like 🍕 as well!",
                      @"Swipe left to see where I grew up. 🏡",
                      @"Draw me something! I'll see it in real time ⌚️"];

    
    
    [self initFireBase];
    [self loadDrawView];
    
    _drawView.alpha = 0;
    infoLabel.alpha = 0;
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.cell addGestureRecognizer:swipeDown];
    
    for (UIView *eachView in self.view.subviews) {
        if (eachView.tag == 99) {
            eachView.alpha = 0;
            CGRect fr = eachView.frame;
            fr.origin.x -= self.view.frame.size.width;
            [eachView setFrame:fr];
            
        }else if (eachView.tag == 98)
            eachView.alpha = 0;
        
    }
    
    [UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        for (UIView *eachView in self.view.subviews) {
            if (eachView.tag == 99) {
                eachView.alpha = 1;
                CGRect fr = eachView.frame;
                fr.origin.x += self.view.frame.size.width;
                [eachView setFrame:fr];
            }
        }
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
            for (UIView *eachView in self.view.subviews)
                if (eachView.tag == 98)
                    eachView.alpha = 1;
            
        } completion:nil];
    }];

    _drawView.transform =  CGAffineTransformMakeScale(0, 0);
    infoLabel.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.5 delay:0.2 usingSpringWithDamping:35 initialSpringVelocity:25 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        infoLabel.transform = CGAffineTransformMakeScale(1, 1);
        infoLabel.alpha = 1;
        _drawView.transform = CGAffineTransformMakeScale(1, 1);
        _drawView.alpha = 1;
    } completion:^(BOOL finished) {

        if(finished) [self animateText];
    }];
    
}

-(void)close{
    
    [shadowView removeFromSuperview];
    [shadowView2 removeFromSuperview];
    [shadowView3 removeFromSuperview];
    
    [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:10 initialSpringVelocity:6 options:UIViewAnimationOptionCurveEaseInOut animations:^{

        if (scrollView.currentPage == 0) {
            
            [infoLabel.layer removeAllAnimations];
            messageIndex = messagesArray.count-1;
            _drawView.transform = CGAffineTransformMakeTranslation(0, 450);
            infoLabel.transform = CGAffineTransformMakeTranslation(0, 450);
            _drawView.alpha = 0;
            infoLabel.alpha = 0;

        }else if(scrollView.currentPage == 1){
            
            mapLabel.transform = CGAffineTransformMakeTranslation(0, 450);
            map.transform = CGAffineTransformMakeTranslation(0, 450);
            distanceLabel.transform = CGAffineTransformMakeTranslation(0, 450);
            map.alpha = 0;
            mapLabel.alpha = 0;
            distanceLabel.alpha = 0;
        
        }else if(scrollView.currentPage == 2){
         
            bgImage.transform = CGAffineTransformMakeTranslation(0, 450);
            socialLabel.transform = CGAffineTransformMakeTranslation(0, 450);
            bgImage.alpha = 0;
            socialLabel.alpha = 0;
            
        }
        
    } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self close:nil];
    });
}

- (void)dealloc {
    [self.firebase removeObserverWithHandle:self.childAddedHandle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && [self.view window] == nil) {
        self.view = nil;
        self.drawView = nil;
        self.colorButton = nil;
    }
}

#pragma mark - Firebase & Drawing board

-(void)initFireBase{
    
    self.firebase = [[Firebase alloc] initWithUrl:FirebaseURL];
    
    self.paths = [NSMutableArray array];
    self.outstandingPaths = [NSMutableSet set];

    __weak AboutViewController *weakSelf = self;
    
    self.childAddedHandle = [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        if ([weakSelf.outstandingPaths containsObject:snapshot.key]) {
    
        } else {
    
            FDPath *path = [FDPath parse:snapshot.value];
            if (path != nil) {
    
                if (weakSelf.drawView != nil)
                    [weakSelf.drawView addPath:path];
                
                [weakSelf.paths addObject:path];
                
            } else {
                NSLog(@"Not a valid path: %@ -> %@", snapshot.key, snapshot.value);
            }
        }
    }];
    
}

- (void)colorButtonPressed {

    FDColorPickController *cpc = [[FDColorPickController alloc] initWithColor:self.drawView.drawColor];
    cpc.delegate = self;
    
    UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:cpc];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)clearButtonPressed {
    
    [self.firebase removeValue];
    [self.drawView clearPoints];
    
}

- (void)colorPicker:(FDColorPickController *)colorPicker didPickColor:(UIColor *)color {
    
    self.drawView.drawColor = color;
    
    self.colorButton.backgroundColor = self.drawView.drawColor;
    self.colorButton.layer.backgroundColor = self.drawView.drawColor.CGColor;
    self.colorButton.layer.borderColor = [self darkerColorForColor:self.drawView.drawColor].CGColor;

}

- (void)drawView:(FDDrawView *)view didFinishDrawingPath:(FDPath *)path {

    Firebase *pathRef = [self.firebase childByAutoId];
    NSString *name = pathRef.key;

    [self.outstandingPaths addObject:name];
    
    [pathRef setValue:[path serialize] withCompletionBlock:^(NSError *error, Firebase *ref) {
        [self.outstandingPaths removeObject:name];
    }];
}

- (void)loadDrawView {
    
    scrollView = [[ALScrollViewPaging alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100)];
    if ([SDiPhoneVersion deviceSize] == iPhone4inch) scrollView.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-90);
    scrollView.showsHorizontalScrollIndicator = NO;
    [scrollView setHasPageControl:NO];
    [scrollView setPageControlOtherPagesColor:[UIColor colorWithWhite:0.705 alpha:0.440]];
    [scrollView setPageControlCurrentPageColor:[UIColor colorWithWhite:0.968 alpha:1.000]];
    
    NSMutableArray *views = [[NSMutableArray alloc] init];
    
    infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-100, 50)];
    [infoLabel setCenter:CGPointMake(scrollView.frame.size.width/2, 105)];
    if([SDiPhoneVersion deviceSize] == iPhone4inch) [infoLabel setCenter:CGPointMake(scrollView.frame.size.width/2, 125)];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.numberOfLines = 0;
    infoLabel.font = [UIFont fontWithName:@"SourceSansPro-Bold" size:19.5];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.text = @"Hey there! 👋🏼😄";
    
    self.drawView = [[FDDrawView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    if([SDiPhoneVersion deviceSize] == iPhone4inch) self.drawView.frame = CGRectMake(0, 0, 265, 265);
    self.drawView.center = CGPointMake(scrollView.frame.size.width/2, 305);
    self.drawView.layer.cornerRadius = boxCornerRadius;
    self.drawView.clipsToBounds = YES;
    
    for (FDPath *path in self.paths)
        [self.drawView addPath:path];
    self.drawView.userInteractionEnabled = YES;
    self.drawView.delegate = self;
    
    self.clearButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.clearButton.layer.cornerRadius = 20;
    self.clearButton.clipsToBounds = YES;
    self.clearButton.backgroundColor = [UIColor colorWithWhite:0.374 alpha:1.000];
    self.clearButton.layer.backgroundColor = [UIColor colorWithWhite:0.374 alpha:1.000].CGColor;
    self.clearButton.layer.borderColor = [self darkerColorForColor:[UIColor colorWithWhite:0.374 alpha:1.000]].CGColor;
    self.clearButton.layer.borderWidth = 6;
    [self.clearButton setImage:[UIImage imageNamed:@"icon-clear"] forState:UIControlStateNormal];
    [self.clearButton setTintColor:[UIColor whiteColor]];
    
    self.colorButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.colorButton.layer.cornerRadius = 20;
    self.colorButton.clipsToBounds = YES;
    self.colorButton.backgroundColor = self.drawView.drawColor;
    self.colorButton.layer.backgroundColor = self.drawView.drawColor.CGColor;
    self.colorButton.layer.borderColor = [self darkerColorForColor:self.drawView.drawColor].CGColor;
    self.colorButton.layer.borderWidth = 6;
    
    
    [self.colorButton addTarget:self
                         action:@selector(colorButtonPressed)
               forControlEvents:UIControlEventTouchUpInside];
    CGSize viewSize = self.drawView.frame.size;
    CGSize buttonSize = CGSizeMake(40, 40);
    self.colorButton.frame = CGRectMake(viewSize.width - buttonSize.width - 10,
                                        viewSize.height - buttonSize.height - 10,
                                        buttonSize.width,
                                        buttonSize.height);
    self.colorButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.drawView addSubview:self.colorButton];
    
    
    [self.clearButton addTarget:self
                         action:@selector(clearButtonPressed)
               forControlEvents:UIControlEventTouchUpInside];
    self.clearButton.frame = CGRectMake(viewSize.width - buttonSize.width - 10-50,
                                        viewSize.height - buttonSize.height - 10,
                                        buttonSize.width,
                                        buttonSize.height);
    self.clearButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.drawView addSubview:self.clearButton];
    
    [self configureMap];
    [self configureProfile];
    
    distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, map.frame.origin.y+map.frame.size.height+10, self.view.frame.size.width-100, 50)];
    [distanceLabel setCenter:CGPointMake(scrollView.frame.size.width/2, 490)];
    if([SDiPhoneVersion deviceSize] == iPhone4inch) [distanceLabel setCenter:CGPointMake(scrollView.frame.size.width/2, 465)];
    distanceLabel.textAlignment = NSTextAlignmentCenter;
    distanceLabel.numberOfLines = 1;
    distanceLabel.font = [UIFont fontWithName:@"SourceSansPro-Bold" size:15];
    distanceLabel.textColor = [UIColor whiteColor];
    distanceLabel.alpha = 0;

    shadowView = [self setShadowPropertiesForFrame:self.drawView.frame];
    shadowView3 = [self setShadowPropertiesForFrame:bgImage.frame];
    
    for (int i = 0; i < 3; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
        [view setBackgroundColor:[UIColor clearColor]];
        
        if(i==0){
            [view addSubview:infoLabel];
            [view addSubview:shadowView];
            [view addSubview:self.drawView];
            
        }else if(i==1){
            [view addSubview:mapLabel];
            [view addSubview:shadowView2];
            [view addSubview:map];
            [view addSubview:distanceLabel];
            
        }else if(i==2){
            [view addSubview:shadowView3];
            [view addSubview:bgImage];
            [view addSubview:socialLabel];
            
        }
        
        [views addObject:view];
    }
    scrollView.pinchGestureRecognizer.delegate = self;
    [scrollView addPages:views];
    [self.view addSubview:scrollView];
    scrollView.panGestureRecognizer.cancelsTouchesInView = NO;
    
    [UIView animateWithDuration:0.7 delay:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        shadowView.alpha = 1;
        shadowView2.alpha = 1;
        shadowView3.alpha = 1;
    } completion:nil];
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}

#pragma mark - Profile

-(void)configureProfile{
    bgImage = [[UIImageView alloc] initWithFrame:self.drawView.frame];
    bgImage.clipsToBounds = YES;
    bgImage.layer.cornerRadius = boxCornerRadius;
    bgImage.image = [UIImage imageNamed:@"avatar"];
    bgImage.contentMode = UIViewContentModeScaleAspectFill;
    bgImage.userInteractionEnabled = YES;
    
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    visualEffectView.frame = bgImage.bounds;
    [bgImage addSubview:visualEffectView];
    
    UIImageView *avatarImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 170, 170)];
    [avatarImage setCenter: CGPointMake(bgImage.frame.size.width/2, bgImage.frame.size.height/2.55)];
    avatarImage.image = [UIImage imageNamed:@"avatar"];
    avatarImage.contentMode = UIViewContentModeScaleAspectFill;
    avatarImage.clipsToBounds = YES;
    avatarImage.layer.cornerRadius = boxCornerRadius;
    [bgImage addSubview:avatarImage];
    
    
    UIButton *twitterIcon = [[UIButton alloc] initWithFrame:CGRectMake(avatarImage.frame.origin.x+15, avatarImage.frame.origin.y+avatarImage.frame.size.height+20, 60, 60)];
    if([SDiPhoneVersion deviceSize] == iPhone4inch) [twitterIcon setFrame:CGRectMake(avatarImage.frame.origin.x+15, avatarImage.frame.origin.y+avatarImage.frame.size.height+10, 50, 50)];
    [twitterIcon.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [twitterIcon setImage:[UIImage imageNamed:@"twitter"] forState:UIControlStateNormal];
    [twitterIcon setBackgroundColor:[UIColor colorWithRed:0.11 green:0.69 blue:0.92 alpha:1]];
    twitterIcon.clipsToBounds = YES;
    twitterIcon.layer.cornerRadius = twitterIcon.frame.size.width/2;
    [twitterIcon addTarget:self action:@selector(twitterButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [bgImage addSubview:twitterIcon];

    UIButton *webIcon = [[UIButton alloc] initWithFrame:CGRectMake(twitterIcon.frame.origin.x+90, twitterIcon.frame.origin.y, 60, 60)];
    if([SDiPhoneVersion deviceSize] == iPhone4inch) [webIcon setFrame:CGRectMake(twitterIcon.frame.origin.x+90, twitterIcon.frame.origin.y, 50, 50)];
    [webIcon.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [webIcon setImage:[UIImage imageNamed:@"safari"] forState:UIControlStateNormal];
    [webIcon setBackgroundColor:[UIColor colorWithRed:0.34 green:0.73 blue:0.13 alpha:1]];
    webIcon.clipsToBounds = YES;
    webIcon.layer.cornerRadius = webIcon.frame.size.width/2;
    [webIcon addTarget:self action:@selector(webButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [bgImage addSubview:webIcon];
    
    socialLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-100, 50)];
    [socialLabel setCenter:CGPointMake(scrollView.frame.size.width/2, 105)];
    if([SDiPhoneVersion deviceSize] == iPhone4inch) [socialLabel setCenter:CGPointMake(scrollView.frame.size.width/2, 125)];
    socialLabel.textAlignment = NSTextAlignmentCenter;
    socialLabel.numberOfLines = 0;
    socialLabel.font = [UIFont fontWithName:@"SourceSansPro-Bold" size:19.5];
    socialLabel.textColor = [UIColor whiteColor];
    socialLabel.text = @"And that's me. Let's get in touch! 🍹";

    
}

#pragma mark - Map View & Location

- (void)configureMap{
    
    map = [[MKMapView alloc] initWithFrame:self.drawView.frame];
    map.showsUserLocation = YES;
    map.layer.cornerRadius = boxCornerRadius;
    map.clipsToBounds = YES;
    map.delegate = self;
    map.pitchEnabled = YES;
    map.showsBuildings = YES;
    map.showsPointsOfInterest = YES;
    map.zoomEnabled = YES;
    map.scrollEnabled = YES;
    MKPointAnnotation *myHome = [[MKPointAnnotation alloc]init];
    myHome.title = mapTitle;
    myHome.subtitle = mapSubtitle;
    CLLocationCoordinate2D pinCoordinate;
    pinCoordinate.latitude = lat;
    pinCoordinate.longitude = lon;
    myHome.coordinate = pinCoordinate;
    [map addAnnotation:myHome];
    [map setRegion:MKCoordinateRegionMake(pinCoordinate, MKCoordinateSpanMake(1, 1))];
    [map selectAnnotation:myHome animated:YES];
    
    MKMapCamera *mapCamera = [[MKMapCamera alloc] init];
    mapCamera.centerCoordinate = CLLocationCoordinate2DMake(lat,lon);
    mapCamera.pitch = 56.754679;
    mapCamera.altitude = 251.147165;
    mapCamera.heading = 0;
    map.camera = mapCamera;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestWhenInUseAuthorization];
    }
#endif
    [self.locationManager startUpdatingLocation];
    
    mapLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-100, 50)];
    [mapLabel setCenter:CGPointMake(scrollView.frame.size.width/2, 105)];
    if([SDiPhoneVersion deviceSize] == iPhone4inch) [mapLabel setCenter:CGPointMake(scrollView.frame.size.width/2, 125)];
    mapLabel.textAlignment = NSTextAlignmentCenter;
    mapLabel.numberOfLines = 0;
    mapLabel.font = [UIFont fontWithName:@"SourceSansPro-Bold" size:19.5];
    mapLabel.textColor = [UIColor whiteColor];
    mapLabel.text = @"This is where I live. In the 💛 of Bucharest.";
    
    shadowView2 = [self setShadowPropertiesForFrame:map.frame];
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    CLLocation *currentLocation = [[CLLocation alloc]
                               initWithLatitude:userLocation.coordinate.latitude
                               longitude:userLocation.coordinate.longitude];
    
    CLLocation *myLocation = [[CLLocation alloc]
                                initWithLatitude:lat
                                longitude:lon];
    
    CLLocationDistance distance = [currentLocation distanceFromLocation:myLocation];

    distanceLabel.text = [NSString stringWithFormat:@"P.S: We are %4.0f miles away ✈️.", distance*0.00062137 ];
    [UIView animateWithDuration:0.4 animations:^{
        distanceLabel.alpha = 1;
    }];
    
    [self.locationManager stopUpdatingLocation];

}

#pragma mark - Social Buttons

-(void)twitterButtonPressed{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/Sebyddd"]];

}

-(void)webButtonPressed{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://sebastiandobrincu.com"]];

}


#pragma mark - Additional Methods

-(void)animateText{
    
    float seconds = 1;
    if (messageIndex==0)
        seconds = 0.35;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView transitionWithView:infoLabel duration:1.f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
            infoLabel.text = messagesArray[messageIndex];
        } completion:^(BOOL finished) {
            if(finished && messageIndex!=messagesArray.count-1){
                messageIndex++;
                [self animateText];
            }
        }];
    });
    
}


- (UIColor *)darkerColorForColor:(UIColor *)c {
    
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.1, 0.0)
                               green:MAX(g - 0.1, 0.0)
                                blue:MAX(b - 0.1, 0.0)
                               alpha:a];
    return nil;
}


-(UIView*)setShadowPropertiesForFrame:(CGRect)frame{
    
    CGRect shadowFrame = frame;
    shadowFrame.size.width -= 8;
    shadowFrame.size.height -= 8;
    shadowFrame.origin.x += 4;
    shadowFrame.origin.y += 4;
    UIView *shadow = [[UIView alloc] initWithFrame:shadowFrame];
    shadow.alpha = 0;
    [shadow setBackgroundColor:[UIColor whiteColor]];
    shadow.clipsToBounds = NO;
    [shadow.layer setMasksToBounds:NO];
    [shadow.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [shadow.layer setShadowOffset:CGSizeMake(-6.5, 6.5)];
    [shadow.layer setShadowRadius:4.55];
    [shadow.layer setShadowOpacity:0.42];
    
    return shadow;
}

@end
