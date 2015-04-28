//
//  GradientProgressView.m
//  Sebastian Dobrincu
//
//  Created by Sebastian Dobrincu on 20/04/15.
//  Copyright (c) 2015 Sebastian Dobrincu. All rights reserved.
//

#import "GradientProgressView.h"

@implementation GradientProgressView

@synthesize animating, progress;

- (id)initWithFrame:(CGRect)frame {
    
    if ((self = [super initWithFrame:frame])) {
        
        // Use a horizontal gradient
        CAGradientLayer *layer = (id)[self layer];
        [layer setStartPoint:CGPointMake(0.0, 0)];
        [layer setEndPoint:CGPointMake(0, 15)];
        
        // Set color datasource
        [layer setColors:@[(id)[UIColor colorWithRed:0.13 green:0.81 blue:0.67 alpha:1].CGColor,
                           (id)[UIColor colorWithRed:0.11 green:0.67 blue:0.87 alpha:1].CGColor,
                           
                           (id)[UIColor colorWithRed:0 green:0.65 blue:0.91 alpha:1].CGColor,
                           (id)[UIColor colorWithRed:0.32 green:0.4 blue:0.95 alpha:1].CGColor,
                           
                           (id)[UIColor colorWithRed:0.38 green:0.33 blue:0.93 alpha:1].CGColor,
                           (id)[UIColor colorWithRed:0.58 green:0.24 blue:0.84 alpha:1].CGColor,
                           
                           
                           (id)[UIColor colorWithRed:0.730 green:0.415 blue:0.195 alpha:1.000].CGColor,
                           (id)[UIColor colorWithRed:0.803 green:0.769 blue:0.260 alpha:1.000] .CGColor,
                           
                           (id)[UIColor colorWithRed:0.487 green:0.730 blue:0.210 alpha:1.000].CGColor,
                           (id)[UIColor colorWithRed:0.264 green:0.870 blue:0.484 alpha:1.000].CGColor,
                           
                           (id)[UIColor colorWithRed:0.26 green:0.81 blue:0.64 alpha:1.000].CGColor,
                           (id)[UIColor colorWithRed:0.1 green:0.36 blue:0.62 alpha:1.000].CGColor
                           ]];
        
        maskLayer = [CALayer layer];
        [maskLayer setFrame:CGRectMake(0, 0, 0, frame.size.height)];
        [maskLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
        [layer setMask:maskLayer];
    }
    return self;
}

+ (Class)layerClass {
    // Tells UIView to use CAGradientLayer as our backing layer
    return [CAGradientLayer class];
}

- (void)setProgress:(CGFloat)value {
    
    if (progress != value) {
        progress = MIN(1.0, fabs(value));
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews {
    
    // Resize our mask layer based on the current progress
    CGRect maskRect = [maskLayer frame];
    maskRect.size.width = CGRectGetWidth([self bounds]) * progress;
    [maskLayer setFrame:maskRect];
}

- (NSArray *)shiftColors:(NSArray *)colors {
    
    // Moves the last item in the array to the front shifting all the other elements.
    NSMutableArray *mutable = [colors mutableCopy];
    id last = [mutable lastObject];
    [mutable removeLastObject];
    [mutable insertObject:last atIndex:0];
    return [NSArray arrayWithArray:mutable];
}

- (void)performAnimation {
    
    // Update the colors on the model layer
    CAGradientLayer *layer = (id)[self layer];
    NSArray *fromColors = [layer colors];
    NSArray *toColors = [self shiftColors:fromColors];
    [layer setColors:toColors];
    
    // Create an animation to slowly move the hue gradient left to right.
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    [animation setFromValue:fromColors];
    [animation setToValue:toColors];
    [animation setDuration:0.9];
    [animation setRemovedOnCompletion:YES];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [animation setDelegate:self];
    
    // Add the animation to our layer
    [layer addAnimation:animation forKey:@"animateGradient"];
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
    if ([self isAnimating])
        [self performAnimation];
}

- (void)startAnimating {
    
    if (![self isAnimating]) {
        animating = YES;
        [self performAnimation];
    }
}

- (void)stopAnimating {
    
    if ([self isAnimating])
        animating = NO;
    
}

@end
