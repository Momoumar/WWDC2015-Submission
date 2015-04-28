//
//  ProjectsViewController.h
//  Sebastian Dobrincu
//
//  Created by Sebastian Dobrincu on 20/04/15.
//  Copyright (c) 2015 Sebastian Dobrincu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDTransitionViewController.h"
#import "SDCollectionViewCell.h"
#import "UIView+RSAdditions.h"
#import "SDFlowLayout.h"
#import <CoreMotion/CoreMotion.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SCLAlertView.h"
#import <AVFoundation/AVFoundation.h>

@interface ProjectsViewController : SDTransitionViewController <UICollectionViewDataSource, UICollectionViewDelegate> {
    AVSpeechSynthesizer *synthesizer;
    CGFloat cellwidth;
    NSInteger currentIndex;
    BOOL shouldGoBack;
    int proxCount;
    BOOL accEnabled;
}

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end
