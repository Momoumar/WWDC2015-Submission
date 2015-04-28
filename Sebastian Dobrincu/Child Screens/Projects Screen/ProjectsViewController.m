//
//  ProjectsViewController.m
//  Sebastian Dobrincu
//
//  Created by Sebastian Dobrincu on 20/04/15.
//  Copyright (c) 2015 Sebastian Dobrincu. All rights reserved.
//

#import "ProjectsViewController.h"
#define TAG 99

@implementation ProjectsViewController

#pragma mark - Controller Delegate

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self controllerSetup];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    currentIndex = 0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
            SDCollectionViewCell *ccell = (SDCollectionViewCell*)cell;
            [self positionFrameForCell:ccell];
        }
        if([SDiPhoneVersion deviceSize] == iPhone4inch) self.collectionView.top -= 15;
    });
    
    self.collectionView.alpha = 0;
    [UIView animateKeyframesWithDuration:0.5 delay:0.3 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        self.collectionView.alpha = 1;
    } completion:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.backgroundType = Blur;
    alert.completeButtonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
        
        buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.13 green:0.71 blue:0.45 alpha:1];
        buttonConfig[@"textColor"] = [UIColor colorWithRed:0.997 green:0.995 blue:0.961 alpha:1.000];
        
        return buttonConfig;
    };
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert showInfo:self title:@"Tilt your phone!" subTitle:@"Navigate through my projects by tilting your phone to the left/right. \n To disable it, slide your finger to the right of your top speaker!" closeButtonTitle:@"GOT IT" duration:7.4];
        [self speakText:@"Navigate through my projects by tilting your phone to the left or to the right. \n To disable it, slide your finger to the right of your top speaker!"];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        shouldGoBack = YES;
        accEnabled = YES;
        self.motionManager.accelerometerUpdateInterval = 0.001;
        [self startMyMotionDetect];
        
        
        [UIScreen mainScreen].wantsSoftwareDimming = YES;
        proxCount = 0;
        // Enable proximity sensor
        UIDevice *device = [UIDevice currentDevice];
        [device setProximityMonitoringEnabled:YES];
        [device addObserver:self forKeyPath:@"proximityState" options:NSKeyValueObservingOptionNew context:nil];
        
        
    });
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [self.motionManager stopAccelerometerUpdates];
    
    @try{
        // Disable proximity sensor
        UIDevice *device = [UIDevice currentDevice];
        [device setProximityMonitoringEnabled:NO];
        [device removeObserver:self forKeyPath:@"proximityState"];
        
    }@catch(id anException){
        // The proximity sensor wasn't enabled
    }

}

#pragma mark - CollectionView Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 7;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    currentIndex = indexPath.section;
    SDCollectionViewCell *cell = (SDCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell withIndexPath:indexPath];
    [self positionFrameForCell:cell];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SDCollectionViewCell *ccell = (SDCollectionViewCell*)cell;
    [self positionFrameForCell:ccell];
}

