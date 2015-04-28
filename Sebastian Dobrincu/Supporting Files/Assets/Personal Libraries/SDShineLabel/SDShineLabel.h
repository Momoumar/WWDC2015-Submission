//
//  SDShineLabel.h
//  Sebastian Dobrincu
//
//  Created by Sebastian Dobrincu on 22/04/15.
//  Copyright (c) 2015 Sebastian Dobrincu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDShineLabel : UILabel

@property (assign, nonatomic, readwrite) CFTimeInterval fadeoutDuration;
@property (assign, nonatomic, readwrite) CFTimeInterval shineDuration;
@property (assign, nonatomic, readwrite, getter = isAutoStart) BOOL autoStart;
@property (assign, nonatomic, readonly, getter = isShining) BOOL shining;
@property (assign, nonatomic, readonly, getter = isVisible) BOOL visible;
- (void)shine;

@end
