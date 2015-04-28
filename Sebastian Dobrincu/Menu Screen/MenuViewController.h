//
//  MenuViewController.h
//  Sebastian Dobrincu
//
//  Created by Sebastian Dobrincu on 19/04/15.
//  Copyright (c) 2015 Sebastian Dobrincu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MenuTableViewCell.h"
#import "SDiPhoneVersion.h"
#import "SDShineLabel.h"
#import "EducationViewController.h"
#import "UITableView+Frames.h"
#import "AboutViewController.h"
#import "ProjectsViewController.h"
#import "Sebastian_Dobrincu-Swift.h"
#import "GradientProgressView.h"
#import "SCLAlertView.h"

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, AVSpeechSynthesizerDelegate>{
    AVSpeechSynthesizer *synthesizer;
    NSArray *titles;
    NSArray *subtitles;
    NSArray *bgImage;
    NSArray *bgColors;
    NSMutableArray *selectedItems;
    SDShineLabel *moreLabel;
    CAGradientLayer *gradient;
    NSArray *gradiendHues;
    int grIndex;
    GradientProgressView* progressView;
    BOOL shouldAnimate;
}

@property (nonatomic, strong) NSMutableArray *items;

@end