- (void)configureCell:(SDCollectionViewCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    
    UIView *subview = [cell.contentView viewWithTag:TAG];
    [subview removeFromSuperview];
    
    switch (indexPath.section) {
        case 0:
            [cell.playIcon setHidden:YES];
            cell.productImageView.image = [UIImage imageNamed:@"beanflow"];
            cell.titleLabel.text = @"Beanflow";
            cell.descriptionLabel.text = @"Beanflow is the perfect business platform for hybrid stores managing sales, events, rentals and servicing. \nDone for Oceans HQ Ltd.\n Beanflow is fast & features an enjoyable user experience, alongside background data fetching, offline mode, full integration with the web application and many more. The main advantage of the service is the ability to check detailed reports, create sales manually, check statistics and manage your products, all on the go.";
            [cell.moreAboutLabel setTitle:@"MORE ABOUT IT" forState:UIControlStateNormal];
        break;
            
        case 1:
            [cell.playIcon setHidden:YES];
            cell.productImageView.image = [UIImage imageNamed:@"lifebox"];
            cell.titleLabel.text = @"LifeBox";
            cell.descriptionLabel.text = @"LifeBox is a ambitious project that aims at changing the way doctors interact with their patients and vice-versa by providing a full platform for consulting, scheduling appointments, monetizing and way more. As a patient you're able to search for doctors, interact with them, ask question from specific medical fields and more, everything from inside the app. As a doctor you're able to monetize your consults from the app, and make profit by helping patients in your spare time.";
            [cell.moreAboutLabel setTitle:@"MORE ABOUT IT" forState:UIControlStateNormal];
            break;
            
        case 2:
            [cell.playIcon setHidden:NO];
            cell.productImageView.image = [UIImage imageNamed:@"artmarket"];
            cell.titleLabel.text = @"The Art Market";
            [cell.descriptionLabel setText:@"The Art Market is an astonishing art app for iOS. Artists are able to upload art and name their own price for it, while clients are able to purchase it, directly from the application and then download it at full resolution. It features a complete following/followers system, custom animation engine, payment integration (even  Pay!) alongside an interactive feed for browsing/searching art."];
            [cell.moreAboutLabel setTitle:@"MORE ABOUT IT" forState:UIControlStateNormal];
            break;
        case 3:
            [cell.playIcon setHidden:YES];
            cell.productImageView.image = [UIImage imageNamed:@"boatingbay"];
            cell.titleLabel.text = @"BoatingBay";
            cell.descriptionLabel.text = @"BoatingBay is the world’s first free local boating magazine for mobile devices. BoatingBay Magazine is simply the best way to read and explore the world of boating and fishing anywhere, anytime. Built from the ground up, BoatingBay Magazine provides readers with a simple yet intuitive format customized to their physical location. Unlike traditional print magazines, BoatingBay Magazine delivers content on demand, providing readers with the most up to date information available.";
            [cell.moreAboutLabel setTitle:@"MORE ABOUT IT" forState:UIControlStateNormal];
            break;
        case 4:
            [cell.playIcon setHidden:YES];
            cell.productImageView.image = [UIImage imageNamed:@"applewatchcourse"];
            cell.titleLabel.text = @" Watch Course";
            cell.descriptionLabel.text = @"The Complete Apple Watch Course is one of the highest rated WatchKit course on the market. It covers the entire process of building 5 full apps from scratch, for the Apple Watch. Not only it teaches you how to create useful and interesting apps, but it also keeps a close eye on design patterns and assure that the creations look as good as possible, while keeping the episodes short & fun.";
            [cell.moreAboutLabel setTitle:@"MORE ABOUT IT" forState:UIControlStateNormal];
            break;
        case 5:
            [cell.playIcon setHidden:YES];            
            cell.productImageView.image = [UIImage imageNamed:@"whom"];
            cell.titleLabel.text = @"Whom";
            cell.descriptionLabel.text = @"Whom is a social/media iOS App, similar to Instagram & Snapchat. Whom is combining all the great ideas of the top iOS Apps in the market and providing a smooth user experience as well as a great looking UI. The app features smart video recording and displaying, Facebook, SMS and Address Book integration, custom camera interfaces and way more. Whom is soon to be launched on the AppStore.";
            [cell.moreAboutLabel setTitle:@"MORE ABOUT IT" forState:UIControlStateNormal];
            break;
            
        case 6:
            [cell.playIcon setHidden:YES];
            cell.productImageView.image = [UIImage imageNamed:@"more"];
            cell.titleLabel.text = @"Many more";
            cell.descriptionLabel.text = @"Those are just some of the apps I've built for my clients as remote work. I know that I'm at the begining of my journey and for now, I'm just enjoying every bit of it. I am planning to move to London as soon as I finish highschool, where I would finish my college eventually. After that I wish to move to the US, in the Bay Area, where I could follow my dreams and work for/found a big software company (or startup). One of my biggest dreams is to work at Apple one day. That would be one of the biggest achievement in my carrer and I'm working on that (almost) everyday of my life 😄.";
            [cell.moreAboutLabel setTitle:@"MORE ABOUT ME" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
    cell.moreAboutLabel.tag = indexPath.section;
    if(cell.moreAboutLabel.allTargets.count == 0)
        [cell.moreAboutLabel addTarget:self action:@selector(moreAbout:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)positionFrameForCell:(SDCollectionViewCell*)cell{
    
    CGFloat width = 250;
    CGFloat height = 208;
    
    if ([SDiPhoneVersion deviceSize] == iPhone4inch) {
        width = 220;
        height = 150;
    }
    
    CGFloat inset  = self.collectionView.bounds.size.width * (6/64.0f);
    inset = floor(inset);

    cell.descriptionLabel.frame = CGRectMake(0, cell.descriptionLabel.top, width, height);
    [cell.descriptionLabel setCenterX:(self.collectionView.bounds.size.width - (2 *inset))/2];
    if([SDiPhoneVersion deviceSize] == iPhone4inch){
        cell.descriptionLabel.top = 43;
        cell.titleLabel.top = 0;
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 2) {
        NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"ArtProject-Demo" ofType:@"mp4"];
        NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
        MPMoviePlayerViewController *movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
        [self presentMoviePlayerViewControllerAnimated:movieController];
        [movieController.moviePlayer play];
    }
    
}

-(void)moreAbout:(id)sender {
    
    
    switch ([(UIButton*)sender tag]) {
        case 0:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.sebastiandobrincu.com/beanflow"]];
            break;
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.sebastiandobrincu.com/lifebox"]];
            break;
        case 2:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.sebastiandobrincu.com/the-art-project"]];
            break;
        case 3:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.sebastiandobrincu.com/boatingbay"]];
            break;
        case 4:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.sebastiandobrincu.com/apple-watch-course"]];
            break;
        case 5:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.sebastiandobrincu.com/whom"]];
            break;
        case 6:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.sebastiandobrincu.com/about"]];
            break;
        default:
            break;
    }
    
    
}

#pragma mark - Accelerometer

- (CMMotionManager *)motionManager {
    CMMotionManager *motionManager = nil;
    
    id appDelegate = [UIApplication sharedApplication].delegate;
    
    if ([appDelegate respondsToSelector:@selector(motionManager)]) {
        motionManager = [appDelegate motionManager];
    }
    
    return motionManager;
}

- (void)startMyMotionDetect {
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
    
        if (accelerometerData.acceleration.x > 0.5) {
            
            if(self.collectionView.contentOffset.x < self.view.frame.size.width*6+10){
                [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x+9, 0)];
                shouldGoBack = YES;
            }
            
        }else if(accelerometerData.acceleration.x < -0.5){
            
            if(self.collectionView.contentOffset.x > 0){
                [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x-9, 0)];
                shouldGoBack = YES;
            }
        
        }else if(accelerometerData.acceleration.x < 0.3 || accelerometerData.acceleration.x < -0.3){
            
            if((int)self.collectionView.contentOffset.x % (int)self.view.frame.size.width != 0 && shouldGoBack){
                
                shouldGoBack = NO;
                [self.collectionView setContentOffset:CGPointMake((int)[self roundUp:self.collectionView.contentOffset.x andMultiple:(int)self.view.frame.size.width], 0) animated:YES];
            }
            
        }
    
    }];
    
    
    
}

