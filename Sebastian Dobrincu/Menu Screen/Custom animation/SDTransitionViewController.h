//
//  SDTransitionViewController.h
//  Sebastian Dobrincu
//
//  Created by Sebastian Dobrincu on 19/04/15.
//  Copyright (c) 2015 Sebastian Dobrincu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDMenuItem.h"
#import "SDiPhoneVersion.h"

@class SDMenuItem;

@interface SDTransitionViewController : UIViewController

@property (nonatomic, strong) NSDictionary *sourceFrames;
@property (nonatomic, strong) SDMenuItem *item;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, copy) UIColor *cellBackgroundColor;

#pragma mark - IB
@property (nonatomic, weak) IBOutlet UIView *cell;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, weak) IBOutlet UIView *backgroundView;

#pragma mark - Properties
@property (nonatomic, strong) NSDictionary *targetFrames;
@property (nonatomic, strong) UIColor *backgroundColor;

#pragma mark - Functions
- (void)__bindItem;
- (void)__buildTargetFrames;
- (void)__switchToSourceFrames:(BOOL)isSource;

- (IBAction)close:(id)sender;



@end