#pragma mark - Additional Methods

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"proximityState"]) {
        
        
        proxCount++;
        if (proxCount == 4) {
            proxCount = 0;
            
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.backgroundType = Blur;
            alert.completeButtonFormatBlock = ^NSDictionary* (void)
            {
                NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
                
               
                buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.13 green:0.71 blue:0.45 alpha:1];
                buttonConfig[@"textColor"] = [UIColor colorWithRed:0.997 green:0.995 blue:0.961 alpha:1.000];
                
                return buttonConfig;
            };
            
            if (accEnabled) {
                accEnabled = NO;
                [self.motionManager stopAccelerometerUpdates];
                NSString *message = @"You successfully disabled the motion scrolling. Slide again to enable it.";
                [alert showSuccess:self title:@"There you go!" subTitle:message closeButtonTitle:@"OK" duration:4.5f];
                [self speakText:message];
                
            }else {
                
                accEnabled = YES;
                NSString *message = @"You successfully activated the motion scrolling. Tilt your phone to navigate. Slide again to disable it.";
                [alert showSuccess:self title:@"Awesome!" subTitle:message closeButtonTitle:@"OK" duration:6.0f];
                [self speakText:message];
                [self startMyMotionDetect];
            }
        
        }
        
    }
}

- (int)roundUp:(int)numToRound andMultiple:(int)multiple {
    if(multiple == 0)
        return numToRound;
    else if(numToRound < 0 || numToRound<multiple/2)
        return 0;
    
    int remainder = numToRound % multiple;
    
    if (remainder == 0)
        return numToRound;
    else if(numToRound + multiple - remainder == multiple*7)
        return numToRound - remainder;

    return numToRound + multiple - remainder;
}

-(void)controllerSetup {
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    UIView *dismissingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    [self.view addSubview:dismissingView];
    [dismissingView addGestureRecognizer:swipeDown];
    
    for (UIView *eachView in self.view.subviews)
        if (eachView.tag == 99) {
            eachView.alpha = 0;
            CGRect fr = eachView.frame;
            fr.origin.x -= self.view.frame.size.width;
            [eachView setFrame:fr];
            
        }else if (eachView.tag == 98)
            eachView.alpha = 0;
    
    
    
    [UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        for (UIView *eachView in self.view.subviews)
            if (eachView.tag == 99) {
                eachView.alpha = 1;
                CGRect fr = eachView.frame;
                fr.origin.x += self.view.frame.size.width;
                [eachView setFrame:fr];
            }
        
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            for (UIView *eachView in self.view.subviews)
                if (eachView.tag == 98)
                    eachView.alpha = 1;
            
        } completion:nil];
    }];
}

-(void)close {
    
    [self stopSpeech];
    [UIView animateWithDuration:0.15 animations:^{
        self.collectionView.alpha = 0;
    }];
    
    [self close:nil];
}

#pragma mark - Speech Methods

- (void)speakText:(NSString *)toBeSpoken {
    
    synthesizer = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:toBeSpoken];
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    utterance.rate = AVSpeechUtteranceMinimumSpeechRate+0.16;
    [synthesizer speakUtterance:utterance];
    
}

- (void)stopSpeech {
    AVSpeechSynthesizer *talked = synthesizer;
    if([talked isSpeaking]) {
        [talked stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@""];
        [talked speakUtterance:utterance];
        [talked stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
}

@end
